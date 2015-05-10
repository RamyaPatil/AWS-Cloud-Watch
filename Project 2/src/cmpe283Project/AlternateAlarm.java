package cmpe283;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

public class AlternateAlarm extends Thread {
	
	static HashMap<String,Object> sqlMap = new HashMap<String,Object>();
	static ArrayList<AlarmDetails> alarmDetailsArray = new ArrayList<AlarmDetails>();
	static Set<String> keys;
	static String driverName = "com.mysql.jdbc.Driver";
	static String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
	static String user = "clouduser";
	static String dbpsw = "clouduser";


	public void run()
	{		
		Connection con= null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    String vmNameKey = null;
	    AlarmDetails al;
	    
	    while(true)
	    {
	    String sql1 = "select * from alarms where diskReadEmailSent=? or diskWriteEmailSent=? or cpuEmailSent=? or memoryEmailSent=? or networkEmailSent=?";
	    try {
	    	Class.forName(driverName);
	        con = DriverManager.getConnection(url, user, dbpsw);
	        ps = con.prepareStatement(sql1);
	        ps.setString(1, "false");
	        ps.setString(2, "false");
	        ps.setString(3, "false");
	        ps.setString(4, "false");
	        ps.setString(5, "false");
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
	        	al.setDiskReadEmailSent(rs.getString("diskReadEmailSent"));
	        	al.setCpuEmailSent(rs.getString("cpuEmailSent"));
	        	al.setDiskWriteEmailSent(rs.getString("diskWriteEmailSent"));
	        	al.setNetworkEmailSent(rs.getString("networkEmailSent"));
	        	al.setMemoryEmailSent(rs.getString("memoryEmailSent"));
	        	al.setNetworkEmailSent(rs.getString("networkEmailSent"));
	        	al.setPeriod(rs.getInt("period"));  
	        	al.setVmName(rs.getString("vmName"));
	        	vmNameKey = rs.getString("vmName");
	        	if (!sqlMap.containsKey(vmNameKey))
	        	{
	        		sqlMap.put(vmNameKey, al);
	        	}
	        	else
	        	{
	        		AlarmDetails al2 = (AlarmDetails)sqlMap.get(vmNameKey);
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
	        			al2.setDiskReadEmailSent(al.getDiskReadEmailSent());
	        			al2.setDiskWriteEmailSent(al.getDiskWriteEmailSent());
	        			al2.setCpuEmailSent(al.getCpuEmailSent());
	        			al2.setNetworkEmailSent(al.getNetworkEmailSent());
	        			al2.setMemoryEmailSent(al.getMemoryEmailSent());
	        			al2.setPeriod(al.getPeriod());
	        			al2.setUserName(al.getUserName());
	        			al2.setVmName(al.getVmName());
	        			sqlMap.put(vmNameKey, al2);
	        			
	        		}
	        			
	        	}
	        }	
	        rs.close();
            ps.close();
            
            keys = sqlMap.keySet();
            for(String i : keys)
        	{
            	alarmDetailsArray.add((AlarmDetails)sqlMap.get(i));
        	}
            	
	        }catch(Exception sqe)
	    	{
		        System.out.println(sqe);
		    }

