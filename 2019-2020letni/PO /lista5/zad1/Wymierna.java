public class Wymierna extends Funkcja
{
    Wielomian licznik, mianownik;
    public String toString()
    {
        return "( " + this.licznik.toString() + " ) / ( " + this.mianownik.toString() + " )";
    }
    public float valueAt(int x)
    {
        return this.licznik.valueAt(x) / this.mianownik.valueAt(x);
    }
    public Wymierna(float[] wsp_licz, float[] wsp_mian)
    {
        this.licznik = new Wielomian(wsp_licz);
        this.mianownik = new Wielomian(wsp_mian);
    }
    public Wymierna(Wielomian licznik, Wielomian mianownik)
    {
        this.licznik = licznik;
        this.mianownik = mianownik;
    }
}