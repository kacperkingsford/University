import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;

public class PopupMenu extends JPopupMenu implements ItemListener, ActionListener {

    private final JMenuItem mRight, mLeft, mUp, mDown;
    private Samotnik samotnikIns;
    private int selectedX, selectedY;

    public PopupMenu(int selectedX, int selectedY) {
        mRight = new JMenuItem("Ruch w prawo");
        mDown = new JMenuItem("Ruch w dol");
        mUp = new JMenuItem("Ruch w gore");
        mLeft = new JMenuItem("Ruch w lewo");
        samotnikIns = Samotnik.getInstance();

        this.selectedX = selectedX;
        this.selectedY = selectedY;

        mRight.addActionListener(this);
        mDown.addActionListener(this);
        mUp.addActionListener(this);
        mLeft.addActionListener(this);

        add(mRight);
        add(mDown);
        add(mUp);
        add(mLeft);

        setCommand();
    }

    private void setCommand() {
        mRight.setActionCommand("RIGHT");
        mDown.setActionCommand("DOWN");
        mLeft.setActionCommand("LEFT");
        mUp.setActionCommand("UP");
    }

    public void actionPerformed(ActionEvent e){
        switch(e.getActionCommand()){
            case "RIGHT":
                samotnikIns.MovePiece(selectedX, selectedY, selectedX+2, selectedY);
                break;
            case "DOWN":
                samotnikIns.MovePiece(selectedX, selectedY, selectedX, selectedY+2);
                break;
            case "LEFT":
                samotnikIns.MovePiece(selectedX, selectedY, selectedX-2, selectedY);
                break;
            case "UP":
                samotnikIns.MovePiece(selectedX, selectedY, selectedX, selectedY-2);
                break;
        }
    }

    public void itemStateChanged(ItemEvent e){
        //
    }

}