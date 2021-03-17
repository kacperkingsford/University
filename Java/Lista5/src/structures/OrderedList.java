package structures;

import java.util.Iterator;

public class OrderedList<T extends Comparable<T>> implements OrderedSequence<T>, Iterable<T> {

    private class Node<T extends Comparable<T>> {
        private Node<T> next;
        private T data;

        public Node(T newData) {
            this.next = null;
            this.data = newData;
        }

        //funkcja pomocnicza dodająca węzeł na koniec listy
        public void addNode(T elem) {
            this.next = new Node<T>(elem);
            this.next.next = null;
        }

        @Override
        public String toString() {
            return " " + this.data.toString();
        }
    }

    private Node<T> start;

    @Override
    public void insert(T el) throws Exception {
        if (el == null) {
            throw new NullPointerException("error");
        }
        if (search(el)) {
            throw new Exception("Element jest juz na liscie!");
        }
        if (this.start == null) {
            this.start = new Node<T>(el);
        } else {
            Node<T> pom = this.start;
            while (pom.next != null) {
                pom = pom.next;
            }
            pom.addNode(el);
            //sortowanie w kolejnosci rosnacej wezłów:
            sortList();
        }
    }

    public void sortList() {
        Node<T> current = this.start, index = null;
        T temp;
        while (current != null) {
            index = current.next;

            while (index != null) {
                if (current.data.compareTo(index.data) > 0) {
                    temp = current.data;
                    current.data = index.data;
                    index.data = temp;
                }
                index = index.next;
            }
            current = current.next;
        }
    }


    @Override
    public void remove(T el) {
        Node<T> current = this.start.next;
        Node<T> previous = this.start;
        if (this.start.data.compareTo(el) == 0) { //pierwszy element do usuniecia
            this.start = this.start.next;
        }
        while (current != null) {
            if (current.data.compareTo(el) == 0) {
                previous.next = current.next;
                return;
            }
            previous = current;
            current = current.next;
        }
    }

    @Override
    public T min() {
        Node<T> current = this.start;
        T currentMinimum = current.data;
        while(current != null) {
             if(current.data.compareTo(currentMinimum)<0){
                 currentMinimum = current.data;
             }
             current = current.next;
        }
        return currentMinimum;
    }

    @Override
    public T max() {
        Node<T> current = this.start;
        T currentMaximum = current.data;
        while(current != null) {
            if(current.data.compareTo(currentMaximum)>0){
                currentMaximum = current.data;
            }
            current = current.next;
        }
        return currentMaximum;
    }

    @Override
    public T at(int pos) throws NullPointerException{ //pozycje numeruje od 0
        Node<T> current = this.start;
        for(int i=0;i<pos;i++){
            current = current.next;
        }
        if(current != null) return current.data;
        else {
            throw new NullPointerException("Lista jest krótsza niż podana pozycja!");
        }
    }

    @Override
    public boolean search(T el) {
        Node<T> current = this.start;
        while (current != null) {
            if (current.data.compareTo(el) == 0) {
                return true;
            }
            current = current.next;
        }
        return false;
    }

    @Override
    public int index(T el) throws Exception {
        int ind = 0; // elementy numeruje od 0
        Node<T> current = this.start;
        while (current != null) {
            if(current.data.compareTo(el) == 0) {
                return ind;
            }
            current = current.next;
            ind++;
        }
        throw new Exception("Nie ma takiego elementu na liscie!");
    }

    @Override
    public String toString() {
        String s = "";
        Node<T> current = this.start;
        while (current != null) {
            s += current.toString();
            current = current.next;
        }
        return s;
    }

    public OrderedList() {
    }

    public Iterator<T> iterator() {
        return new MyIterator<T>(this.start);
    }

    private class MyIterator<T extends Comparable<T>> implements Iterator<T>{
        Node<T> current;

        public MyIterator(Node<T> start) {
            current = start;
        }

        public boolean hasNext() {
            return current != null;
        }

        public T next() {
            T elem = current.data;
            current = current.next;
            return elem;
        }

        public void remove() {
            current = current.next;
        }

    }
}
