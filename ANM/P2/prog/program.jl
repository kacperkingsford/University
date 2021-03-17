using QuadGK
using Printf

#KacperKingsford ANM - P2 - 1.9

pi = MathConstants.pi;

function romberg(t::Array{Float64,1})
    n = length(t)
    et = zeros(n,n)
    et[:,1] = t
    for i = 2:n
        m = 2
        for j = 2:i
            r = 2^m
            et[i,j] = (r*et[i,j-1] - et[i-1,j-1])/(r - 1);
            m = m+2
         end
    end
    return et
end

function compositeTrapezoid(f::Function,a::Float64,b::Float64,n::Int64)
    t = zeros(n)
    h = (b-a)   
    m = 1     
    t[1] = (f(a) + f(b))*h/2
    for i = 2:n
        h = h/2
        for j=0:m-1
            t[i] = t[i] + f(a+h+j*2*h)
        end;
        t[i] = t[i-1]/2 + h*t[i]
        m = 2*m
    end
    return t, n
end

function printMatrix(t::Array{Float64,2},exact)
    a = 0
    for i=1:10
        for j=1:10
            a+=1
            print(t[a]-exact, " == " ) 
        end
        println()
    end
    
end

function RungegFuntion(x)
    return 1/(25* x^2 + 1)
end



function main()
    exact = quadgk(cos, 0, pi/2)[1] 
    n = 10
    a=2
    t, nit = compositeTrapezoid(cos,0.0,pi/2,n)
    println("The composite trapezium rule for cosinus:")
    for i=1:length(t)
        strerr = @sprintf("%.2e", abs(exact - t[i]))
        strapp = @sprintf("%.16e", t[i])
        println(a," $strapp  $strerr")
        a*=2
    end
        print("The number of iterations : ")
        println(nit)
        println()

    exact1 = quadgk(RungegFuntion, -1, 1)[1]
    b=2
    t1, nit1 = compositeTrapezoid(RungegFuntion,-1.0,1.0,n)
    println("The composite trapezium rule for RungegFuntion:")
    for i=1:length(t1)
        strerr1 = @sprintf("%.2e", abs(exact1 - t1[i]))
        strapp1 = @sprintf("%.16e", t1[i])
        println(b," $strapp1  $strerr1")
        b*=2
    end
        print("The number of iterations : ")
        println(nit1)

        println()

        println("Romberg method for cos function:")
        romberg(compositeTrapezoid(cos, 0.0, pi/2, n)[1])
        println()
        println("Matrix error:")
        printMatrix(romberg(compositeTrapezoid(cos, 0.0, pi/2, n)[1]), exact)
        

        println()

        println("Romberg method for Rungeg function:")
        romberg(compositeTrapezoid(RungegFuntion, -1.0, 1.0, n)[1])
        println()
        println("Matrix error:")
        printMatrix(romberg(compositeTrapezoid(RungegFuntion, -1.0, 1.0, n)[1]), exact1)

end


