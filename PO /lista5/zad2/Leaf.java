public class Leaf extends Wyrazenie//liscie z wartosciami stalymi
{
    private int val;
    public int oblicz()
    {
        return val;
    }
    public String toString()
    {
        return Integer.toString(this.val);
    }
    public Leaf(int val)
    {
        this.val = val;
    }
}