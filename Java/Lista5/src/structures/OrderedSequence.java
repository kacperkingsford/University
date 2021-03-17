package structures;

public interface OrderedSequence <T extends Comparable<T>>{
    void insert(T el) throws Exception;
    void remove (T el);
    T min();
    T max();
    T at(int pos) throws NullPointerException;
    boolean search(T el);
    int index(T el) throws Exception;
}
