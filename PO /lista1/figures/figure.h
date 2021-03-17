#ifndef FIGURE_H_INCLUDED
#define FIGURE_H_INCLUDED
#define pi 3.14159265359
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef enum typ {kolo,kwadrat,trojkat} typfig;

typedef struct figura
{
    typfig typ;
    float Ax,Ay,Bx,By,Cx,Cy,Dx,Dy;
    float Sx,Sy;
    float promien;

}Figura;


Figura* nowy_kwadrat(float a,float b, float dl_boku);
float pole(Figura* f);
void przesun(Figura* f,float x,float y);
Figura* nowe_kolo(float a,float b, float promien);
Figura* nowy_trojkat(float ax,float ay,float bx,float by, float cx,float cy);
float sumapol(Figura* f,int size);
float abs1(float x);
Figura* tab[3];


#endif // FIGURE_H_INCLUDED
