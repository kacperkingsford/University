class Funkcja2
    def initialize(proc)
        throw :invalid_function unless proc.is_a?(Proc)
        @proc = proc
    end

    def value(x, y)
        @proc.call(x, y)
    end

    def poziomica(a,b,c,d,wysokosc)
        przyblizenie = 0.01
        result = []
        for x in a..b
          for y in c..d
            if (wysokosc - value(x, y)).abs < przyblizenie || (value(x, y) - wysokosc).abs < przyblizenie
              result += [[x, y]]
            end
          end
        end
        result
    end
end
