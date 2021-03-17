// tylko zadanie 1
#include "dane.hpp"


std::istream& clearline(std::istream& we)
{
    while (we.peek() != EOF && we.get() != '\n');
	return we;
}
ignore::ignore(int x)
{
    if (x < 0)
        throw std::invalid_argument("ignore(): number of characters can't be negative!");
    this->x = x;
}
std::istream& operator>>(std::istream& we, const ignore& a)
{
    char c;
    int i = 0;

    while (i < a.x)
    {
        i++;
        c = we.get();

        if (c == EOF or c == '\n')
            break;
    }

    return we;
}
std::ostream& comma(std::ostream& wy)
{
    wy << ", ";
    return wy;
}
std::ostream& colon(std::ostream& wy)
{
    wy << ": ";
    return wy;
}
index::index(int x, int w)
{
    if (w < 0)
        throw std::invalid_argument("w < 0");
    this->x = x;
    this->w = w;
}
std::ostream& operator<<(std::ostream& wy, const index& a)
{
    wy << "[";
    std::string x_s = std::to_string(a.x);
    int p = a.w - x_s.length();
    for (int i = 0; i < p; i++)
        wy << " ";
    wy << x_s;
    wy << "]";
    return wy;
}


