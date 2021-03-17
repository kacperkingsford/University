import java.awt.FlowLayout;
import java.awt.HeadlessException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URI;
import java.net.URISyntaxException;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JPanel;

public class Toolbar extends JPanel implements ActionListener{
	private JButton b1;
	private JButton b2;
		
	
	public Toolbar(){
		
		setBorder(BorderFactory.createEtchedBorder());
		b1 = new JButton("About creator");
		
		b1.addActionListener(this);
		
		setLayout(new FlowLayout(FlowLayout.LEFT));
		add(b1);
	}


	@Override
	public void actionPerformed(ActionEvent e) {
		JButton clicked = (JButton) e.getSource();
		
		if(clicked == b1){
			DialogWindow win = new DialogWindow("About creator", "Created by Kacper Kingsford");
			try {
				win.setHyperLink(new URI("https://github.com/kacperkingsford"));
			} catch (HeadlessException e1) {
				e1.printStackTrace();
			} catch (URISyntaxException e1) {
				e1.printStackTrace();
			}
		}
	}
	
}
