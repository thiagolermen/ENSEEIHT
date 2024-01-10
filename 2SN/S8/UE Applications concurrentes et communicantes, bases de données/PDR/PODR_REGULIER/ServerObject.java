import java.io.*;

public class ServerObject implements Serializable {
	
	// Object's server ID
    private int id;
    // Reference to the real object
    private Object obj;
    
    public ServerObject(int id, Object obj){
        this.id = id;
		// By convention the objects are not locked at their creation 
        this.obj = obj;
    }

    // Getters and setters
    public int getId() {
        return this.id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public Object getObj() {
        return this.obj;
    }

    public void setObj(Object obj) {
        this.obj = obj;
    }
}