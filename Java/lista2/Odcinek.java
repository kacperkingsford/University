public class Odcinek {

    private Punkt a;
    private Punkt b;

    public Odcinek (Punkt a, Punkt b) {
        if(a.isEqual(b)) {
            throw new IllegalArgumentException("Punkty tworzące odcinek muszą mieć różne współrzędne!");
        }
        else {
            this.a = a;
            this.b = b;
        }
    }

    public void przesun(Wektor v) {
        a.przesun(v);
        b.przesun(v);
    }

    public void obroc(Punkt p, double kat) {
        a.obroc(p, kat);
        b.obroc(p, kat);
    }

    public void odbij(Prosta p) {
        a.odbij(p);
        b.odbij(p);
    }

}