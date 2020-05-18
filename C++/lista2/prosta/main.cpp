#include "prosta.hpp"
#include <iostream>


int main()
{
    //wektor test
    wektor v1(1,-4);
    wektor kopia(v1);
    v1.wypisz();
    kopia.wypisz();
    wektor v2(2,-7);
    zloz_wektor(v1,v2).wypisz();//zlozenie wektorow v1 i v2
    //punkt test
    punkt p1(4,5);
    punkt p2(2,3);
    punkt kopia2(p1);
    p1.wypisz();
    kopia2.wypisz();
    punkt(p1,v1).wypisz(); //punkt powstaly po przesunieciu p1 o wektor v1
    //prosta test
    prosta y1(p1,p2);
    y1.wypisz();
    prosta(-1,1,-1).wypisz(); // utworzenie tych samych prostych na dwa sposoby -x + y - 1 = 0
    std::cout << y1.punkt_na_prostej(p1) << std::endl; // punkt z ktorego zostala utworzona prosta lezy na niej
    //
    std::cout << proste_rownolegle(prosta(1,1,1),prosta(2,2,2))<< " "<<  proste_prostopadle(prosta(1,1,0),prosta(-1,1,0))<<std::endl; // proste rownolegle i prostopadle
    std::cout << proste_rownolegle(prosta(5,20,5),prosta(1,4,1))<< " "<<  proste_prostopadle(prosta(1,1,-8),prosta(-6,1,11))<<std::endl; // proste rownolegle i nie prostopadle


    return 0;
}
