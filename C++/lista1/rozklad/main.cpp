#include <iostream>
#include <string>
#include <cmath>
#include <limits>
#include <vector>

void za_malo_arg(char* nazwa_programu)
{
    std::cerr << "Żeby użyć programu musisz wywołać go z przynajmniej jednym argumentem w konsoli!"<<std::endl;
    std::cerr << "Przykład : " << nazwa_programu << " 10 5 -132"<<std::endl;
}

std::string zamiana_na_string(char* arg)
{
    std::string napis(arg);
    return napis;
}

int64_t string_na_int64t (std::string arg)
{
    bool ujemna = false;
    int64_t wynik = 0;
    int64_t wielokrotnosci = 1;// wielokrotnosci 10

    if(arg[0]== '-')
    {
        ujemna = true;
        arg.erase(0,1);
        if(arg.length()==0)
        {
            std::invalid_argument blad("Argument nie jest liczbą!");
            throw blad;
        }
    }

    for(int i=arg.length()-1;i>=0;i--)
    {
        if(arg[i] < '0' || arg[i] > '9')
        {
            std::invalid_argument blad("Argument nie jest liczbą!");
            throw blad;
        }

        int cyfra = arg[i] - '0';

        if(!ujemna)
        {
            wynik+=wielokrotnosci * cyfra;
        }
        else
        {
            wynik-=wielokrotnosci * cyfra;
        }
        if((wynik<0 && !ujemna) || (wynik>0 && ujemna))
        {
            std::invalid_argument blad2("Przekroczono zakres int64_t!");
            throw blad2;
        }
        wielokrotnosci*=10;
    }
    return wynik;
}

bool pierwsza(int64_t x)
{
    if(x < 0)
    {
        return false;
    }
    if(x == 1 || x == 2 )
    {
        return false;
    }
    for(int64_t i = 3; i*i<=x;i=i+2)
    {
        if(x%i == 0)
        {
            return false;
        }
    }
    return true;
}

std::vector<int64_t> rozklad_pierwszy(int64_t x)
{
    std::vector<int64_t> rozklad;
    if(x == 0 || x == 1 || x == -1)
    {
        rozklad.push_back(x);
        return rozklad;
    }
    if(x<0)
    {
        int64_t k = 2;
        rozklad.push_back(-1);
        while(true)
        {
            if(x%k==0)
            {
                rozklad.push_back(k);
                x/=k;
                x*=-1;
                break;
            }
            k++;
        }
    }
    if(pierwsza(x))
    {
        rozklad.push_back(1);
        rozklad.push_back(x);
        return rozklad;
    }

    int64_t k=2;
    while(x>0)
    {
        if(pierwsza(x))
        {
            rozklad.push_back(x);
            return rozklad;
        }
        if(x == 1)
        {
            return rozklad;
        }
        if(pierwsza(k))
        {
            if(x%k == 0)
            {
                rozklad.push_back(k);
                x/=k;
            }
            else
            {
                k++;
            }
        }
        else
        {
            k++;
        }
    }
    return rozklad;
}

void wypisz_wektor(char* napis_char)
{
    std::string napis = zamiana_na_string(napis_char);
    int64_t liczba = string_na_int64t(napis);

    std::vector<int64_t> wektor = rozklad_pierwszy(liczba);
    bool pierwsza_liczba = true;
    std::cout << liczba << " = ";
    for(int64_t dzielnik : wektor)
    {
        if(pierwsza_liczba)
        {
            std::cout << dzielnik;
            pierwsza_liczba=false;
        }
        else
        {
            std::cout << " * " << dzielnik;
        }
    }
    std::cout << std::endl;
}

int main(int argc, char* argv[])
{
    if(argc==1)
    {
        za_malo_arg(argv[0]);
    }
    else
    {
        for(int i=1;i<argc;i++)
        {
            wypisz_wektor(argv[i]);
        }
    }
    return 0;
}
