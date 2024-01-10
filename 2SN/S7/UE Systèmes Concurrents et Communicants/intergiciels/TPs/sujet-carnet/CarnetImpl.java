import java.net.InetAddress;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.*;
import java.util.*;

import javax.print.event.PrintJobListener;

public class CarnetImpl extends UnicastRemoteObject implements Carnet{

    private Map<String, RFiche> user_data;
    private int numCarnet;
    private Carnet carnet2 = null;

    protected CarnetImpl(int numCarnet) throws RemoteException {
        super();
        this.user_data = new HashMap<>();
        this.numCarnet = numCarnet;
    }

    @Override
    public void Ajouter(SFiche sf) throws RemoteException {
        try {
            RFiche rf = new RFicheImpl(sf.getNom(), sf.getEmail());
            this.user_data.put(sf.getNom(), rf);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    @Override
    public RFiche Consulter(String n, boolean forward) throws RemoteException {
        try {
            RFiche user = this.user_data.get(n);
            // If we couldnt find the user in the server and we can search in the other server
            if (user == null && forward){
                if (this.carnet2 == null){
                    try {
                        this.carnet2 = (Carnet) Naming.lookup("//localhost:4000/Carnet" + (this.numCarnet % 2) + 1);
                        user = this.carnet2.Consulter(n, false);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }else{
                    System.out.println("Searching in the next server ...");
                    user = this.carnet2.Consulter(n, true);
                }
            }
            return user;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        Integer i = new Integer(args[0]);
        int numCarnet = i.intValue();
        String URL;
        try {
            // Launching the naming service – rmiregistry – within the JVM
            Registry registry = LocateRegistry.createRegistry(4000);
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            Carnet obj = new CarnetImpl(1);
            // compute the URL of the server
            URL = "//localhost:4000/Carnet" + numCarnet;
            // Create an instance of the server object
            Naming.rebind(URL, obj);
        } catch (Exception exc) {
            exc.printStackTrace();
            return;
        }
    }
    
}
