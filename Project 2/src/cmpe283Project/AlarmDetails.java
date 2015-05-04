
public class AlarmDetails{
	
	private String userName = null;
	private String vmName = null;
	private String emailId = null;
	private int cpu = 0;
	private int network = 0;
	private int memory = 0;
	private int disk_read = 0;
	private int disk_write = 0;
	private String emailSent = null;
	private int period = 0;
	private int originalPeriod = 0;
	
	public String getUserName() {
		return userName;
	}
	public int getOriginalPeriod() {
		return originalPeriod;
	}
	public void setOriginalPeriod(int originalPeriod) {
		this.originalPeriod = originalPeriod;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getEmailId() {
		return emailId;
	}
	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}
	public int getCpu() {
		return cpu;
	}
	public void setCpu(int cpu) {
		this.cpu = cpu;
	}
	public int getNetwork() {
		return network;
	}
	public void setNetwork(int network) {
		this.network = network;
	}
	public int getMemory() {
		return memory;
	}
	public void setMemory(int memory) {
		this.memory = memory;
	}
	public int getDisk_read() {
		return disk_read;
	}
	public void setDisk_read(int disk_read) {
		this.disk_read = disk_read;
	}
	public int getDisk_write() {
		return disk_write;
	}
	public void setDisk_write(int disk_write) {
		this.disk_write = disk_write;
	}
	public String getEmailSent() {
		return emailSent;
	}
	public void setEmailSent(String emailSent) {
		this.emailSent = emailSent;
	}
	public int getPeriod() {
		return period;
	}
	public void setPeriod(int period) {
		this.period = period;
	}
	public void setVmName(String vmName) {
		this.vmName = vmName;
		
	}
	public String getVmName() {
		// TODO Auto-generated method stub
		return vmName;
	}
}