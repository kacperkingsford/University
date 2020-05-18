public class Main
{
    public static void main(String[] args) 
    {
        // przykladowa lista funkcji
        Lista_rosnaca<Funkcja> lista = new Lista_rosnaca<Funkcja>();
        float [] a1 = {1,4,5};
        lista.push(new Wielomian(a1));
        float[] b1 = {2,2,4};
        float[] b2 = {2,2,2};
        lista.push(new Wymierna(new Wielomian(b1), new Wielomian(b2)));
        lista.push(new Trojmian(2, 3, 30));
        lista.print();
        Funkcja[] f = {new Trojmian(2, 3, 30), new Wymierna(new Wielomian(b1), new Wielomian(b2))};

       if(f[0].compareTo(f[1]) > 0)
        {
            System.out.println("Funkcja wymierna przyjmuje dla większej ilosci argumentow calkowitych z przedzialu 0-1000 wartosci większe niż funkcja kwadratowa!");
        }
        else if(f[0].compareTo(f[1]) < 0)
        {
            System.out.println("Funkcja wymierna przyjmuje dla mniejszej ilosci argumentow calkowitych z przedzialu 0-1000 wartosci większe niż funkcja kwadratowa!");
        }
        else
        {
            System.out.println("Funkcja wymierna i kwadratowa są równe!");
        }

        

    
        

    }
}