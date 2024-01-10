import java.io.*;
import java.rmi.RemoteException;


public class SharedObject implements Serializable, SharedObject_itf {
    private Integer id;
    private Object obj;
    private int version;

    public SharedObject(Integer id, Object obj) {
        this.id = id;
        this.obj = obj;
        this.version = 1;
    }

    public void update(int version, Object value) {
        try {
            //Client.getMonitor().greenLight(Client.getIdSite(),4); // ** Instrumentation
         	// ** attente quadruplée pour les ack, pour exhiber l'inversion de valeurs
         	// getIdSite identique à getSite, mais non Remote
         	// suite de la méthode update...
            this.obj = value;
            this.version = version;
        }   catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void reportValue(CallbackReader_itf rcb) {
        try {
            //lient.getMonitor().greenLight(Client.getIdSite(),1); // ** Instrumentation
         	// suite de la méthode reportValue... 
             rcb.response(this.version, this.obj);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    // invoked by the user program on the client node
    // passage par Client pour que les écritures soient demandées en séquence sur le site
    public void write(Object o) {
        try {
            Client.getMonitor().signal("DE",Client.getIdSite(),id); // ** Instrumentation
            Client.write(id,o);
            Client.getMonitor().signal("TE",Client.getIdSite(),id); // ** Instrumentation
        } catch (RemoteException rex) {
            rex.printStackTrace();
        }
    }

    // pour simplifier (éviter les ReadCallBack actifs simultanés)
    // on évite les lectures concurrentes sur une même copie
    public synchronized Object read() {
        // déclarations méthode read....

        try {
            Client.getMonitor().signal("DL",Client.getIdSite(),id); // ** Instrumentation
            
            //corps de la méthode read...
            Client.read(this.id);
            Client.getMonitor().signal("TL",Client.getIdSite(),id); // ** Instrumentation
            return obj;
        } catch (RemoteException rex) {
            rex.printStackTrace();
            return null;
        }
    }

    public Object getObj() {
        return this.obj;
    }

    public int getId() {
        return this.id;
    }

    public void setObj(Object obj) {
        this.obj = obj;
    }

    public void setVersion(int version){
        this.version = version;
    }

    public int getVersion(){
        return this.version;
    }
}