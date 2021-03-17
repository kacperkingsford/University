import java.awt.BorderLayout;
import javax.swing.JFrame;

public class MainFrame extends JFrame{

	private Toolbar toolbar;
	private FormPanel formPanel;
	private Table table;
	
	public MainFrame() {
		super("Database App");
		
		setLayout(new BorderLayout());
		
		toolbar = new Toolbar();
		formPanel = new FormPanel();
		table = new Table();
		
		
		formPanel.setFormListener(new FormListener() {
		public void formEventOccurred(FormEvent e) {
			String name = e.getName();
			String occupation = e.getOccupation();
			String ageCat = e.getAgeCategory();
			String empCat = e.getEmploymendCategory();
			boolean citizenCheck = e.isUsCitizen();
			String taxField = e.getTaxId();
			
			table.addData(name, occupation, ageCat, empCat, citizenCheck, taxField);
		}
	});
		
		
		add(formPanel, BorderLayout.WEST);
		add(toolbar, BorderLayout.NORTH);
		add(table, BorderLayout.CENTER);
		
		
		setSize(1000,500);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setVisible(true);
		setResizable(true);
	}
}
