// tylko zadanie 1
#include "dane.hpp"
#include <vector>
#include <fstream>
#include <algorithm>

bool sortfunc(const std::pair<int,std::string> &a,const std::pair<int,std::string> &b);
void zadanie1_test();

int main()
{
    zadanie1_test();
    return 0;
}


void zadanie1_test()
{
    std::ifstream plik;
    plik.open("test1.txt");

    std::vector<std::pair<int, std::string>> x;
    if (plik.is_open())
    {
        int idx = 1;
        std::string s;

        while (plik.good())
        {
            plik >> s;

            x.push_back(std::make_pair(idx, s));

            idx++;
        }
        const int dl = std::to_string(x.size()).length();

        std::sort(x.begin(), x.end(), sortfunc);


        for (auto q : x)
            std::cout << index(q.first, dl) << " " << q.second << std::endl;

        plik.close();
    }
    else
    {
        std::cerr << "Failed to open file"<< std::endl;
        exit(1);
    }
}

bool sortfunc(const std::pair<int,std::string> &a,const std::pair<int,std::string> &b)
{
    return (a.second < b.second);
}
