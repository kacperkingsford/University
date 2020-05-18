public class Lista_rosnaca<T extends Comparable<T>> 
{
    private Element<T> head;

    public void print()
    {
        Element<T> ptr = head;
        while(ptr != null)
        {
            System.out.println(ptr.getval());
            ptr = ptr.getnext();
        }
    }

    public boolean isempty()
    {
        return (head == null);
    }

    public T pop() throws NullPointerException
    {
        if (head != null)
        {
            T wynik = head.getval();
            head = head.getnext();
            return wynik;
        }   
        else
        {
            throw new NullPointerException("pop(): lista pusta!");
        }     
    }

    public void push(T val)
    {
        if(head == null)
        {
            head = new Element<T>(val, null);
        }
        else if (head.getval().compareTo(val) > 0) // nowy element mniejszy od najmniejszego na liscie
        {
            Element<T> new_elem = new Element<T>(val, head);
            this.head = new_elem;
        }
        else
        {
            Element<T> ptr = head;
            while(ptr.getnext()!= null && ptr.getnext().getval().compareTo(val) < 0 )
            {
                ptr = ptr.getnext();
            }
            ptr.setnext(new Element<T>(val, ptr.getnext()));
        }
    }
    public Lista_rosnaca()
    {
        this.head = null;
    }
}