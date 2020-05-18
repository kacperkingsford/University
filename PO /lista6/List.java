//zad2
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.lang.UnsupportedOperationException;
import java.util.Arrays;

public class List<E> implements Collection<E>
{
        private class Element<T>
    {
        public T value;
        public Element<T> previous;
        public Element<T> next;

        public Element(T value)
        {
            this.value = value;
            this.previous = null;
            this.next = null;
        }
        
    }

    private class ListIterator implements Iterator<E>
    {
        Element<E> current;
        public boolean hasNext()
        {
            return (current != null);
        }

        public E next() throws NoSuchElementException
        {
            if (current == null)
                throw new NoSuchElementException();

            E value = current.value;
            current = current.next;
            return value;
        }


        public void remove() throws UnsupportedOperationException
        {
            throw new UnsupportedOperationException();
        }

        ListIterator(List<E> list)
        {
            current = list.beginning;
        }
    }

    private Element<E> beginning;
    private Element<E> end;
    private int size;

    public Iterator<E> iterator()
    {
        return new ListIterator(this);
    }

    public boolean isEmpty()
    {
        return size == 0;
    }

    public boolean add(E element)
    {
        pushBack(element);
        return true;
    }


    public boolean remove(Object element)
    {
        boolean wasRemoved = false;

        List<E> newList = new List<E>();
        
        while(!isEmpty())
        {
            E value = popFront();
            
            if (value.equals(element))
                wasRemoved = true;
            else
                newList.pushBack(value);
        }

        this.beginning = newList.beginning;
        this.end = newList.end;
        this.size = newList.size;

        return wasRemoved;
    }

    public void clear()
    {
        size = 0;
        beginning = null;
        end = null;
    }

    public int size()
    {
        return size;
    }


    public boolean containsAll(Collection<?> list)
    {        
        for (E element : (Collection<E>)list)
        {
            Element<E> ptrThis = beginning;

            while (ptrThis != null)
            {
                if (ptrThis.value.equals(element))
                    break;

                ptrThis = ptrThis.next;
            }
            
            if (ptrThis == null)
                return false;
        }

        return true;
    }


    public boolean addAll(Collection<? extends E> collection)
    {
        boolean changed = false;

        for (E element : collection)
        {
            boolean exists = false;

            Element<E> ptrThis = beginning;

            while (ptrThis != null)
                if (ptrThis.value.equals(element))
                    exists = true;

            if (!exists)
            {
                pushBack(element);
                changed = true;
            }
        }

        return changed;
    }

    public boolean removeAll(Collection<?> list)
    {
        boolean changed = false;
        
        for (E element : (Collection<E>)list)
        {
            int prevSize = size;

            remove(element);

            if (size < prevSize)
                changed = true;
        }

        return changed;
    }
    public boolean retainAll(Collection<?> list)
    {
        boolean changed = false;

        for (E element : this)
        {
            if (!list.contains(element))
            {
                remove(element);
                changed = true;
            }
        }

        return changed;
    }

    public Object[] toArray()
    {
        Object[] array = new Object[size];

        Element<E> ptr = beginning;
        int i = 0;

        while (ptr != null)
        {
            array[i++] = ptr.value;
            ptr = ptr.next;
        }

        return array;
    }

    public <T> T[] toArray(T[] array)
    {
        Object[] original = toArray();
        T[] result = Arrays.copyOf(array, original.length);

        for (int i = 0; i < original.length; i++)
            result[i] = (T)original[i];

        return result;
    }

    public boolean contains(Object obj)
    {
        if (obj == null)
            return false;

        Element<E> ptr = beginning;
        
        while (ptr != null)
        {
            if (ptr.value.equals(obj))
                return true;

            ptr = ptr.next;
        }
    
        return false;
    }

    public void pushFront(E value)
    {
        size++;

        Element<E> newFront = new Element<E>(value);
        newFront.next = beginning;

        if (newFront.next == null)
            end = newFront;
        else
            beginning.previous = newFront;

        beginning = newFront;
    }

    public void pushBack(E value)
    {
        size++;

        Element<E> newEnd = new Element<E>(value);
        newEnd.previous = end;

        if (newEnd.previous == null)
            beginning = newEnd;
        else
            end.next = newEnd;
            
        end = newEnd;
    }

    public E popFront() throws IllegalStateException
    {
        size--;

        if (beginning != null)
        {
            Element<E> newFront = beginning.next;

            if (newFront != null)
                newFront.previous = null;
            else
                end = null;
        
            E result = beginning.value;
            
            beginning = newFront;

            return result;
        }
        else
            throw new IllegalStateException("popFront(): list is empty!");
    }

    public E popBack() throws IllegalStateException
    {
        size--;

        if (end != null)
        {
            Element<E> newEnd = end.previous;

            if (newEnd != null)
                newEnd.next = null;
            else
                beginning = null;

            E result = end.value;

            end = newEnd;

            return result;
        }
        else
            throw new IllegalStateException("popBack(): list is empty!");

    }

    public E get(int index) throws IndexOutOfBoundsException
    {
        if (index >= size)
            throw new IndexOutOfBoundsException("get(): index out of range!");
        else
        {
            int i = 0;

            Element<E> ptr = beginning;

            while (i != index)
            {
                i++;
                ptr = ptr.next;
            }

            return ptr.value;
        }
    }

    public void set(int index, E value) throws IndexOutOfBoundsException
    {
        if (index >= size)
            throw new IndexOutOfBoundsException("set(): index out of range!");
        else
        {
            Element<E> ptr = beginning;
            int i = 0;

            while (i != index)
            {
                ptr = ptr.next;
                i++;
            }

            ptr.value = value;
        }
    }

    public List()
    {
        this.beginning = null;
        this.end = null;
        this.size = 0;
    }
}