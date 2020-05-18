#include "stos.hpp"
#include <iostream>

int main()
{
  int poj;
  std::cout << "Podaj pojemnosc stosu" << std::endl;
  std::cin >> poj;
  stos instance = stos(poj);
  bool stan = 1;
  std::string elem;
  int wybor;
  while(stan)
  {
  std::cout << std::endl;
  std::cout << "Wybierz co chcesz zrobic:" << std::endl;
  std::cout << "1.Wyswietl dane stosu" << std::endl;
  std::cout << "2.Wstaw element na stos" << std::endl;
  std::cout << "3.Usun element ze szczytu stosu" << std::endl;
  std::cout << "4.Wyjscie" << std::endl;
    std::cin >> wybor;
    switch (wybor) {
      case 1:
      {
          instance.wypisz_stos();
          break;
      }
      case 2:
      {
          std::cout << "Jaki element wstawic ? " << std::endl;
          std::cin >> elem;
          instance.wloz(elem);
          break;
      }
      case 3:
      {
        std::cout << "Sciagam ze szczytu stosu element, czyli '" << instance.sciagnij() << " '" << std::endl;
        break;
      }
      case 4:
      {
        stan = 0;
        instance.~stos();
        break;
      }
      default:
      {
        std::cout << "Bledny wybor" << std::endl;
        break;
      }
    }
  }
}
