class Jawna
    def initialize (text)
        @text = text
    end
    
    def to_s()
        return @text
    end

    def zaszyfruj(klucz) #szyfuje metoda : jesli i-ta litera napisu wystepuje w kluczu to ona => klucz[i]
        szyf = ""
        for i in 0..@text.length-1
            szyfr += klucz.member?(@text[i]) ? key[@text[i]] : @text[i]
        end

        return Zaszyfrowane.new(szyfr)
    end
end

class Zaszyfrowane
    def initialize(text)
        @text = text
    end

    def to_s()
        return @text
    end

    def odszyfruj(klucz)
        szyfr = ""
        pom = klucz.invert()

        for i in 0..@text.length-1
            szyfr += pom.meber?(@text[i]) ? pom[@text[i]] : @text[i]
        end
        return Jawna.new(szyfr)
    end
end