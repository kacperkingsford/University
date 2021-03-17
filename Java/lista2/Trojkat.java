public class Trojkat {
    private Punkt a,b,c;

    public Trojkat (Punkt p1, Punkt p2, Punkt p3) {
        if(p1.isEqual(p2) || p2.isEqual(p3) || p3.isEqual(p1)) {
            throw new IllegalArgumentException("Dwa punkty nie mogą stworzyć trójkąta!");
        }
        if((p2.getX() - p1.getX())* (p3.getY() - p1.getY()) == (p2.getY() - p1.getY()) * (p3.getX() - p1.getX())){
            throw new IllegalArgumentException("Punkty współliniowe nie mogą tworzyć trójkąta!");
        }
        else {
            this.a = p1;
            this.b = p2;
            this.c = p3;
        }
    }


    public void przesun(Wektor v) {
        a.przesun(v);
        b.przesun(v);
        c.przesun(v);
    }

    public void obroc(Punkt p, double kat) {
        a.obroc(p, kat);
        b.obroc(p, kat);
        c.obroc(p, kat);
    }

    public void odbij(Prosta p) {
        a.odbij(p);
        b.odbij(p);
        c.odbij(p);
    }
}