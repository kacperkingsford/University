package struktury;

public class ZbiorNaTablicy extends Zbior {
    private Para[] tablica;
    private int rozmiar;

    public ZbiorNaTablicy(int rozmiar) throws Exception {
        if (rozmiar < 2) throw new Exception("Rozmiar tablicy nie może być mniejszy do 2!");
        else {
            this.rozmiar = rozmiar;
            this.tablica = new Para[rozmiar];
        }
    }


    @Override
    public Para szukaj(String k) throws Exception {
        Para[] tab = this.tablica;
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] != null && tab[i].key.equals(k)) {
                return tab[i];
            }
        }
        throw new Exception("Brak pary o podanym kluczu!");
    }

    @Override
    public void wstaw(Para p) throws Exception {
        Para[] tab = this.tablica;
        boolean znalezionaPozycja = false;
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] != null && tab[i].equals(p)) {
                throw new Exception("Para o podanym kluczu jest już w zbiorze!");
            }
        }
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] == null && !znalezionaPozycja) {
                this.tablica[i] = p;
                znalezionaPozycja = true;
            }
        }
        if (!znalezionaPozycja) {
            throw new Exception("Brak miejsca w tablicy!");
        }
    }

    @Override
    public void usun(String k) {
        Para[] tab = this.tablica;
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] != null && tab[i].key.equals(k)) {
                tab[i] = null;
                for (int j = i + 1; j < this.rozmiar; j++) {
                    if (tab[j] != null) {
                        tab[j - 1] = tab[j];
                    }
                    if (j == this.rozmiar - 1) {
                        tab[j] = null;
                    }
                }

            }
        }
    }

    @Override
    public double czytaj(String k) throws Exception {
        Para[] tab = this.tablica;
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] != null && tab[i].key.equals(k)) {
                return tab[i].getValue();
            }
        }
        throw new Exception("Brak pary o podanym kluczu w zbiorze!");
    }

    @Override
    public void ustaw(Para p) throws Exception {
        Para[] tab = this.tablica;
        boolean ostatniaZajetaPozycja = false;
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] != null && tab[i].equals(p)) {
                tab[i].setValue(p.getValue());
            }
        }
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] == null && !ostatniaZajetaPozycja) {
                ostatniaZajetaPozycja = true;
                tab[i] = p;
            }
        }
        throw new Exception("Brak miejsc w tablicy!");
    }

    @Override
    public void czysc() {
        Para[] tab = this.tablica;
        for (int i = 0; i < this.rozmiar; i++) {
            if (tab[i] != null) {
                tab[i] = null;
            }
        }
    }

    @Override
    public int ile() {
        int iloscPar = 0;
        for (int i = 0; i < this.rozmiar; i++) {
            if (this.tablica[i] != null) {
                iloscPar++;
            }
        }
        return iloscPar;
    }

    public int getRozmiar() {
        return rozmiar;
    }

    public void setRozmiar(int rozmiar) {
        this.rozmiar = rozmiar;
    }

    public Para[] getTablica() {
        return tablica;
    }

    public void setTablica(Para[] tablica) {
        this.tablica = tablica;
    }
}
