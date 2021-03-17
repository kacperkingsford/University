package struktury;

public class ZbiorNaTablicyDynamicznej extends ZbiorNaTablicy {

    public ZbiorNaTablicyDynamicznej() throws Exception {
        super(2);
    }

    @Override
    public void wstaw(Para p) throws Exception {
        Para[] tab = this.getTablica();
        int rozmiar = this.getRozmiar();
        boolean znalezionaPozycja = false;
        for (int i = 0; i < rozmiar; i++) {
            if (tab[i] != null && tab[i].equals(p)) {
                throw new Exception("Para o podanym kluczu jest już w zbiorze!");
            }
        }
        for (int i = 0; i < rozmiar; i++) {
            if (tab[i] == null && !znalezionaPozycja) {
                tab[i] = p;
                znalezionaPozycja = true;
            }
        }

        if (!znalezionaPozycja) {
            Para[] nowaTablica = new Para[2 * rozmiar];
            for (int i = 0; i < rozmiar; i++) {
                if (tab[i] != null) {
                    nowaTablica[i] = tab[i];
                }
            }
            nowaTablica[rozmiar] = p;
            this.setTablica(nowaTablica);
            this.setRozmiar(2 * rozmiar);
        }
    }

    @Override
    public void usun(String k) {
        super.usun(k);
        int iloscZapelnionychPar = 0;
        for (int i = 0; i < this.getRozmiar(); i++) {
            if (this.getTablica()[i] != null) {
                iloscZapelnionychPar++;
            }
        }
        if(iloscZapelnionychPar < this.getRozmiar()/4) {
            this.setRozmiar(this.getRozmiar()/2);
        }
    }
}