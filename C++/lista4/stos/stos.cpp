#include "stos.hpp"
#include <iostream>

stos::stos(int pojemnosc)
{
    if(pojemnosc < 0)
    {
        throw std::invalid_argument("Pojemnosc musi byc > 0 !");
    }
    else
    {
        this->ile = 0;
        this->pojemnosc = pojemnosc;
        this->tablica = new std::string[pojemnosc];
    }
}
stos::stos() : stos(1) {}
stos::stos(stos& s1)
{
    this->ile = s1.ile;
    this->pojemnosc = s1.pojemnosc;
    this->tablica = new std::string[s1.pojemnosc];
    for(int i = 0 ; i < s1.pojemnosc ; i++)
    {
        this->tablica[i] = s1.tablica[i];
    }
}
stos::stos(stos&& s1)
{
    this->ile = s1.ile;
    this->pojemnosc = s1.pojemnosc;
    this->tablica = s1.tablica;
    s1.tablica = nullptr;
    s1.ile = 0;
    s1.pojemnosc = 0;
}

stos::stos(std::initializer_list<std::string> lista)
{
    this->ile = 0;
    this->pojemnosc = lista.size();
    for(std::string x : lista)
    {
        this->wloz(x);
    }
}

stos::~stos()
{
    delete [] this->tablica;
}

stos stos::odwroc()
{
    stos* s1 = new stos;
    s1->ile = this->ile;
    s1->pojemnosc = this->pojemnosc;
    for(int i=0;i<this->ile; i++)
    {
        s1->wloz(this->tablica[this->ile-1 - i]);
    }
    return *s1;

}
void stos::wloz(std::string elem)
{
    if(this->ile == this->pojemnosc)
    {
        this->pojemnosc*=2; // zwiekszamy pojemnosc stosu np. dwukrotnie przy przepełnieniu
        std::string* pom = new std::string[this->pojemnosc];
        for(int i=0;i<this->ile;i++)
        {
            pom[i] = this->tablica[i];
        }
        delete [] this->tablica;
        this->tablica = pom;
    }
    this->tablica[this->ile] = elem;
    this->ile ++ ;
}
std::string stos::sciagnij()
{
    if(this->ile)
    {
        this->ile -- ;
        return this->tablica[this->ile];
    }
    else
    {
        throw std::invalid_argument("Pusty stos! Nie da sie sciagnac elementu!");
    }
}
std::string stos::sprawdz()
{
    if(this->ile)
    {
        return this->tablica[ile - 1];
    }
    else
    {
        throw std::invalid_argument("Pusty stos!");
    }
}

int stos::rozmiar()
{
    return this->ile;
}

void stos::wypisz_stos()
{
    std::cout << "Pojemnosc stosu : " << this->pojemnosc << std::endl;
    std::cout << "Ilosc elementow stosu : " << this->ile <<std::endl;
    std::cout << "Elementy stosu od dolu : "<< std:: endl;
    for(int i = 0 ; i<this->ile; i++)
    {
        std::cout << this->tablica[i] << ", ";
    }
}

stos& stos::operator=(stos& other)
{
    if (&other != this)
    {
        if (this->pojemnosc != other.pojemnosc)
            delete[] this->tablica;

        this->ile = other.ile;
        this->pojemnosc = other.pojemnosc;

        this->tablica = new std::string[this->pojemnosc];

        for (int i = 0; i < this->ile; i++)
            this->tablica[i] = other.tablica[i];
    }

    return *this;
}

stos& stos::operator=(stos&& other)
{
    delete[] this->tablica;

    this->ile = other.ile;
    this->pojemnosc = other.pojemnosc;

    this->tablica = other.tablica;
    other.tablica = nullptr;
    other.ile = 0;

    return *this;
}

