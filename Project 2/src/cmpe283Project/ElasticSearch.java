import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.lucene.util.LongValues;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.index.query.FilterBuilders;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;

public class ElasticSearch {
	private static Client client;
	
	static Map<String,Long> Innermap = new HashMap<String,Long>(); 
	
	static Map<String,Map<String,Long>> mp = new HashMap<String,Map<String,Long>>(); 

	private static String lastSearchTimeStamp = "2015-04-26T02:58:00Z";
	
	private static Client getClient() {
		client = new TransportClient().addTransportAddress(new InetSocketTransportAddress("54.183.233.221", 9300));
		return client;	
	}
	
	private static void closeClient() {
		client.close();
	}	
	
	
	public static List<Map<String,Object>> searchLogs(String vmName) {
		String cpu;
		getClient();
		
		List<Map<String,Object>> searchResult = new ArrayList<Map<String,Object>>();
		SearchResponse response = getClient().prepareSearch("logstash-*")
		        .setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
		        .setQuery(QueryBuilders.matchQuery("vmname", vmName))
		        .setPostFilter(FilterBuilders.rangeFilter("@timestamp").from(getCurrentSystemTimestampOfVM()))
		        .setFrom(0).setSize(5).setExplain(true)
		        .execute()
		        .actionGet();
		
		SearchHit[] results = response.getHits().getHits();
        
        for (SearchHit hit : results) {
            searchResult.add(hit.getSource());
          
        }
		closeClient();
		return searchResult;
	}
	
//	public static void main(String [] args)
//	{
	public static Map<String,Map<String,Long>> getElasticData( String vmName)
	{
		
		//lastSearchTimeStamp=getCurrentSystemTimestampOfVM();
		
		
		List<Map<String,Object>> searchResult = searchLogs(vmName);
		 //System.out.println(searchResult.get(0));
		 
		if(searchResult.size() > 0)
		{
		
		 System.out.println(searchResult.get(searchResult.size() -1));
		 Map<String,Object> resultEntry = searchResult.get(searchResult.size() -1);
		 long logValue = (((Integer) resultEntry.get("cpu")).longValue());
		System.out.println("cpu****" + logValue);
			
			Innermap.put("cpu",logValue);
			Innermap.put("mem",(((Integer) resultEntry.get("mem")).longValue()));
			System.out.println("diskwrite" + resultEntry.get("diskwrite"));
			Innermap.put("diskwrite", Long.parseLong(resultEntry.get("diskwrite").toString()));
			//Innermap.put("diskwrite",(((Integer) resultEntry.get("diskwrite")).longValue()));
			Innermap.put("net",(((Integer) resultEntry.get("net")).longValue()));
			//Innermap.put("diskread",(((Integer) resultEntry.get("diskread")).longValue()));
			Innermap.put("diskread", Long.parseLong(resultEntry.get("diskread").toString()));
			
			 mp.put(resultEntry.get("vmname").toString(), Innermap);
		}			 
//		Iterator i = mp.entrySet().iterator();
//		while(i.hasNext())
//		{
//			Entry thisentry = (Entry) i.next();
//			System.out.println("key ***"+thisentry.getKey() +" value: " + thisentry.getValue());
//		}
			 return mp;
	}
		
		
//	}
	
	private static String getCurrentSystemTimestampOfVM() {
		
		Calendar cal = Calendar.getInstance();
		final long HOUR = 3600*1000;
		cal.setTime(new Date(new Date().getTime() + 7 * HOUR));
		cal.add(Calendar.MINUTE, -2);
		Date dateBefore2Min = cal.getTime();
		
		String currentTimestamp = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateBefore2Min);
		//new Date(new Date().getTime() + 7 * HOUR);
		System.out.println("Current timestamp ***************************"+currentTimestamp);
		return currentTimestamp;
		
		
	}
	
	
}
