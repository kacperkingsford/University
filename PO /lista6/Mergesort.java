public final class Mergesort
{
    static class SortingThread extends Thread
    {
        private int[] array;
        private int start;
        private int end;

        public void run()
        {
            if (start == end)
                return;
            else
            {
                int middle = (start + end) / 2;
                Thread[] threads = new Thread[2];


                threads[0] = new SortingThread(array, start, middle);
                threads[1] = new SortingThread(array, middle + 1, end);
                
                for (Thread thread : threads)
                    thread.start();
                
                try
                {

                    for (Thread thread : threads)
                        thread.join();
                }
                catch (Exception exc)
                {
                    System.out.println(exc);
                    System.exit(1);
                }

                merge(array, start, middle + 1, middle, end);
            }
        }

        // Konstruktor
        public SortingThread(int[] array, int start, int end)
        {
            this.array = array;
            this.start = start;
            this.end = end;
        }
    }


    public static int[] sort(int[] array)
    {
        int[] copy = new int[array.length];
        System.arraycopy(array, 0, copy, 0, array.length);

        Thread sorting = new SortingThread(copy, 0, copy.length - 1);
        sorting.start();

        try
        {
            sorting.join();
        }
        catch (Exception exc)
        {
            System.out.println(exc);
            System.exit(1);
        }

        return copy;
    }
 
    private static void merge(int[] array, int s1, int s2, int e1, int e2)
    {
        int[] temp = new int[e2 - s1 + 1];
        
        int ptr1 = s1;
        int ptr2 = s2;
        int i = 0;
                

        while (ptr1 <= e1 && ptr2 <= e2)
        {
            if (array[ptr1] >= array[ptr2])
            {
                temp[i] = array[ptr2];
                ptr2++;
            }
            else
            {
                temp[i] = array[ptr1];
                ptr1++;
            }
            
            i++;
        }
        
        int ptr = (ptr1 <= e1) ? ptr1 : ptr2;
        int end = (ptr1 <= e1) ? e1 : e2;

        while (ptr <= end)
        {
            temp[i] = array[ptr];
            ptr++;
            i++;
        }

        ptr = s1;
        for (int element : temp)
        {
            array[ptr] = element;
            ptr++;
        }
    }
}