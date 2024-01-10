// Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioRedacteur implements LectRed
{
	private int nbLecteurs;
	private boolean ecriture;
	private int nbRedacteurs;
	private Condition lecturePossible;
	private Condition ecriturePossible;
	
	private Lock moniteur;

    public LectRed_PrioRedacteur()
    {
    	this.nbLecteurs = 0;
    	this.ecriture = false;
    	this.nbRedacteurs = 0;
    	
    	this.moniteur = new ReentrantLock();
    	this.lecturePossible = moniteur.newCondition();
    	this.ecriturePossible = moniteur.newCondition();
    	
    }

    public void demanderLecture() throws InterruptedException
    {
    	moniteur.lock();
    	while (ecriture || nbRedacteurs > 0) {
    		lecturePossible.await();
    	}
    	nbLecteurs++;
    	lecturePossible.signal();
    	moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException
    {
    	moniteur.lock();
    	nbLecteurs--;
    	if (nbLecteurs == 0) {
    		ecriturePossible.signal();
    	}
    	moniteur.unlock();
    	
    }

    public void demanderEcriture() throws InterruptedException
    {
    	moniteur.lock();
    	nbRedacteurs++;
    	while (ecriture || nbLecteurs > 0) {
    		ecriturePossible.await();
    	}
    	ecriture = true;
    	nbRedacteurs--;
    	moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException
    {
    	moniteur.lock();
    	ecriture = false;
    	nbRedacteurs--;
    	ecriturePossible.signal();
    	moniteur.unlock();
    }

    public String nomStrategie()
    {
        return "Stratégie: Priorité Rédacteurs.";
    }
}
