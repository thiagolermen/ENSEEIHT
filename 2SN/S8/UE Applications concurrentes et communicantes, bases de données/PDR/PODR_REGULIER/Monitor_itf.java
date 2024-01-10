import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Monitor_itf extends Remote {
	public void greenLight(String site, int factor) throws RemoteException; 
	// minimal (indistinct, pas de trace) 

	public void signal(String event, String site, int idRegistry) throws RemoteException; 
	// événement = "DE","TE","DL",TL"
}