#ifndef STOS_HPP_INCLUDED
#define STOS_HPP_INCLUDED
#include <string>

class stos
{
    private :
    int pojemnosc;
    int ile;
    std::string* tablica;

    public:

    stos(int pojemnosc);
    stos();
    stos(stos& s1);
    stos(stos&& s1);
    stos(std::initializer_list<std::string> lista);
    stos& operator=(stos& other);
    stos& operator=(stos&& other);
    ~stos();

    void wloz(std::string elem);
    std::string sciagnij();
    std::string sprawdz();
    int rozmiar();
    void wypisz_stos();
    stos odwroc ();


};
#endif // STOS_HPP_INCLUDED
