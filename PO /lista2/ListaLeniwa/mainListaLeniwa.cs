using System;
using Lista;

class MainClass
{
    public static void Main(string[] args)
    {
        ListaLeniwa list = new ListaLeniwa();
        Console.WriteLine(list.size());
        Console.WriteLine(list.element(5));
        for (int i = 0; i <= 5; i++)
        {
            Console.WriteLine(list.element(i));
        }
        Pierwsze lista2 = new Pierwsze();
        Console.WriteLine(lista2.size());
        Console.WriteLine(lista2.element(5));
        for (int i = 0; i <= 5; i++)
        {
            Console.WriteLine(lista2.element(i));
        }
    }
}