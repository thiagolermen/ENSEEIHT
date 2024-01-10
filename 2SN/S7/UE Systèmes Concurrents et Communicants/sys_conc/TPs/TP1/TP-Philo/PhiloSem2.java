// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem2 implements StrategiePhilo {

    /****************************************************************/
	// APPROCHE 2
	private static Semaphore [] fourchette;
    public PhiloSem2 (int nbPhilosophes) {
    	nb = nbPhilosophes;
    	philosophes = new Semaphore[nbPhilosophes];
    	philosophesStates = new EtatPhilosophe[nbPhilosophes];
    	for(int k = 0; k < nbPhilosophes; k++) {
    	    philosophes[k] = new Semaphore(0);
            philosophesStates[k] = EtatPhilosophe.Pense;
    	}
    	mutex = new Semaphore(1, true);
    }
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException{
    	this.mutex.acquire()
    	if (philosophesStates[Main.PhiloGauche(no)] != EtatPhilosophe.Mange || philosophesStates[Main.PhiloDroite(no)] != EtatPhilosophe.Mange) {
    		philosophesStates[no] = EtatPhilosophe.Mange;
    		this.mutex.release();
    	}else {
    		philosophesStates[no] = EtatPhilosophe.Demande;
    		this.mutex.release();
    		this.philosophes[no].acquire();
    	}
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no){
    	this.mutex.acquire()
    	philosophesStates[no] = EtatPhilosophe.Pense;
    	if (philosophesStates[philosophesStates[Main.PhiloGauche(no)] == EtatPhilosophe.Demande && (philosophesStates[Main.PhiloGauche(no)] == EtatPhilosophe.Mange || philosophesStates[Main.PhiloDroite(no)] != EtatPhilosophe.Mange)) {
    		philosophesStates[Main.PhiloGauche(no)] = EtatPhilosophe.Mange;
    		this.philosophes[Main.PhiloGauche(no)].release();
    	}else if (philosophesStates[philosophesStates[Main.PhiloDroite(no)] == EtatPhilosophe.Demande && (philosophesStates[Main.PhiloGauche(no)] == EtatPhilosophe.Mange || philosophesStates[Main.PhiloDroite(no)] != EtatPhilosophe.Mange)){
    		philosophesStates[Main.PhiloDroite(no)] = EtatPhilosophe.Mange;
    		this.philosophes[Main.PhiloDroite(no)].release();
    	}
    	
    	this.mutex.release()
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie 1";
    }

}

