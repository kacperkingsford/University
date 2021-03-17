public class Spirala {

    //Kacper Kingsford
    //indeks: 315348



    //funkcja wypełniająca spiralnie tablice rozpoczynając od komórki [0][0]
    // w miejscach w których dana komórka ma zostać wypełniona liczbą która nie jest pierwsza wpisane zostaje zero
    public static void spiralFill(int n, int arr[][]) { 
        int start = n*n;
        int k = 0;
        int l = 0;
        int m = n;

        while (k < m && l < n) { 

            for (int i = l; i < n; ++i) { 
                if(!isprime(start)){
                    arr[k][i] = 0;
                }
                else{
                    arr[k][i] = start;
                }
                start--;
            } 
            k++; 

            for (int i = k; i < m; ++i) { 
                if(!isprime(start)){
                    arr[i][n-1] = 0;
                }
                else{
                    arr[i][n-1] = start;
                }
                start--;
            } 
            n--; 

            if (k < m) {
                for (int i = n - 1; i >= l; --i) { 
                    if(!isprime(start)){
                        arr[m-1][i] = 0;
                    }
                    else{
                        arr[m-1][i] = start;
                    }
                    start--;
                } 
                m--; 
            } 

            if (l < n) { 
                for (int i = m - 1; i >= k; --i) {
                    if(!isprime(start)){
                        arr[i][l] = 0;
                    }
                    else{
                        arr[i][l] = start;
                    }
                    start--;
                } 
                l++; 
            } 
        } 
    }
    //funkcja "obracająca" kolumny
    public static void reverseColumns(int a[][]) { 
        int t;
        for (int i = 0; i < a.length; i++) { 
            for (int j = 0, k = a.length - 1; j < k; j++, k--) { 
                t = a[j][i]; 
                a[j][i] = a[k][i]; 
                a[k][i] = t; 
            } 
        } 
    } 
    
    //funkcja transponująca tablice
    public static void transpose(int a[][]) { 
        int t;
        for (int i = 0; i < a.length; i++) { 
            for (int j = i; j < a.length; j++) { 
                t = a[i][j]; 
                a[i][j] = a[j][i]; 
                a[j][i] = t; 
            } 
        } 
    } 
    
    //spiralnie wpisaną tablice zaczynając od komórki [0][0] trzeba obrócić o 180 stopni aby uzyskać spirale Ulama
    //w tym celu wykonujemy transpozycje tablicy i zamiane kolejności kolumn dwukrotnie 
    public static void rotateArray(int a[][]) { 
        transpose(a); 
        reverseColumns(a); 
        transpose(a); 
        reverseColumns(a); 
    }  

    //funkcja sprawdzająca czy liczba jest pierwsza
    public static boolean isprime(int x){
       if(x==1){
           return false;
       } 
       if(x==2){
           return true;
       }
        for(int i = 2;i<x; i++){
            if(x%i == 0){
                return false;
            }
        }
        return true;
    }

    //funkcja wypisująca spirale
    public static void printSpiral(int a[][]){

        for(int i=0;i<a.length;i++){
            for(int j=0;j<a.length;j++){
                if(a[i][j]!=0){
                    System.out.print("*");
                }
                else{
                    System.out.print(" ");
                }
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {

        int n=0;

        try{
            for(int i = 0 ;i<args.length;i++){
                n+=Integer.valueOf(args[i]);
            }

        }
        catch(NumberFormatException e){
            throw new NumberFormatException("Zły format argumentów wywołania!");
            
        }

        if(n<2 || n>200){
            throw new IllegalArgumentException("parametr spoza zakresu 2 - 200");
        }

        int a[][] = new int[n][n];

        spiralFill(n,a);
        rotateArray(a);
        printSpiral(a);
    }
}