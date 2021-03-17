import javax.swing.*;
import java.awt.*;

public class MainMenu extends JFrame {
    GamePanel boardPanel;
    JLabel gameState;
    Samotnik samotnikIns = Samotnik.getInstance();

    public MainMenu() {
        setTitle("Peg solitaire");
        setSize(800, 800);
        setJMenuBar(new MenuBar(this));
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        boardPanel = new GamePanel(this);
        gameState = new JLabel("", SwingConstants.CENTER);
        setLayout(new BorderLayout());
        add(boardPanel, BorderLayout.CENTER);
        add(gameState, BorderLayout.SOUTH);
    }

    public void Update() {
        if(samotnikIns.isGameOver()){
            gameState.setText("Game over!");
        }
        else gameState.setText(Integer.toString(samotnikIns.getHowManyPieces())+" pionkow zostalo");
        boardPanel.repaint();
    }

    public void Run()
    {
        setLocationRelativeTo(null);
        setResizable(true);
        setVisible(true);
    }

}