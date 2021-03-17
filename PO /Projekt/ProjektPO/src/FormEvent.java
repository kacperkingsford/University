import java.util.EventObject;

public class FormEvent extends EventObject {

	private String name;
	private String occupation;
	private String ageCategory;
	private String empCat;
	private String taxId;
	private boolean usCitizen;
	
	public FormEvent(Object source) {
		super(source);
	}
	
	public FormEvent(Object source, String name, String occupation, String ageCat, String empcat, String taxId, boolean usCitizen){
		super(source);
		
		this.name = name;
		this.occupation = occupation;
		this.ageCategory = ageCat;
		this.empCat = empcat;
		this.taxId = taxId;
		this.usCitizen = usCitizen;
	}
	

	public String getTaxId() {
		return taxId;
	}

	public boolean isUsCitizen() {
		return usCitizen;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getOccupation() {
		return occupation;
	}

	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}
	
	public String getAgeCategory()
	{
		return ageCategory;
	}
	
	public String getEmploymendCategory(){
		return empCat;
	}
	
}
