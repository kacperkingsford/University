#include <iostream>
#include <string>
#include <vector>
#include <exception>


std::string bin2rom(int var)
{
    std::string rom = "";
    const std::vector <std::pair <int, std::string> > rzym =
    {
        {1000, "M"},{900, "CM"}, {500, "D"},
        {400, "CD"}, {100, "C"},{90, "XC"},
        {50, "L"}, {40, "XL"}, {10, "X"},
        {9, "IX"}, {5, "V"}, {4, "IV"},
        {1, "I"}
    };
    for(int i=0; i< rzym.size(); i++)
    {
        if(var-rzym[i].first >= 0)
        {
            var -= rzym[i].first;
            rom += rzym[i].second;
            i--;
        }
    }
    return rom;
}


int main(int argc,char* argv[])
{
    int var;
    for(int i=1; i<argc; i++)
    {
        try
        {
            var = std::stoi(argv[i]);
            if(var>=0 && var <= 3999)
            {
                std::cout<<bin2rom(var)<<std::endl;
            }
            else
            {
                std::cout << "Liczba " << var << " jest spoza zakresu!"<<std::endl;
            }
        }
        catch(std::logic_error())
        {
            std::clog<<"Argument nie jest liczbą!"<<std::endl;
        }

    }

    return 0;
}
