#include "prosta.hpp"
#include <iostream>
#include <cmath>

void wektor::wypisz()
{
    std::cout << "[" << dx << "," << dy << "]"<<std::endl;

}
void punkt::wypisz()
{
    std::cout << "(" << x << "," << y << ")"<<std::endl;

}

void prosta::wypisz()
{
    std::cout << a << "x + " << b << "y + "<<c<<" = 0 "<<std::endl;
}

wektor::wektor(double x,double y) : dx(x), dy(y) {}


wektor::wektor(const wektor& v) : dx(v.dx), dy(v.dy) {}


wektor zloz_wektor(const wektor& v, const wektor& u)
{
    return wektor(v.dx + u.dx,v.dy + u.dy);
}

punkt::punkt(double a,double b) : x(a), y(b) {}

punkt::punkt(const punkt& p1) : x(p1.x), y(p1.y) {}

punkt::punkt(const punkt& p1, const wektor& v) : x(p1.x + v.dx), y(p1.y + v.dy) {}

double prosta::getA() const
{
    return a;
}

double prosta::getB() const
{
    return b;
}

double prosta::getC() const
{
    return c;
}

prosta::prosta(const punkt& p1, const punkt& p2)
{
    if(p1.x == p2.x && p1.y == p2.y)
    {
        throw std::invalid_argument("Prosta nie moze byc utworzona z jedego punktu !");
    }
    if(p1.x == p2.x)
    {
        this->a=1;
        this->b=0;
        this->c=-p1.x;
    }
    else
    {
        double n = (p1.y - p2.y) / (p1.x - p2.x);
        double m = p1.y - p1.x * n;
        this->a = -n;
        this->b = 1;
        this->c = -m;

    }
}

prosta::prosta(const wektor& u)
{
    if(u.dx == 0 && u.dy == 0)
    {
        throw std::invalid_argument("Nie mozna utworzyc punktu z wektora zerowego!");
    }
    if(u.dx == 0)
    {
        this->a = 0;
        this->b = 1;
        this->c = -u.dy;
    }
    if(u.dy == 0)
    {
        this->a = 0;
        this->b = 1;
        this->c = 0;
        return;
    }
    else
    {
        punkt pom(u.dx,u.dy);
        this->a = - (-1 / pom.x);
        this->b = 1;
        this->c = -(pom.y - (-this->a * pom.x));
    }

}

prosta::prosta()
{
    this->a = 1;
    this->b = 1;
    this->c = 0;

}

prosta::prosta(double A,double B,double C) : a(A), b(B), c(C) {}

prosta::prosta(const prosta& p1, const wektor& v)
{
    this->a = p1.a;
    this->b = p1.b;
    this->c = p1.c - (p1.a * v.dx) - v.dy;

}

void prosta::normalizuj()
{
    double t;
    double pierwiastek = std::sqrt ((a*a) + (b*b));
    if(pierwiastek == 0)
    {
        throw std::invalid_argument("Nie mozna stworzyc prostej postaci 0x + 0y + C = 0 !");
    }
    t =  (c>=0 ? 1 : -1) / pierwiastek;

    a*=t;
    b*=t;
    c*=t;
}

bool prosta::wektor_prostopadly(const wektor& v)
{
    if(v.dx == this->a && v.dy == this->b)
    {
        return true;
    }
    return false;
}

bool prosta::wektor_rownolegly(const wektor& u)
{
    prosta pom(u);
    if(this->a * pom.b == pom.a * this->b)
    {
        return true;
    }
    return false;
}

bool prosta::punkt_na_prostej(const punkt& p1)
{
    if(this->a * p1.x + this->b * p1.y + this->c == 0)
    {
        return true;
    }
    return false;
}

bool proste_prostopadle(const prosta& p1, const prosta& p2)
{
    if(p1.getA() * p2.getA() + p2.getB() * p1.getB() == 0)
    {
        return true;
    }
    return false;
}

bool proste_rownolegle(const prosta& p1, const prosta& p2)
{
    if(p1.getA() * p2.getB() == p1.getB() * p2.getA())
    {
        return true;
    }
    return false;
}

punkt przeciecie_prostych_nierownoleglych(const prosta& p1, const prosta& p2)
{
    if(proste_rownolegle(p1,p2))
    {
        throw std::invalid_argument("Blad! Proste rownolegle nie maja punktu przeciecia!");
    }
    else
    {
        double a1, a2;
        double b1, b2;
        double x;
        double y;
        a1 = -p1.getA() / p1.getB();
        a2 = -p2.getA() / p2.getB();
        b1 = -p1.getC();
        b2 = -p2.getC();
        x = (b2 - b1) / (a1 - a2);
        y = a1 * x + b1;

        return punkt(x, y);
    }
}
