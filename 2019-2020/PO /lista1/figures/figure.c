#include "figure.h"


Figura* nowy_kwadrat(float a,float b,float dl_boku)
{
    float r = dl_boku/2;
    Figura* kwadrat = malloc(sizeof(Figura));
    kwadrat->typ = 1;//kwadrat
    kwadrat->Sx = a;
    kwadrat->Sy = b;
    kwadrat->Ax = a - r;
    kwadrat->Ay = b - r;
    kwadrat->Bx = a + r;
    kwadrat->By = b - r;
    kwadrat->Cx = a - r;
    kwadrat->Cy = b + r;
    kwadrat->Dx = a + r;
    kwadrat->Dy = b + r;
    return kwadrat;
}

float do_kwadratu(float x)
{
    return x*x;
}

float abs1(float x)
{
    return x<0?-x:x;
}

float pole(Figura* f)
{
    switch(f->typ){
        case 0:
        return pi * do_kwadratu(f->promien);
        case 1:
        return do_kwadratu(f->Ax-f->Bx) + do_kwadratu(f->Ay-f->By);
        case 2:
        return (abs1((f->Bx-f->Ax)*(f->Cy-f->Ay)-(f->By-f->Ay)*(f->Cx-f->Ax)))/2;
    }
    return -1;
}

void przesun(Figura* f,float x,float y)
{
    switch(f->typ)
    {
        case 0:
        f->Sx +=x;
        f->Sy +=y;
        case 1:
        f->Ax +=x;
        f->Ay +=y;
        f->Bx +=x;
        f->By +=y;
        f->Cx +=x;
        f->Cy +=y;
        f->Dx +=x;
        f->Dy +=y;
        case 2:
        f->Ax +=x;
        f->Ay +=y;
        f->Bx +=x;
        f->By +=y;
        f->Cx +=x;
        f->Cy +=y;
    }
}

Figura* nowe_kolo(float a, float b, float promien)
{
    Figura* kolo = malloc(sizeof(Figura));
    kolo->typ = 0;
    kolo->Sx = a;
    kolo->Sy = b;
    kolo->promien = promien;
    return kolo;
}

Figura* nowy_trojkat(float ax, float ay, float bx, float by, float cx, float cy)
{
    Figura* trojkat = malloc(sizeof(Figura));
    trojkat->typ = 2;
    trojkat->Ax = ax;
    trojkat->Ay = ay;
    trojkat->Bx = bx;
    trojkat->By = by;
    trojkat->Cx = cx;
    trojkat->Cy = cy;
    return trojkat;
}

float sumapol(Figura* f,int size)
{
    float suma = 0;
    for(int i = 0; i<size; i++)
    {
        suma+=pole(tab[i]);
    }
    return suma;
}
