package struktury;

import java.util.Objects;
import java.util.regex.Pattern;

public class Para {
    public final String key;
    private double value;

    public String toString() {
        return "Klucz: " + this.key + " " + "Wartość: " + this.value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Para para = (Para) o;
        return Objects.equals(key, para.key);
    }


    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public Para(String key, double value) {
        final Pattern textPattern = Pattern.compile("[a-z]");
        if(key != null && textPattern.matcher(key).matches()) {
            this.key = key;
            this.value = value;
        }
        else throw new IllegalArgumentException("Klucz nie spełnia warunków zadania!");
    }
}
