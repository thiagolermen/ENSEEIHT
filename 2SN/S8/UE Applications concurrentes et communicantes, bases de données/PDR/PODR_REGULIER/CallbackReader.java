import java.rmi.server.UnicastRemoteObject;

public class CallbackReader extends UnicastRemoteObject implements CallbackReader_itf{
    private int version;
    private Object value;

    public CallbackReader() throws java.rmi.RemoteException{
        this.version = 0;
        this.value = null;
    }

    public void response(int version, Object value) throws java.rmi.RemoteException{
        this.version = version;
        this.value = value;
    }

    public int getVersion()throws java.rmi.RemoteException {
        return this.version;
    }

    public Object getValue()throws java.rmi.RemoteException {
        return this.value;
    }
}
