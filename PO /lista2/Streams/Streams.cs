using System;
using System.Text;

namespace Streams
{

    class IntStream
    {
        public int x;
        virtual public int next()
        {
            x += 1;
            return x;
        }
        virtual public bool eos()
        {   
            if (x == int.MaxValue)
            {
                return false;
            }
            return true;
        }
        virtual public void reset()
        {
            x = 0;
        }
        public IntStream()
        {
            reset();
        }

    }
    class PrimeStream : IntStream
    {
        private bool isprime()
        {
            if(x<2)
            {
                return false;
            }
            for (int i = 2;i*i <= x;i++)
            {
                if(x%i == 0)
                {
                    return false;
                }
            }
            return true;
        }
        override public int next()
        {
            x += 1;
            return isprime() ? x : next();
        }
        public override void reset()
        {
            x = 1;
        }
        public PrimeStream()
        {
            reset();
        }
    }
    class RandomStream : IntStream
    {
        private Random random = new Random();
        override public void reset()
        {
            x = random.Next();
        }
        override public bool eos()
        {
            return false;
        }
        public override int next()
        {
            reset();
            return x;
        }
        public RandomStream()
        {
            reset();
        }

    }
    class RandomWordStream
    {
        private StringBuilder napis = new StringBuilder();
        private PrimeStream prime = new PrimeStream();
        private RandomStream random = new RandomStream();
        public string next()
        {
            napis.Clear();
            int length = prime.next();
            int start = (int)'!';
            int end = (int)'~' - start;
            for(int i=0;i<length;i++)
            {
                char znak = (char)(random.next() % end + start);
                napis.Append(znak);
            }
            return napis.ToString();
        }
        public bool eos()
        {
            return prime.eos();
        }
        public void reset()
        {
            prime.reset();
            random.reset();
            napis.Clear();
        }
        public RandomWordStream()
        {
            prime = new PrimeStream();
            random = new RandomStream();
            napis = new StringBuilder();
        }

    }
}
