public class Punkt {
    private double x;
    private double y;

    public Punkt (double x, double y){
        this.x = x;
        this.y = y;
    }

    public boolean isEqual(Punkt a) {
        return ((this.x == a.getX() && (this.y == a.getY())));
    }

    public double getX() {
        return this.x;
    }

    public double getY() {
        return this.y;
    }

    public void setX(double x){
        this.x =x;
    }

    public void setY(double y){
        this.y =y;
    }

    public void przesun(Wektor v) {
        this.x += v.dx;
        this.y += v.dy;
    }

    public void obroc(Punkt p, double kat) { 
        this.x = p.x + (this.x - p.x)*Math.cos(kat) - (this.y - p.y)*Math.sin(kat);
        this.y = p.y + (this.x - p.x)*Math.sin(kat) + (this.y - p.y)*Math.cos(kat);
    }

    public void odbij(Prosta p) {
        this.x = (((p.b* p.b - p.a * p.a)*this.x - 2*p.a*p.b*this.y - 2*p.a*p.c)/(p.a * p.a + p.b*p.b));
        this.y = ((((-1)*p.b* p.b + p.a * p.a)*this.y - 2*p.a*p.b*this.x - 2*p.b*p.c)/(p.a * p.a + p.b*p.b));
    }
}