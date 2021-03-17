import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.FlowLayout;
import java.awt.HeadlessException;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.IOException;
import java.net.URI;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;

public class DialogWindow extends JFrame{
	private JDialog d;
	private JLabel message;
	private JFrame f;
	DialogWindow(String name, String message){
		f = new JFrame();
		d = new JDialog(f, name, true);
		d.setLayout(new FlowLayout());
		
		d.add(new JLabel(message));
		
	}
	
	public void setHyperLink(URI link) throws HeadlessException{
		Singleton string = Singleton.getInstance();
		
		String text = string.s;
		JLabel hyperlink = new JLabel(text);
 
        hyperlink.setForeground(Color.BLUE.darker());
        hyperlink.setCursor(new Cursor(Cursor.HAND_CURSOR));
 
        hyperlink.addMouseListener(new MouseAdapter() {
 
            @Override
            public void mouseClicked(MouseEvent e) {
                try {
                    Desktop.getDesktop().browse(link);
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
 
            @Override
            public void mouseExited(MouseEvent e) {
                hyperlink.setText(text);
            }
 
            @Override
            public void mouseEntered(MouseEvent e) {
                hyperlink.setText("<html><a href=''>" + text + "</a></html>");
            }
 
        });
        
        d.getContentPane().add(hyperlink);
		d.setSize(250,80);
		d.setResizable(false);
        d.setVisible(true);
        
	}

}