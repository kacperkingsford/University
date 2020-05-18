#ifndef FRACTIONS
#define FRACTIONS

#include <stdio.h>
#include <stdlib.h>

typedef struct ulamki
{
    int licznik;
    int mianownik;
} Ulamek;

int NWD(int a, int b);
void zrob_nieskracalny(Ulamek* u1);
void napraw_minus(Ulamek* u1);
Ulamek* nowy_ulamek (int a, int b);
void wypisz_ulamek(Ulamek* u1);
Ulamek* dodaj_ulamki(Ulamek* u1, Ulamek* u2);
Ulamek* odejmij_ulamki(Ulamek* u1, Ulamek* u2);
Ulamek* pomnoz_ulamki(Ulamek* u1, Ulamek* u2);
Ulamek* podziel_ulamki(Ulamek* u1, Ulamek* u2);
void zwolnij_pamiec_ulamka(Ulamek* u1);
void dodajv2(Ulamek* u1, Ulamek* u2);
void odejmijv2(Ulamek* u1, Ulamek* u2);
void pomnozv2(Ulamek* u1, Ulamek *u2);
void podzielv2(Ulamek* u1, Ulamek* u2);

#endif
