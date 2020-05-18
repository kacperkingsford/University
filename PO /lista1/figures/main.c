#include "figure.h"

int main()
{
    // TESTY

    Figura *f[3];
    f[0] = nowy_kwadrat(1.0,-1.0,3.0); //wspolrzedne srodka i dl boku
    f[1] = nowe_kolo(5.0,-2.0,4.0); // wspolrzedne srodka i promien
    f[2] = nowy_trojkat(1.0,1.0,1.0,2.0,3.0,4.0);//wspolrzedne bokow

    for(int i=0;i<3;i++)
    {
        tab[i]=f[i];
    }

    printf("%f",sumapol(tab,3));

    return 0;
}
