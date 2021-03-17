public class Prosta {
    public final double a,b,c;

    public Prosta(double a, double b, double c) {
        if(b!= 0.0) { //prosta w postaci Ax + y + C = 0, wtedy y=-Ax - C
            this.a = a/b;
            this.c = c/b;
            this.b = b/b;
        }
        else { // prosta postaci Ax + C = 0 czyli x = const
            this.a = a;
            this.b = b;
            this.c = c;
        }
    }

    public static Prosta przesun(Prosta p, Wektor v) {
        // Ax+y+c= 0 <=> y =-Ax-C weźmy wektor [p,q], otrzymamy wtedy y=-A(x-p)-C+q <=> Ax+y+(C-A*p-q)=0
        return new Prosta(p.a, p.b, p.c - p.a * v.dx - v.dy);
    }

    public static boolean czyRownolegle(Prosta p1, Prosta p2) {
        return ((p1.a * p2.b - p2.a * p1.b) == 0);
    }

    public static boolean czyProstopadle(Prosta p1, Prosta p2) {
        return ((p1.a * p2.a + p1.b * p2.b) == 0);
    }

    public static Punkt punktPrzeciecia(Prosta p1, Prosta p2) {
        if(czyRownolegle(p1,p2)){
            throw new IllegalArgumentException("Dwie proste równoległe nie mają punktu wspólnego!");
        }
        else {
            double x = (p1.c - p2.c)/(p2.a - p1.a);
            double y = -p1.a * x -p1.c;
            return new Punkt(x,y);
        }
    }

}