public class Node extends Wyrazenie
{
    private char op;
    private Wyrazenie l,p;//lewe i prawe poddrzewo
    public int oblicz() throws IllegalStateException
    {
        switch (op)
        {
            case '+':
            return l.oblicz() + p.oblicz();
            case '-':
            return l.oblicz() - p.oblicz();
            case '*':
            return l.oblicz() * p.oblicz();
            case '/':
            int right = p.oblicz();
            if(right == 0)
            {
                throw new IllegalStateException("Nie można dzielić przez 0 !");
            }
            else
            {
                return l.oblicz() / p.oblicz();
            }
            default : 
            throw new IllegalStateException();

        }
    }
    public String toString()
    {
        return "(" + this.l.toString() + String.valueOf(op) + this.p.toString() + ")";
    }
    public Node(char op, Wyrazenie l, Wyrazenie p)
    {
        this.op = op;
        this.l = l;
        this.p = p;
    }
}
