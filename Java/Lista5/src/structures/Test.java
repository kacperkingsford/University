package structures;

import java.util.Calendar;
import java.util.TimeZone;

public class Test {
    public static void main(String[] args) throws Exception {
        OrderedList<Integer> lista = new OrderedList<Integer>();


        lista.insert(2);
        lista.insert(3);
        lista.insert(9);
        lista.insert(1);

        System.out.print(lista.toString()+" "+ "Maksymalna wartosc listy : " + lista.max() + "\n");

        for (Integer i: lista //foreach test
             ) {
            System.out.println(i);
        }

        System.out.println("Minimum : "+ lista.min());
        lista.remove(3);
        System.out.println(lista.toString());

        System.out.println(lista.at(0));//pierwszy element listy

        System.out.println(lista.index(9)); //zwroci indeks liczby 9 czyli numerując od zera 2

        OrderedList<Calendar> lista2 = new OrderedList<Calendar>();

        lista2.insert(Calendar.getInstance(TimeZone.getTimeZone("GMT-8")));
        lista2.insert(Calendar.getInstance(TimeZone.getTimeZone("UTC")));
        lista2.insert(Calendar.getInstance(TimeZone.getTimeZone("PST")));
        for(Calendar i : lista2) {
            System.out.println(i.getTime());
        }

    }
}
