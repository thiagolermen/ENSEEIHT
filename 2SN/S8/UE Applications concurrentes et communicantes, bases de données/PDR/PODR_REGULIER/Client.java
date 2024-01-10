import java.net.InetAddress;
import java.rmi.Naming;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Set;

public class Client extends UnicastRemoteObject implements Client_itf{
    // Mapping of ID with SharedObjects corresponding to the objects with taken or cached lock (for a given client)
	private static HashMap<Integer, SharedObject_itf> possessedObjects;
    // Mapping of Name with SharedObjects of a given client
    private static HashMap<String, SharedObject_itf> localRegistry;
	// Reference to the server
	private static Server_itf server;
	// The instance of the client we send to the server (especially in ordre to make possible eventual callbacks)
	private static Client_itf client;
    // Name of the client
    private static String clientName;
    // Monitor
    private static Monitor_itf monitor;
    // List of clients
    private static Set<Client_itf> clients;

    public Client() throws java.rmi.RemoteException{
        super();
    }

    public static void init(String clientName) {
        Client.possessedObjects = new HashMap<Integer, SharedObject_itf>();
        Client.localRegistry = new HashMap<String, SharedObject_itf>();
		// The same port as in the Server class
		int port = 4000;
        Client.clientName = clientName;
		try {
            // Initialize the Client
			Client.client = new Client();
			String URL = "//" + InetAddress.getLocalHost().getHostName() + ":" + port + "/server";
			System.out.println("Server found");
			// Get the stub of the server object from the rmiregistry
			Client.server = (Server_itf) Naming.lookup(URL);
            // Add the current client to the list o clients in the Server
            Client.clients = Client.server.addClient(Client.client);
		} catch (Exception e) {
			System.err.println("Error during client layer initialization");
			e.printStackTrace();
		}
    }

    /**
	 * Lookup in the local registry
	 * @param name the name of the object that will be searched in the local registry
	 * @return the object that was found in the local registry with the given name
	 */
	public static SharedObject_itf lookup(String name) {
		return localRegistry.get(name);
	}		

    public static SharedObject_itf publish(String name, Object o, boolean reset) {
        SharedObject_itf so = null;
        try {
            int id = Client.server.publish(name, o, false, Client.client);
            so = new SharedObject(id, o);
            Client.possessedObjects.put(id,so);
            Client.localRegistry.put(name,so);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return so;
    }

    public void reportValue(int idObject, CallbackReader_itf cb) throws java.rmi.RemoteException{
        Client.possessedObjects.get(idObject).reportValue(cb);
    }

    public void update(int idObject, int version, Object value) throws java.rmi.RemoteException{
        Client.possessedObjects.get(idObject).update(version, value);
    }

    public static void write(int idObject, Object value) throws java.rmi.RemoteException{
        Client.server.write(idObject, value);
    }

    public static void read(int idObject) {
        SharedObject_itf so = Client.possessedObjects.get(idObject);
        final float minimalResponseProportion = 0.5f;
        final int nbAskedClients = Client.clients.size() - 1;
        final Counter counter = new Counter(so.getVersion(),so.getObj());
        counter.inc();

        for(Client_itf c : Client.clients){
            new Thread(new Runnable() {
                public void run() {
                    try {
                        if(Client.client != c){
                            CallbackReader_itf cb = new CallbackReader();
                            c.reportValue(idObject, cb);
                            int version = cb.getVersion();
                            Object value = cb.getValue();
                            if (version > counter.getVersion()) {
                                counter.setVersion(version);
                                counter.setValue(value);
                            }
                            counter.inc();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();
        }
        // The reader have to wait for the responses of at least 50% of all clients before assigning a value with the highest version,
        // because if not there is no guarantee that that value would be the last finished or being writing (knowing that at each writing the server waits 
        // for the responses of at least 50% of all clients)
        while (counter.getCounter() < (nbAskedClients * minimalResponseProportion)) {
            try {
                Thread.sleep(1000);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        so.setObj(counter.getValue());
        so.setVersion(counter.getVersion());
    }

    public void addObject(int idObject, String name, Object value) throws java.rmi.RemoteException{
        SharedObject_itf so = new SharedObject(idObject, value);
        Client.possessedObjects.put(idObject, so);
        Client.localRegistry.put(name, so);
    }

    public String getSite() throws java.rmi.RemoteException {
        return Client.clientName;
    }

    public static String getIdSite() throws java.rmi.RemoteException{
        return Client.clientName;
    }

    public Object getObj(String name) throws java.rmi.RemoteException{
        return Client.localRegistry.get(name).getObj();
    }

    public static Monitor_itf getMonitor() throws java.rmi.RemoteException {
        return Client.monitor;
    }

    public int getVersion(String name) throws java.rmi.RemoteException{
        return Client.localRegistry.get(name).getVersion();
    }

    public void setMonitor(Monitor_itf monitor) throws java.rmi.RemoteException{
        Client.monitor = monitor;
    }

    public static HashMap<String, SharedObject_itf> getLocalRegistry() {
        return Client.localRegistry;
    }

    public static HashMap<Integer, SharedObject_itf> getPossessedObjects() {
        return Client.possessedObjects;
    }
}