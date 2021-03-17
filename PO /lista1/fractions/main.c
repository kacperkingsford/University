#include "fractions.h"

int main()
{
    Ulamek* u1,*u2,*dodawanie,*odejmowanie,*mnozenie,*dzielenie;
    int licznik1,licznik2,mianownik1,mianownik2;
    printf("Podaj licznik i mianownik pierwszego ulamka : ");
    scanf("%d %d",&licznik1,&mianownik1);
    printf("Podaj licznik i mianownik drugiego ulamka : ");
    scanf("%d %d",&licznik2,&mianownik2);
    u1=nowy_ulamek(licznik1,mianownik1);
    u2=nowy_ulamek(licznik2,mianownik2);
    dodawanie=dodaj_ulamki(u1,u2);
    odejmowanie=odejmij_ulamki(u1,u2);
    mnozenie=pomnoz_ulamki(u1,u2);
    dzielenie=podziel_ulamki(u1,u2);
    printf("Suma ulamkow : ");
    wypisz_ulamek(dodawanie);
    printf("Roznica ulamkow : ");
    wypisz_ulamek(odejmowanie);
    printf("Iloczyn ulamkow : ");
    wypisz_ulamek(mnozenie);
    printf("Iloraz ulamkow : ");
    wypisz_ulamek(dzielenie);



    zwolnij_pamiec_ulamka(u1);
    zwolnij_pamiec_ulamka(u2);
    zwolnij_pamiec_ulamka(dodawanie);
    zwolnij_pamiec_ulamka(odejmowanie);
    zwolnij_pamiec_ulamka(mnozenie);
    zwolnij_pamiec_ulamka(dzielenie);
    return 0;
}
