import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MenuBar extends JMenuBar implements ActionListener{
    private JMenu gra, ruchy, ustawienia, pomoc;
    private JMenuItem graNowa, graKoniec;
    private JMenuItem ruchyGora, ruchyDol, ruchyPrawo, ruchyLewo;
    private JRadioButtonMenuItem british, european;
    private JMenuItem oGrze, oAplikacji;

    private  MainMenu window;

    private Samotnik samotnikIns;

    public MenuBar(MainMenu window) {
        this.window = window;
        samotnikIns = Samotnik.getInstance();
        gra = new JMenu("Gra");
        graNowa = new JMenuItem("Nowa");
        graKoniec = new JMenuItem("Koniec");
        gra.add(graNowa);
        gra.add(graKoniec);

        graNowa.addActionListener(this);
        graKoniec.addActionListener(this);

        ruchy = new JMenu("Ruchy");
        ruchyGora = new JMenuItem("Ruch w gore");
        ruchyDol = new JMenuItem("Ruch w dol");
        ruchyPrawo = new JMenuItem("Ruch w prawo");
        ruchyLewo = new JMenuItem("Ruch w lewo");
        ruchy.add(ruchyGora);
        ruchy.add(ruchyDol);
        ruchy.add(ruchyLewo);
        ruchy.add(ruchyPrawo);

        ruchyGora.addActionListener(this);
        ruchyDol.addActionListener(this);
        ruchyPrawo.addActionListener(this);
        ruchyLewo.addActionListener(this);

        ustawienia = new JMenu("Ustawienia");
        british = new JRadioButtonMenuItem("Wersja brytyjska");
        european = new JRadioButtonMenuItem("Wersja europejska");
        british.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                samotnikIns.setVersion("BRITISH");
            }
        });

        european.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                samotnikIns.setVersion("EUROPEAN");
            }
        });

        ustawienia.add(british);
        ustawienia.add(european);

        pomoc = new JMenu("Pomoc");
        oGrze = new JMenuItem("O grze");
        oAplikacji = new JMenuItem("O aplikacji");
        pomoc.add(oGrze);
        pomoc.add(oAplikacji);

        add(gra);
        add(ruchy);
        add(ustawienia);
        add(pomoc);

        setCommand();

    }

    private void setCommand() {
        ruchyPrawo.setActionCommand("RIGHT");
        ruchyDol.setActionCommand("DOWN");
        ruchyLewo.setActionCommand("LEFT");
        ruchyGora.setActionCommand("UP");

        graNowa.setActionCommand("NEW_GAME");
        graKoniec.setActionCommand("END_GAME");
    }

    public void actionPerformed(ActionEvent e){
        switch(e.getActionCommand()){
            case "RIGHT":
                samotnikIns.MovePiece(samotnikIns.getxSelected(), samotnikIns.getySelected(), samotnikIns.getxSelected()+2, samotnikIns.getySelected());
                break;
            case "DOWN":
                samotnikIns.MovePiece(samotnikIns.getxSelected(), samotnikIns.getySelected(), samotnikIns.getxSelected(), samotnikIns.getySelected()+2);
                break;
            case "LEFT":
                samotnikIns.MovePiece(samotnikIns.getxSelected(), samotnikIns.getySelected(), samotnikIns.getxSelected()-2, samotnikIns.getySelected());
                break;
            case "UP":
                samotnikIns.MovePiece(samotnikIns.getxSelected(), samotnikIns.getySelected(), samotnikIns.getxSelected(), samotnikIns.getySelected()-2);
                break;
            case "NEW_GAME":
                samotnikIns.newGame();
                window.dispose();
                window = new MainMenu();
                window.Run();
                break;
            case "END_GAME":
                window.dispose();

                break;
        }
    }
}