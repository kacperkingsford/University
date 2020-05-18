public class Wielomian extends Funkcja
{
    float[] wsp; // wspolczynniki wielomianu

    public String toString()//zaminenia wielomian na przejrzysty napis
    {
        String wynik ="";
        for(int i = wsp.length -1 ; i>0; i--)
        {
            if (wsp[i] != 0)
            {
                wynik += Float.toString(wsp[i]);
                wynik += "x^" + Integer.toString(i) + " + ";
            }
            
        }
        if(wsp[0] != 0 || wsp.length == 1)
        {
            wynik += Float.toString(wsp[0]);
        }
        return wynik;
    }
    public float valueAt(int x)
    {
        float suma = 0;
        float pot_x = 1;
        for(float t : wsp)
        {
            suma += t * pot_x;
            pot_x*=x;
        }
        return suma;
    }
    public Wielomian(float[] wsp)
    {
        this.wsp = wsp;
    }
}