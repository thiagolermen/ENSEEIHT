import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.CyclicBarrier;
import java.util.ArrayList;
import java.net.InetAddress;

public class Server extends UnicastRemoteObject implements Server_itf {
	// Table of all server objects (not necessarily named)
	private HashMap<Integer, ServerObject> serverObjects;
    // Versions of objects associated to their id
    private HashMap<Integer, Integer> serverVersions;
	// Server registry of named server objects
	private HashMap<String, ServerObject> serverRegistry;
	// ID counter used to ensure the uniqueness of the id of real objects
	private int currObjectId;
	// Set of all client known by the server
    private Set<Client_itf> clients;
	// instrumentation
	private Monitor_itf monitor;
	// Cyclic barrier for the intialization
	private final CyclicBarrier barrier;
	// The number of clients need to be known by initialization because of the barrier
	private final int totalNumberClients = 2;

	protected Server() throws RemoteException {
		super();
		this.serverObjects = new HashMap<Integer, ServerObject>();
		this.serverVersions = new HashMap<Integer, Integer>();
		this.serverRegistry = new HashMap<String, ServerObject>();
		this.currObjectId = -1; // convention
		this.clients = new HashSet<Client_itf>();
		barrier = new CyclicBarrier(totalNumberClients + 1); // +1 for the monitor
	}

	public Set<Client_itf> addClient(Client_itf client) throws RemoteException{
		synchronized (this.clients){
			this.clients.add(client);
		};
		try {
			barrier.await();
		} catch (Exception e) {
			e.printStackTrace();
		}
		client.setMonitor(this.monitor);
        return this.clients;
    }

	public synchronized int publish(String name, Object value, boolean reset, Client_itf client) throws RemoteException{
		this.currObjectId++;
        ServerObject so = new ServerObject(this.currObjectId, value);
        this.serverObjects.put(this.currObjectId, so);
        this.serverRegistry.put(name, so);
		this.serverVersions.put(currObjectId, 1);
		for (Client_itf c : this.clients) {
			if (!c.equals(client)) {
				new Thread(new Runnable() {
					public void run() {
						try {
							c.addObject(currObjectId, name, value);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}).start();
			}
		}
        return this.currObjectId;
    }

	public synchronized int lookup(String name) throws RemoteException {
		// Default value used by the corresponding method of the Client class
		int id = -1;
		ServerObject foundObject = null;
		try {
			foundObject = serverRegistry.get(name);
			if (foundObject != null) {
				id = foundObject.getId();
			}
		} catch (Exception e) {
			System.err.println("Error during name server consultation");
			e.printStackTrace();
		}
		return id;
	}
	
	public synchronized void write(int idObject, Object value) throws RemoteException{
		final int minimumNumberAck = (totalNumberClients/2)+1;
		final Counter counter = new Counter();
		this.serverVersions.put(idObject, 1 + this.serverVersions.get(idObject));
		this.serverObjects.get(idObject).setObj(value);
        for (Client_itf c : this.clients) {
			//System.out.println("Dans le for");
            new Thread(new Runnable() {
                public void run() {
                    try {
						//System.out.println(" avant counter.getCounter() = " + counter.getCounter());
						c.update(idObject, Server.this.serverVersions.get(idObject), value);
						//System.out.println("apres counter.getCounter() = " + counter.getCounter());
						counter.inc();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();
        }
		// The reader have to wait for the responses of at least 50% of all clients before assigning a value with the highest version,
        // because if not there is no guarantee that that value would be the last finished or being writing (knowing that at each writing the server waits 
        // for the responses of at least 50% of all clients)
        while (counter.getCounter() < (minimumNumberAck )) {
            try {
				//System.out.println("counter.getCounter() : " + counter.getCounter() + "\nnbAskedClients : "+nbAskedClients);
                //System.out.println("Server.write() -> while");
                Thread.sleep(1000);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

	public synchronized String[] list() {
		return new ArrayList<String>(this.serverRegistry.keySet()).toArray(new String[serverRegistry.keySet().size()]);
	}

	public Set<Client_itf> setMonitor(Monitor_itf m) throws RemoteException {
		this.monitor = m;
		try {
			barrier.await();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return this.clients;
	}
	public Monitor_itf getMonitor() throws RemoteException {
		return this.monitor;
	}

    public static void main(String args[]) {
		// The same port as in the Client class
		int port = 4000; 
		try {
			 // Launching the naming service – rmiregistry – within the JVM (the same as the only server's one here actually)
			 LocateRegistry.createRegistry(port);
			 // Create an instance of the server object
			 Server server = new Server();
			 String URL = "//" + InetAddress.getLocalHost().getHostName() + ":" + port + "/server";
			 // Associate the computed URL with the server
			 Naming.rebind(URL, server);
			 System.out.println("Server '"+ URL +"' bound in registry");
		} catch (Exception e) {
			System.err.println("Error during server initialization");
			e.printStackTrace();
		}
	}
}