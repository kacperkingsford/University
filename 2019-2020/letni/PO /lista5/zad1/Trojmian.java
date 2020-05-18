public class Trojmian extends Funkcja
{
    private float a,b,c; 
    public String toString()
    {
        String wynik ="";
        if(a!=0)
        {
            wynik += Float.toString(a) + "x^2 + ";
        }
        if(b!=0)
        {
            wynik += Float.toString(b) + "x + ";
        }
        if(c!=0)
        {
            wynik += Float.toString(c);
        }
        return wynik;
    }
    public float valueAt(int x)
    {
        return this.a *x*x + this.b*x + this.c;
    }
    public Trojmian(float a, float b, float c)
    {
        this.a = a;
        this.b = b;
        this.c = c;
    }
}