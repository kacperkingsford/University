public abstract class Funkcja implements Comparable<Funkcja>
{
    //Porównywanie funkcji będzie polegało na sprawdzeniu która z nich ma wartości więszke na przedziale 0 do 1000
    public abstract float valueAt(int x);

    public int compareTo (Funkcja f)
    {
        int licz = 0;
        for (int i = 0 ; i < 1001 ; i++)
        {
            float y1 = this.valueAt(i);
            float y2 = this.valueAt(i);
            if (y1 > y2)
            {
                licz ++;
            }
            else
            {
                licz --;
            }
        }
        return licz;
    }

    public abstract String toString();
}