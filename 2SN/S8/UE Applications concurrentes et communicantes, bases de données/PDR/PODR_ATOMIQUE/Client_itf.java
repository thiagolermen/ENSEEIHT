public interface Client_itf extends java.rmi.Remote {
	public void reportValue(int idObject, CallbackReader_itf rcb) throws java.rmi.RemoteException;
	public void update(int idObject, int version, Object value) throws java.rmi.RemoteException;
	public void addObject(int idObject, String name, Object value) throws java.rmi.RemoteException;
	// instrumentation : fournit un nom pour le site, fixé à l'initialisation
	public String getSite() throws java.rmi.RemoteException;
	public Object getObj(String name) throws java.rmi.RemoteException;
	public int getVersion(String name) throws java.rmi.RemoteException;
	public void setMonitor(Monitor_itf monitor) throws java.rmi.RemoteException;
}