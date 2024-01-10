import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RFicheImpl extends UnicastRemoteObject implements RFiche{

    private String name;
    private String email;

    protected RFicheImpl(String name, String email) throws RemoteException {
        super();
        this.name = name;
        this.email = email;
    }

    @Override
    public String getNom() throws RemoteException {
        return this.name;
    }

    @Override
    public String getEmail() throws RemoteException {
        return this.email;
    }
    
}
