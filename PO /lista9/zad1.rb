class Funkcja
    def initialize(proc)
        throw :invalid_function unless proc.is_a?(Proc)
        @proc = proc
    end

    def value(x)
        @proc.call(x)
    end

    private def equals? (a, b, eps)
        if (a <= b + eps) and (a >= b - eps)
        r   eturn true
        else
            return false
        end
    end

    def zerowe(a, b, e)
        if value(a) == 0
            return a
        elsif value(b) == 0
            return b
        elsif equals?(a, b, e)
            return nil
        end

        s = (a + b).to_f / 2

        if equals?(value(s), 0, e)
            return s
        else
            if value(s) * value(a) < 0
                return zero(a, s, e)
            else return zero(s, b, e)
            end
        end
    end

    def area(a, b)
        @@accuracy = 0.001
        if a >= b
            return 0
        else
            y1 = value(a).to_f
            y2 = value(a + @@accuracy).to_f
            return ((y1 + y2) * 0.5 * @@accuracy) + area(a + @@accuracy, b)
        end
    end

    def pochodna(x)
        @@h = 0.00001
        return (value(x + @@h) - value(x)) / @@h
    end
end