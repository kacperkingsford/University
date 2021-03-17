using System;
using Streams;

    class MainClass
    {
        public static void Main(string[] args)
        {
            IntStream test = new IntStream();
            Console.WriteLine("{0}", test.x);
            Console.WriteLine("{0}", test.next());
            Console.WriteLine("{0}", test.next());
            test.x = int.MaxValue;
            Console.WriteLine("{0}", test.eos());
            RandomStream tescik = new RandomStream();
            Console.WriteLine(tescik.x);
            tescik.reset();
            Console.WriteLine(tescik.x);
            Console.WriteLine(tescik.next());
            Console.WriteLine(tescik.eos());
            PrimeStream tescik2 = new PrimeStream();
            for (int i = 0; i < 5; i++)
            {
                Console.WriteLine(tescik2.next());
            }

            RandomWordStream a = new RandomWordStream();

            for (int i = 0; i < 20; i++)
            {
                Console.WriteLine(a.next());
            }


        }
    }
