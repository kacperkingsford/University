class Fixnum
    
    def czynniki()
        dzielniki = []
        sqrt = Math.sqrt(self)
        for i in 1..sqrt+1
            if self % i == 0
                dzielniki.push(i)
            end
        end
        dzielniki.push(self)
        return dzielniki
    end

    def ack(y)
        if self == 0
            return y+1
        elsif y == 0
            return (self-1).ack(1)
        else
            return (self-1).ack((self.ack(y-1)))
        end
    end

    def doskonala()
        tab = self.czynniki()
        suma = 0
        for i in 0...tab.length - 1
            suma += tab[i]
        end
        if suma == self
            return true
        else
            return false
        end
    end

    @@nazwy = {1 => 'jeden' , 2 => "dwa", 3 => "trzy", 4 => "cztery", 5 => "pięć", 6 => "sześć", 7 => "siedem", 8 => "osiem", 9 => "dziewięć", 0 => "zero"}
    def slownie()
        i = self
        slowa = []
        while i > 0
            slowa.push(@@nazwy[i%10])
            i/=10
        end

        wynik = ""
        t = slowa.length-1

        while t >= 0
            wynik += slowa[t] + " "
            t-=1
        end

        return wynik
    end
end