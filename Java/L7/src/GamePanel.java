import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.geom.Ellipse2D;

public class GamePanel extends JPanel implements MouseListener {
    private final PegSolitaireBoard mainBoard;
    private Shape[][] circle;
    private PopupMenu menu;
    private Samotnik samotnikIns = Samotnik.getInstance();
    private MainMenu window;

    public GamePanel(MainMenu window){
        setBackground(Color.WHITE);
        this.window = window;
        samotnikIns.newGame();
        mainBoard = samotnikIns.board;
        circle = new Shape[7][7];
        addMouseListener(this);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D)g;

        for(int i = 0; i<7; i++) {
            for(int j = 0; j<7;j++) {
                circle[i][j] = new Ellipse2D.Double(70+70*(i+1), 30+70*(j+1) ,60 ,60);
                if(!mainBoard.IsPiece(i, j)){
                    g2d.setPaint(Color.WHITE);
                    g2d.fill(circle[i][j]);
                }
                else if(mainBoard.isFilled(i, j)){
                    if(mainBoard.IsSelected(i ,j)){
                        g2d.setPaint(Color.RED);
                        g2d.fill(circle[i][j]);
                    }
                    else {
                        g2d.setPaint(Color.BLACK);
                        g2d.fill(circle[i][j]);
                    }
                }
                else {
                    g2d.setPaint(Color.LIGHT_GRAY);
                    g2d.fill(circle[i][j]);
                }
            }
        }
    }

    @Override
    public void mouseClicked(MouseEvent mouseEvent) {
        if(mouseEvent.getButton() == MouseEvent.BUTTON1) {
            int i, j;
            i = (((mouseEvent.getX()-70)/70)-1);
            j = (((mouseEvent.getY()-30)/70)-1);
            samotnikIns.setxSelected(i);
            samotnikIns.setySelected(j);

            if(mainBoard.turn == PegSolitaireBoard.Turn.MOVEMENT){
                mainBoard.Select(i, j);
            }
            else if(mainBoard.turn == PegSolitaireBoard.Turn.SELECTION) {
                mainBoard.MovePiece(mainBoard.getSelectedX(), mainBoard.getSelectedY(), i, j);
                mainBoard.turn = PegSolitaireBoard.Turn.MOVEMENT;
            }
            repaint();
        }
        if(mouseEvent.getButton() == MouseEvent.BUTTON3){
            menu = new PopupMenu((((mouseEvent.getX()-70)/70)-1), (((mouseEvent.getY()-30)/70)-1));
            menu.show(mouseEvent.getComponent(), mouseEvent.getX(), mouseEvent.getY());
            repaint();
        }
        window.Update();
    }

    @Override
    public void mouseEntered(MouseEvent mouseEvent) {
        //
    }

    @Override
    public void mousePressed(MouseEvent mouseEvent) {
        //
    }

    @Override
    public void mouseReleased(MouseEvent mouseEvent) {
        //
    }

    @Override
    public void mouseExited(MouseEvent mouseEvent) {
        //
    }
}