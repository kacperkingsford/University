#include <iostream>

using namespace std;

struct dane{
    string imie;
    int wzrost;
    int waga;
    float wskaznikBMI;
};
//podpunkt 1
const int n = 5;
dane tablica[n];

int main()
{ // podpunkt 2 i 3
    for(int i =0 ; i<5; i++){
        string a;
        int b,c;
        cout << "Podaj : imie,wzrost,wage w tej kolejnosci" << endl;
        cin >> a;
        cin >> b;
        cin >> c;
        tablica[i].imie = a;
        tablica[i].wzrost = b;
        tablica[i].waga = c;
        tablica[i].wskaznikBMI = c/b;
    }
//podpunkt 4
    for(int i =0 ; i<5; i++){
        cout << "osoba numer" << i;
        cout << tablica[i].imie << " " << tablica[i].wzrost << " " << tablica[i].waga << " " << tablica[i].wskaznikBMI;
        if(tablica[i].wskaznikBMI < 18.5){
            cout << " niedowaga";
        }
        else if(tablica[i].wskaznikBMI >= 18.5 && tablica[i].wskaznikBMI <=24.99){
            cout << "wartosc prawidlowa";
        }
        else {
            cout << "nadwaga";
        }

        cout << "" << endl;
    }
//podpunkt 5
    int prawidlowa = 0;

    for(int i =0; i<5;i++){
        if(tablica[i].wskaznikBMI >= 18.5 && tablica[i].wskaznikBMI <=24.99){
            prawidlowa++;
        }
    }
    cout << " Ilosc osob z prawidlowa waga wynosi" << prawidlowa << endl;

    //podpunkt 6
    float bmi_min = tablica[0].wskaznikBMI;
    int min=0;
    float bmi_max = tablica[0].wskaznikBMI;
    int max=0;


    for(int i = 0; i<5 ; i++){
        if(bmi_min > tablica[i].wskaznikBMI)
        {
            bmi_min = tablica[i].wskaznikBMI;
            min = i;
        }
        if(bmi_max < tablica[i].wskaznikBMI)
        {
            bmi_max = tablica[i].wskaznikBMI;
            max = i;
        }
    }

    cout << "Dane osoby z największym wskaznikiem BMI :" ;
    cout << tablica[max].imie << tablica[max].waga << tablica[max].wzrost << tablica[max].wskaznikBMI ;

    cout << "Dane osoby z najmniejszym wskaznikiem BMI :" ;
    cout << tablica[min].imie << tablica[min].waga << tablica[min].wzrost << tablica[min].wskaznikBMI ;

    return 0;
}
