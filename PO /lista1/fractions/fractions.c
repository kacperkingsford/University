#include "fractions.h"

int NWD(int a, int b)
{
    if(b==0)
    {
        return a;
    }
    return NWD(b,a%b);
}

void zrob_nieskracalny(Ulamek* u1)
{
    int dzielnik = NWD(u1->licznik,u1->mianownik);
    if(dzielnik>1)
    {
        u1->licznik/=dzielnik;
        u1->mianownik/=dzielnik;
    }
}

void napraw_minus(Ulamek* u1)
{
    if(u1->mianownik < 0)
    {
        u1->mianownik*=-1;
        u1->licznik*=-1;
    }
}

Ulamek* nowy_ulamek (int a, int b)
{
    if(b==0)
    {
        printf("Jeden z ułamków ma 0 w mianowniku! Nie można dzielić przez 0! Błąd!");
        exit(-1);
    }
    Ulamek* u1=malloc(sizeof(Ulamek));
    u1->licznik=a;
    u1->mianownik=b;
    zrob_nieskracalny(u1);
    napraw_minus(u1);
    return u1;
}

void wypisz_ulamek(Ulamek* u1)
{
    printf("Licznik : %d Mianownik : %d\n",u1->licznik,u1->mianownik);
}

Ulamek* dodaj_ulamki(Ulamek* u1, Ulamek* u2)
{
    return nowy_ulamek(u1->licznik*u2->mianownik+u2->licznik*u1->mianownik,u1->mianownik*u2->mianownik);
}

Ulamek* odejmij_ulamki(Ulamek* u1, Ulamek* u2)
{
    return nowy_ulamek(u1->licznik*u2->mianownik-u2->licznik*u1->mianownik,u1->mianownik*u2->mianownik);
}

Ulamek* pomnoz_ulamki(Ulamek* u1, Ulamek* u2)
{
    return nowy_ulamek(u1->licznik * u2->licznik, u1->mianownik * u2->mianownik);
}

Ulamek* podziel_ulamki(Ulamek* u1, Ulamek* u2)
{
    return nowy_ulamek(u1->licznik * u2->mianownik, u1->mianownik * u2->licznik);
}

void zwolnij_pamiec_ulamka(Ulamek* u1)
{
    free(u1);
}

void dodajv2(Ulamek* u1, Ulamek* u2)
{
    u2->licznik = u1->licznik * u2->mianownik + u1->mianownik * u2->licznik;
    u2->mianownik = u1->mianownik * u2->mianownik;
    zrob_nieskracalny(u2);
    napraw_minus(u2);
}

void odejmijv2(Ulamek* u1, Ulamek* u2)
{
    u2->licznik = u1->licznik * u2->mianownik - u1->mianownik * u2->licznik;
    u2->mianownik = u1->mianownik * u2->mianownik;
    zrob_nieskracalny(u2);
    napraw_minus(u2);
}

void pomnozv2(Ulamek* u1, Ulamek* u2)
{
    u2->licznik = u1->licznik * u2->licznik;
    u2->mianownik = u1->mianownik * u2->mianownik;
    zrob_nieskracalny(u2);
    napraw_minus(u2);
}

void podzielv2(Ulamek* u1, Ulamek* u2)
{
    u2->licznik = u1->licznik * u2->mianownik;
    u2->mianownik = u1->mianownik * u2->licznik;
    zrob_nieskracalny(u2);
    napraw_minus(u2);
}
