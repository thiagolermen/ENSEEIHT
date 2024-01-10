public interface SharedObject_itf {
    public void reportValue(CallbackReader_itf rcb);
    public void update(int version, Object value);
    public void write(Object value);
    public Object read();
    public void setObj(Object value);
    public Object getObj();
    public int getId();
    public void setVersion(int version);
    public int getVersion();
}