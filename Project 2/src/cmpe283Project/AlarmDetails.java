package cmpe283;
public class AlarmDetails{
	
	private String userName = null;
	private String vmName = null;
	private String emailId = null;
	private int cpu = 0;
	private int network = 0;
	private int memory = 0;
	private int disk_read = 0;
	private int disk_write = 0;
	private String diskReadEmailSent = null;
	private String diskWriteEmailSent = null;
	private String cpuEmailSent = null;
	private String memoryEmailSent = null;
	private String networkEmailSent = null;	
	private int period = 0;
//	private int originalPeriod = 0;
	
	public String getUserName() {
		return userName;
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
	public String getDiskReadEmailSent() {
		return diskReadEmailSent;
	}
	public void setDiskReadEmailSent(String diskReadEmailSent) {
		this.diskReadEmailSent = diskReadEmailSent;
	}
	public String getDiskWriteEmailSent() {
		return diskWriteEmailSent;
	}
	public void setDiskWriteEmailSent(String diskWriteEmailSent) {
		this.diskWriteEmailSent = diskWriteEmailSent;
	}
	public String getCpuEmailSent() {
		return cpuEmailSent;
	}
	public void setCpuEmailSent(String cpuEmailSent) {
		this.cpuEmailSent = cpuEmailSent;
	}
	public String getMemoryEmailSent() {
		return memoryEmailSent;
	}
	public void setMemoryEmailSent(String memoryEmailSent) {
		this.memoryEmailSent = memoryEmailSent;
	}
	public String getNetworkEmailSent() {
		return networkEmailSent;
	}
	public void setNetworkEmailSent(String networkEmailSent) {
		this.networkEmailSent = networkEmailSent;
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