    		for ( int k=0; k<alarmDetailsArray.size();k++ )
    		{
    			Map<String,Map<String,Long>> elasticMap = null;
	    		elasticMap = ElasticSearch.getElasticData(alarmDetailsArray.get(k).getVmName());
	    		Iterator iterator = elasticMap.entrySet().iterator();
	    		Map<String,Long> valueMap = null;
	    		while(iterator.hasNext())
	    		{
	    			Entry thisentry = (Entry) iterator.next();
	    			valueMap = (Map<String, Long>) thisentry.getValue();
	    			if((alarmDetailsArray.get(k).getDisk_read() != -1 && !alarmDetailsArray.get(k).getDiskReadEmailSent().contentEquals("true")) &&
	    					(valueMap.get("diskread") >= alarmDetailsArray.get(k).getDisk_read()))
	    			{
	    				String dr = "diskReadEmailSent";
	    				String subject = "ATTENTION! Disk_Read Threshhold reached for"+alarmDetailsArray.get(k).getVmName();
						String body = "Please check your VM's.";
						updateEmailSent(alarmDetailsArray.get(k).getVmName(),dr);	
						alarmDetailsArray.get(k).setDiskReadEmailSent("true");
						SendEmail.sendMail(alarmDetailsArray.get(k).getEmailId(),subject,body);
	    			}
	    			
	    			if(((alarmDetailsArray.get(k).getDisk_write() != -1) && (!alarmDetailsArray.get(k).getDiskWriteEmailSent().contentEquals("true")) && (valueMap.get("diskwrite") >= alarmDetailsArray.get(k).getDisk_write())))
	    			{
	    				String dw = "diskWriteEmailSent";
	    				String subject = "ATTENTION! Disk_Write Threshhold reached for"+alarmDetailsArray.get(k).getVmName();
						String body = "Please check your VM's.";
						
						updateEmailSent(alarmDetailsArray.get(k).getVmName(),dw);	
						alarmDetailsArray.get(k).setDiskWriteEmailSent("true");
						SendEmail.sendMail(alarmDetailsArray.get(k).getEmailId(),subject,body);
	    			}
	    			
	    			if((alarmDetailsArray.get(k).getCpu() != -1) && (!alarmDetailsArray.get(k).getCpuEmailSent().contentEquals("true")) &&
	    					(valueMap.get("cpu") >= alarmDetailsArray.get(k).getCpu()))
	    			{
	    				String c = "cpuEmailSent";
	    				String subject = "ATTENTION! CPU Threshhold reached for"+alarmDetailsArray.get(k).getVmName();
						String body = "Please check your VM's.";
						
						updateEmailSent(alarmDetailsArray.get(k).getVmName(),c);
						alarmDetailsArray.get(k).setCpuEmailSent("true");
						SendEmail.sendMail(alarmDetailsArray.get(k).getEmailId(),subject,body);
	    			}
	    			if((alarmDetailsArray.get(k).getMemory() != -1) && (!alarmDetailsArray.get(k).getMemoryEmailSent().contentEquals("true")) && 
	    					(valueMap.get("mem") >= alarmDetailsArray.get(k).getMemory()))
	    			{
	    				String m = "memoryEmailSent";
	    				String subject = "ATTENTION! Memory Threshhold reached for"+alarmDetailsArray.get(k).getVmName();
						String body = "Please check your VM's.";
						
						updateEmailSent(alarmDetailsArray.get(k).getVmName(),m);
						alarmDetailsArray.get(k).setMemoryEmailSent("true");
						SendEmail.sendMail(alarmDetailsArray.get(k).getEmailId(),subject,body);
	    			}
	    			if((alarmDetailsArray.get(k).getNetwork() != -1) && (!alarmDetailsArray.get(k).getNetworkEmailSent().contentEquals("true")) && 
	    					(valueMap.get("net") >= alarmDetailsArray.get(k).getNetwork()))
	    			{
	    				String n = "networkEmailSent";
	    				String subject = "ATTENTION! Network Threshhold reached for"+alarmDetailsArray.get(k).getVmName();
						String body = "Please check your VM's.";
						
						updateEmailSent(alarmDetailsArray.get(k).getVmName(),n);
						alarmDetailsArray.get(k).setNetworkEmailSent("true");
						SendEmail.sendMail(alarmDetailsArray.get(k).getEmailId(),subject,body);
	    			}
	    		}
    		
    		}
    		try{
                Thread.sleep(5000);
            } catch(Exception e){
                
        }
	}
}

	
private static void updateEmailSent(String vmName, String metric) {

	Connection con= null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
	String sql1 = "update alarms set "+metric+" ='true' where vmName= '"+ vmName +"';";
    
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
        try {
			int t = ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		

	}
}
	
	
	
	