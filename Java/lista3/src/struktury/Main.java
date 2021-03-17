package struktury;

public class Main {

    public static void main(String[] args) {
        Para a = new Para("a", 2.0);
        Para b = new Para("b", 3.0);
        Para c = new Para("c", 3.3);

        try {
            ZbiorNaTablicy z = new ZbiorNaTablicy(3);
            z.wstaw(a);
            z.wstaw(b);
            z.usun("a");
            z.wstaw(a);
            System.out.println(z.szukaj("a").toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

        ZbiorNaTablicyDynamicznej z2;

        try {
            z2 = new ZbiorNaTablicyDynamicznej();
            z2.wstaw(b);
            z2.wstaw(a);
            z2.wstaw(c);
            System.out.println(z2.szukaj("c").toString()  + "  " + z2.getRozmiar());
            z2.usun("c");
            z2.usun("a");
            System.out.println(z2.szukaj("b").toString()  + "  " + z2.getRozmiar());
            z2.usun("b");
            // System.out.println(z2.szukaj("a2").toString()  + "  " + z2.getRozmiar()); //blad - brak b w z2
            System.out.println(z2.getRozmiar()); //pojemnosc rowna 2

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
