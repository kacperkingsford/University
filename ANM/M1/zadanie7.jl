function find(x)
    while x * (1.0 / x) == 1
        x = nextfloat(x)
    end
    print("$x : $(bitstring(x))")
end