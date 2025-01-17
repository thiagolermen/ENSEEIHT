import java.rmi.RemoteException;
import java.util.Set;

public interface Server_itf extends java.rmi.Remote {
	// architecture nécessaire au démarrage : serveur dans registry, 
	// tous sites enregistrés auprès du serveur
	// enregistre un site et récupère la liste complète (cardinal connu au lancement)
	public Set<Client_itf> addClient(Client_itf client) throws RemoteException;

	// nommage des objets partagés
	public int lookup(String name) throws java.rmi.RemoteException;
	// create+bind
	public int publish(String name, Object o, boolean reset, Client_itf client) throws RemoteException;
	// liste des noms enregistrés
	public String[] list() throws RemoteException;

	// le serveur centralise (-> ordonne) les écritures. Renvoie le numéro de version
	public void write(int idObject, Object value) throws RemoteException;

	// instrumentation
	public Set<Client_itf> setMonitor(Monitor_itf m) throws RemoteException;
	public Monitor_itf getMonitor() throws RemoteException;
}