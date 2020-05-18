using System;
namespace Dictionaries
{
    public class Dictionary<K, V> where K : class
    {

        private int capacity;
        private int size;
        private K[] keys;
        private V[] values;

        public V this[K key]
        {
            get
            {
                return GetValue(key);
            }
            set
            {
                SetValue(key, value);
            }
        }

        private V GetValue(K key)
        {
            for (int i = 0; i < size; i++)
            {
                if (keys[i].Equals(key))
                    return values[i];
            }

            throw new System.IndexOutOfRangeException();
        }

        private void SetValue(K key, V value)
        {
            for (int i = 0; i < size; i++)
            {
                if (keys[i].Equals(key))
                {
                    values[i] = value;
                    return;
                }
            }

            AddElement(key, value);
        }

        private void AddElement(K key, V value)
        {
            if (size >= capacity)
            {
                capacity *= 2;
                K[] new_keys = new K[capacity];
                V[] new_values = new V[capacity];

                for (int i = 0; i < size; i++)
                {
                    new_keys[i] = keys[i];
                    new_values[i] = values[i];
                }

                values = new_values;
                keys = new_keys;
            }

            keys[size] = key;
            values[size] = value;

            size++;
        }


        public K GetKey(int i)
        {
            return keys[i];
        }


        public void Remove(K key)
        {
            for (int index = 0; index < size; index++)
            {
                if (keys[index].Equals(key))
                {
                    for (int i = index; i < size - 1; i++)
                    {

                        keys[i] = keys[i + 1];
                        values[i] = values[i + 1];
                    }

                    size--;
                    return;
                }
            }
        }


        public Dictionary(int initialCapacity = 1)
        {
            size = 0;
            capacity = initialCapacity;
            keys = new K[capacity];
            values = new V[capacity];
        }

        public int GetSize()
        {
            return size;
        }
    }
}