function stringtofloat(s)
    strznak = s[1]
    strcecha = s[2:12]
    strmantysa = s[13:end]

    if strznak - '0' == 0
        znak = 1.0
    else
        znak = -1.0
    end

    cecha = -1023

    mantysa = 1.0

    for i in [1:11;]
        cyfra = strcecha[i] - '0'
        cecha += cyfra * (2.0^(11-i))
    end

    for i in [1:52;]
        cyfra = strmantysa[i] - '0'
        mantysa += cyfra * 2.0^(-i)
    end

    znak * mantysa * 2.0^cecha
    
end