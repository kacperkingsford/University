function w1(x)
    x^3 - 6*x^2 + 3*x - typeof(x)(0.149)
end

function w2(x)
    ((x-6)*x + 3) * x - typeof(x)(0.149)
end

x = 4.71
dokladny = -14.636489

function bladwzgledny(x1, x2)
    abs((x1 - x2)/x1)
end

function test(f, t)
    wynik = f(t(x))
    print("W arytmetyce $t:\nw(x) = $wynik\nblad = $(bladwzgledny(dokladny, wynik))\n\n")
end

arr = [Float16, Float32, Float64]

for t in arr
    test(w1, t)
end

print("Ponawiamy obliczenia dla zmienionego wzoru...\n\n")

for t in arr
    test(w2, t)
end