import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

public class Alarm extends Thread{
	
	public static String driverName = "com.mysql.jdbc.Driver";
	public static String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
	public static String user = "clouduser";
	public static String dbpsw = "clouduser";
	
	public static void main(String[] args) throws Exception {
		
	AlarmDetails al;
	
	HashMap<String,Object> map1 = new HashMap<String,Object>();
	Map<String,Long> Innermap = new HashMap<String,Long>(); 
	Map<String,Map<String,Long>> elastiMap = null;

	Connection con= null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String vmNameKey = null;
    
    String sql1 = "select * from alarms where emailSent=?";
    try {
    	Class.forName(driverName);
        con = DriverManager.getConnection(url, user, dbpsw);
        ps = con.prepareStatement(sql1);
        ps.setString(1, "false");  
     //   ps.setString(2, "false"); 
        rs = ps.executeQuery();
        while(rs.next())
        {	        
        	al = new AlarmDetails();
        	al.setUserName(rs.getString("userName"));
        	al.setEmailId(rs.getString("emailId"));
        	al.setCpu(rs.getInt("cpuUsage"));
        	al.setNetwork(rs.getInt("ntwUsage"));
        	al.setMemory(rs.getInt("memoryUsage"));
        	al.setDisk_read(rs.getInt("diskRead"));
        	al.setDisk_write(rs.getInt("diskWrite"));
        	al.setEmailSent(rs.getString("emailSent"));
        	al.setPeriod(rs.getInt("period")); 
        	al.setOriginalPeriod(rs.getInt("period")); 
        	al.setVmName(rs.getString("vmName"));
        	vmNameKey = rs.getString("vmName");
        	if (!map1.containsKey(vmNameKey))
        	{
        		map1.put(vmNameKey, al);
        	}
        	else
        	{
        		AlarmDetails al2 = (AlarmDetails)map1.get(vmNameKey);
        		if ( al2.getCpu() != al.getCpu() || al2.getDisk_read() != al.getDisk_read() || 
        				al2.getDisk_write() != al.getDisk_write() || al2.getMemory() != al.getMemory()
        				|| al2.getNetwork() != al.getNetwork())
        		{
        			al2.setCpu(al.getCpu());
        			al2.setDisk_read(al.getDisk_read());
        			al2.setDisk_write(al.getDisk_write());
        			al2.setMemory(al.getMemory());
        			al2.setNetwork(al.getNetwork());
        			al2.setEmailId(al.getEmailId());
        			al2.setEmailSent(al.getEmailSent());
        			al2.setPeriod(al.getPeriod());
        			al2.setUserName(al.getUserName());
        			al2.setVmName(al.getVmName());
        			map1.put(vmNameKey, al2);
        			
        		}
        			
        	}
        	
        }       
        	rs.close();
            ps.close();
    } catch(Exception sqe)
    {
        System.out.println(sqe);
    }
    
    	Set<String> keys = map1.keySet();
        
    	ArrayList<AlarmDetails> alarmDetailsArray = new ArrayList<AlarmDetails>();
    	for(String i : keys)
    	{
    		alarmDetailsArray.add((AlarmDetails)map1.get(i));
    	}
    	
    	while(true)
    	{
    	int j = 0;
    	for (String i : keys)
    	{
    		//AlarmDetails alarmDetail = alarmDetailsArray.get(j); 
        	elastiMap = ElasticSearch.getElasticData(alarmDetailsArray.get(j).getVmName());
    		Iterator iterator = elastiMap.entrySet().iterator();
    		Map<String,Long> valueMap = null;
    		int counter = 999;
    		
    		while(iterator.hasNext())
    		{
    			Entry thisentry = (Entry) iterator.next();
    			valueMap = (Map<String, Long>) thisentry.getValue();
    			System.out.println("key ***"+thisentry.getKey() +" value: " + thisentry.getValue());
    				if((alarmDetailsArray.get(j).getDisk_read() != -1 && valueMap.get("diskread") >= alarmDetailsArray.get(j).getDisk_read()) ||
    						(alarmDetailsArray.get(j).getMemory() != -1 && valueMap.get("mem") >= alarmDetailsArray.get(j).getMemory()) ||
    								(alarmDetailsArray.get(j).getCpu() != -1 && valueMap.get("cpu") >= alarmDetailsArray.get(j).getCpu()) ||
    								(alarmDetailsArray.get(j).getNetwork() != -1 && valueMap.get("net") >= alarmDetailsArray.get(j).getNetwork()) ||
    										(alarmDetailsArray.get(j).getDisk_write() != -1 && valueMap.get("diskwrite") >= alarmDetailsArray.get(j).getDisk_write()))
    				{    					
    					alarmDetailsArray.get(j).setPeriod(alarmDetailsArray.get(j).getPeriod() - 1);
    					if(alarmDetailsArray.get(j).getPeriod() == 0)
    					{
    						System.out.println("Send email....!!");
    						String subject = "ATTENTION! Threshhold reached...";
    						String body = "Please check your VM's.";
    						SendEmail.sendMail(alarmDetailsArray.get(j).getVmName(),subject,body);
    						alarmDetailsArray.get(j).setPeriod(alarmDetailsArray.get(j).getOriginalPeriod());
    						
    						updateEmailSent(alarmDetailsArray.get(j).getVmName());
    						//alarmDetailsArray.get(j).setEmailSent("true");
    						
    						map1.remove(alarmDetailsArray.get(j).getVmName());
    						alarmDetailsArray.remove(j);
    					}
    				}
    		}
    		j++;
    	}  
        }
	}
	
	private static void updateEmailSent(String vmName) {

		Connection con= null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		String sql1 = "update alarms set emailSent='true' where vmName='"+ vmName +"';";
	    
	    	try {
				Class.forName(driverName);
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        try {
				con = DriverManager.getConnection(url, user, dbpsw);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        try {
				ps = con.prepareStatement(sql1);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//	        try {
//				ps.setString(1, "true");
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}  
	     //   ps.setString(2, "false"); 
	        try {
				int t = ps.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
    
	}
}

