using System;
using System.Collections.Generic;

namespace Lista
{
    class ListaLeniwa
    {
        public List<int> lista;
        public ListaLeniwa()
        {
            lista = new List<int>();   
        }
        public int size()
        {
            return lista.Count;
        }
        virtual public int element(int i)
        {
            if(lista.Count < i)
            {
                Random random_val = new Random();
                for(int e=lista.Count;e<=i;e++)
                {
                    lista.Add(random_val.Next());
                }
            }
            return lista[i];
        }

    }
    class Pierwsze : ListaLeniwa
    {
        private bool is_prime(int x)
        {
            for(int i=2;i*i <= x; i++)
            {
                if(x%i == 0)
                {
                    return false;
                }
            }
            return true;
        }
        public Pierwsze()
        {
            lista.Add(2);
        }
        public override int element(int i)
        {
            if(lista.Count < i)
            {
                int prime_candidate = lista[lista.Count - 1] + 1;
                while(lista.Count<=i)
                {
                    if(is_prime(prime_candidate))
                    {
                        lista.Add(prime_candidate);
                    }
                    prime_candidate++;
                }
            }
            return lista[i];
        }

    }
}
