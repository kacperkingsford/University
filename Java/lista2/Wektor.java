public class Wektor {
    public final double dx, dy;
    
    public Wektor(double x, double y){
        this.dx = x;
        this.dy = y;
    }
    public static Wektor zlozWektor(Wektor a1, Wektor a2) {
        return new Wektor(a1.dx + a2.dx, a1.dy + a2.dy);
    }
}