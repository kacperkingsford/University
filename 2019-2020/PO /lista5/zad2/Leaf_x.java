import java.util.HashMap;
public class Leaf_x extends Wyrazenie
{
    private String symbol;
    public static HashMap<String, Integer> variables = new HashMap<String, Integer>();
    public static void addVariable(String symbol, int val)
    {
        variables.put(symbol, val);
    }
    public int oblicz() throws IllegalArgumentException
    {
        if (variables.get(symbol) != null)
            return variables.get(symbol);
        else
            throw new IllegalArgumentException();
    }

    public String toString()
    {
        return this.symbol;
    }
    public Leaf_x (String symbol)
    {
        this.symbol = symbol;
    }
}
