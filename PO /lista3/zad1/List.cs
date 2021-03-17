using System;
namespace Lista
{
    public class Lista<T>
    {
        private class Element<T1>
        {
            public T1 value;
            public Element<T1> next;
            public Element<T1> prev;
            //konstruktor
            public Element(T1 val)
            {
                this.value = val;
                this.next = null;
                this.prev = null;
            }
        }
        //wskazniki poczatku i konca
        private Element<T> beginning;
        private Element<T> end;
        private int size;

        public bool isempty()
        {
            return (beginning == null && end == null);
        }

        public void PushFront(T val)
        {
            size++;

            Element<T> nowypoczatek = new Element<T>(val);
            nowypoczatek.next = beginning;
            if(nowypoczatek.next == null)
            {
                end = nowypoczatek;
            }
            else
            {
                beginning.prev = nowypoczatek;
            }
            beginning = nowypoczatek;
        }

        public void PushBack(T val)
        {
            size++;

            Element<T> nowykoniec = new Element<T>(val);
            nowykoniec.prev = end;
            if(nowykoniec.prev == null)
            {
                beginning = nowykoniec;
            }
            else
            {
                end.next = nowykoniec;
            }
            end = nowykoniec;
        }

        public T PopFront()
        {
            size--;

            if (beginning!=null)
            {
                Element<T> nowypoczatek = beginning.next;
                if(nowypoczatek != null )
                {
                    nowypoczatek.prev = null;
                }
                else
                {
                    end = null;
                }
                T result = beginning.value;
                beginning = nowypoczatek;
                return result;
            }
            else
            {
                throw new System.InvalidOperationException();
            }
        }
        public T PopBack()
        {
            size--;

            if(end != null)
            {
                Element<T> nowykoniec = end.prev;
                if (nowykoniec != null)
                {
                    nowykoniec.next = null;
                }
                else
                {
                    beginning = null;
                }
                T result = end.value;
                end = nowykoniec;
                return result;
            }
            else
            {
                throw new System.InvalidOperationException();
            }
        }
        //konstruktor (lista domyslnie pusta)
        public Lista()
        {
            this.beginning = null;
            this.end = null;
            this.size = 0;
        }

    }
}
