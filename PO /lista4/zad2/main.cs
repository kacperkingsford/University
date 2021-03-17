using Primes;
using System;

class MainClass
{
    // Funkcja Main
    public static void Main(string[] args)
    {
        PrimeCollection primes = new PrimeCollection();

        // Jeżeli użytkownik nie poda limitu liczb, to wygenerowane
        // zostanš wszystkie liczby pierwsze mieszczšce się w zmiennej
        // typu int (32 bitowej).
        int limit = Int32.MaxValue;

        // Sprawdzanie, czy użytkownik podał limit, do którego będš
        // wyznaczane kolejne liczby pierwsze.
        if (args.Length > 0)
        {
            // Sprawdzanie, czy podany argument jest poprawnš liczbš całkowitš.
            if (!Int32.TryParse(args[0], out limit))
            {
                Console.WriteLine("Given command line argument is invalid!");
                return;
            }
            // Wypisywanie komunikatu z błędem, jeżeli nie istniejš liczby
            // pierwsze mniejsze niż zadany limit.
            else if (limit <= 2)
            {
                Console.WriteLine("There are no prime numbers smaller than 2!");
                return;
            }
        }

        // Przebieganie przez kolekcję i wyznaczanie kolejnych liczb.
        // Jeżeli nowo wyznaczona liczba przekracza podany limit, to
        // pętla zostaje przerwana.
        foreach (var prime in primes)
        {
            if (prime >= limit)
                break;
            Console.WriteLine("{0}", prime);
        }
    }
}
