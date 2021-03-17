function suma_rosnaca(n)
    suma = 0.0
    for k in 0:n
        if k%2==0
            suma+=1/(2*k + 1)
        else
            suma-=1/(2*k + 1)
        end
    end
    4.0*suma
end

function suma_malejaca(n)
    suma = 0.0
    for k in reverse(0:n)
        if k%2==0
            suma+=1/(2*k + 1)
        else
            suma-=1/(2*k + 1)
        end
    end
    4.0*suma
end

function relativeError(f,n)
    pi = f(Float32(n))
    Δpi = Float32(π) - pi
    Float32(abs(Δpi/pi))
end


function test(f, n)
    pi = f(Float32(n))
    relative_error = relativeError(f,n)
    accuracy = floor(-log10(relative_error))
    println("n=$n:\n$pi\nSignif. digits: $accuracy\n relativeerror: $relative_error\n")
end

function relativeErrorRatio(n)
    ratio = relativeError(suma_rosnaca,n) / relativeError(suma_malejaca,n)
    println("n=$n, ratio=$ratio \n")
end


for k in 1:7
    test(suma_rosnaca, 10^k)
end

for k in 1:7
    test(suma_malejaca, 10^k)
end

for k in 1:7
    relativeErrorRatio(10^k)
end

println("======================================================")
