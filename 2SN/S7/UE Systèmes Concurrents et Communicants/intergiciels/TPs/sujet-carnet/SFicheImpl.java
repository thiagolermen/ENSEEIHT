public class SFicheImpl implements SFiche{

    private String name;
    private String email;

    protected SFicheImpl(String name, String email) {
        super();
        this.name = name;
        this.email = email;
    }

    @Override
    public String getNom() {
        return this.name;
    }

    @Override
    public String getEmail() {
        return this.email;
    }
    
}
