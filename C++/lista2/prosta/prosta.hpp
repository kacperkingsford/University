#ifndef PROSTA_H_INCLUDED
#define PROSTA_H_INCLUDED

class wektor
{
    public:
    const double dx=0;
    const double dy=0;

    wektor(double x, double y);
    wektor(const wektor& v);
    wektor() = default;
    void wypisz();
    wektor& operator = (const wektor* v) = delete;

};

class punkt
{
    public :
    const double x=0;
    const double y=0;

    punkt(double a, double b);
    punkt(const punkt& p1);
    punkt(const punkt& p1, const wektor& v);
    punkt() = default;
    void wypisz();
    punkt& operator = (const punkt* v) = delete;

};

class prosta
{
    double a;
    double b;
    double c;

    public :

    prosta(const punkt& p1, const punkt& p2);
    prosta(const wektor& v);
    prosta(double A, double B, double C);
    prosta(const prosta& p1, const wektor& v);
    prosta();
    bool wektor_prostopadly(const wektor& v);
    bool wektor_rownolegly(const wektor& u);
    bool punkt_na_prostej(const punkt& p1);
    void normalizuj();
    double getA() const;
    double getB() const;
    double getC() const;
    void wypisz();

};
wektor zloz_wektor(const wektor& v, const wektor& u);
bool proste_prostopadle(const prosta& p1, const prosta& p2);
bool proste_rownolegle(const prosta& p1, const prosta& p2);
punkt przeciecie_prostych_nierownoleglych(const prosta& p1, const prosta& p2);


#endif // PROSTA_H_INCLUDED
