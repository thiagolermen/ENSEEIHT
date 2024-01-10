public class Counter {
    private int counter;
    private int version;
    private Object value;

    public Counter() {
        this.counter = 0;
    }

    public Counter(int version, Object value) {
        this.counter = 0;
        this.version = version;
        this.value = value;
    }

    public synchronized void inc() {
        this.counter++;
    }

    public int getCounter() {
        return this.counter;
    }

    public int getVersion() {
        return this.version;
    }

    public Object getValue() {
        return this.value;
    }

    public synchronized void setVersion(int version) {
        this.version= version;
    }

    public synchronized void setValue(Object value) {
        this.value = value;
    }
}
