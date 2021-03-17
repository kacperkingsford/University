#ifndef DANE_HPP_INCLUDED
#define DANE_HPP_INCLUDED
//tylko zadanie 1

#include <iostream>


std::istream& clearline(std::istream& is);

class ignore
{
    int x;
    friend std::istream& operator>>(std::istream& we, const ignore& a);
public:
    ignore(int x);
};

std::ostream& comma(std::ostream& os);
std::ostream& colon(std::ostream& os);

class index
{
    int x;
    int w;
public:
    index(int x, int w);
    friend std::ostream& operator<<(std::ostream& wy, const index& a);
};

#endif // DANE_HPP_INCLUDED
