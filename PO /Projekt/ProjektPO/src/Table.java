import java.awt.BorderLayout;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class Table extends JPanel {
	private JTable table;
	
	public Table(){
		setLayout(new BorderLayout());
		
		String[] columnNames = {"Name", "Occupation", "Age", "Employment", "US Citizen", "Tax ID"};
		Object [][] data = {

		};
		
		DefaultTableModel model = new DefaultTableModel(data, columnNames);
		
		table = new JTable(model){
			
			public boolean isCellEditable(int row, int column){
				return false;
			}
			
			public Class getColumnClass(int column) {
                switch (column) {
                    case 4:
                        return Boolean.class;
                    default:
                    	return String.class;
                }
            }
		};
		
		table.setFillsViewportHeight(true);
		add(new JScrollPane(table), BorderLayout.CENTER);
		table.getTableHeader().setReorderingAllowed(false);
	}
	
	public void addData(String nameField, String occupationField, String ageCat, String empCombo, boolean citizenCheck, String taxField){
		DefaultTableModel model = (DefaultTableModel) table.getModel();
		model.addRow(new Object[]{nameField, occupationField, ageCat, empCombo, citizenCheck, (citizenCheck == false) ? (String) "              -" : (String) taxField});
	}
	
}
