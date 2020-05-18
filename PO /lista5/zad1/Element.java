public class Element<T extends Comparable<T>>
{
    private T val;
    private Element<T> next;

    public T getval()
    {
        return this.val;
    }
    
    public void setval(T x)
    {
        this.val = x;
    }

    public Element<T> getnext()
    {
        return this.next;
    }

    public void setnext(Element<T> next)
    {
        this.next = next;
    }

    public Element(T val, Element<T> next)
    {
        this.val = val;
        this.next = next;
    }
}