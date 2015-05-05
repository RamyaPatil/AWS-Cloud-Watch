<%@ page import="java.sql.*"%>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 5/1/2015
  Time: 6:45 PM
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <title>Cloud Watch</title>
</head>
<body background="images/backgroundPic.jpg">
    <script type="text/javascript">
        var vmName = "T08-VM01-Lin";
         var part1 = "http://54.183.233.221:5601/#/visualize/edit/Team08?embed&_g=(refreshInterval:(display:'5%20seconds',section:1,value:5000),time:(from:now-30m,mode:relative,to:now))&_a=(filters:!(),linked:!f,query:(query_string:(analyze_wildcard:!t,query:'*')),vis:(aggs:!((id:'1',params:(field:";
        var metricName = "cpu";
        var part2="),schema:metric,type:avg),(id:'2',params:(extended_bounds:(),field:'@timestamp',interval:second,min_doc_count:1),schema:segment,type:date_histogram),(id:'3',params:(filters:!((input:(query:(query_string:(analyze_wildcard:!t,query:'vmname:%22";
        var part3 = "%22')))))),schema:group,type:filters)),listeners:(),params:(addLegend:!t,addTooltip:!t,defaultYExtents:!f,shareYAxis:!t),type:line))";
        
        /* var part1 ="http://54.183.233.221:5601/#/dashboard/Team08?embed&_g=(refreshInterval:(display:'5%20seconds',section:1,value:5000),time:(from:now-30m,mode:quick,to:now))&_a=(filters:!(),panels:!((col:1,id:test-Visualization,row:1,size_x:11,size_y:2,type:visualization)),query:(query_string:(analyze_wildcard:!t,query:'vmname:%22";
        var part3 ="%22')),title:'New%20Dashboard')&_g=()"; */
        var iFrameSource;
        function populate(){
            vmName = document.getElementById('vmname_select').value;
            metricName = document.getElementById("metricName").value;		
             iFrameSource = part1 + metricName + part2 + vmName + part3; 
            /* iFrameSource = part1 + vmName + part3; */
            document.getElementById("iFrameContent").src = iFrameSource;
            document.getElementById("iFrameContent").width=1128;
            document.getElementById("iFrameContent").height = 600;
            reloadGraph();
        }
        function reloadGraph(){
            document.getElementById('iFrameContent').src=document.getElementById('iFrameContent').src;
        }
    </script>
</br>
</br>
<%
    if(session.getAttribute("userName") == null) {
        response.sendRedirect("error.jsp?error=No session.. You must login to see the page");
    }
%>
    <div class="container">
        <div class="row vcenter">
            <div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4>Cloud Statistics</h4>
                    </div>
                    <div class="form-group" align="center">
                        <form class="form-horizontal" role="form">
                            <table>
                                <h5> Select VM</h5>
                                <tr>
                                    <td align="center" width="180px">
                                        <select id="vmname_select" onchange="populate()">

                                    <%! String userName;
                                        String vmName;
                                    %>
                                    <%
                                        Connection con= null;
                                        PreparedStatement ps = null;
                                        ResultSet rs = null;

                                        String driverName = "com.mysql.jdbc.Driver";
                                        String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
                                        String user = "clouduser";
                                        String dbpsw = "clouduser";

                                        String usrName = session.getAttribute("userName").toString();
                                        String sql = "select * from vm_users where userName=?";
                                        try {
                                            Class.forName(driverName);
                                            con = DriverManager.getConnection(url, user, dbpsw);
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usrName);
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                                userName = rs.getString("userName");
                                                vmName = rs.getString("vmName");%>
                                    <option value=" <%=rs.getString("vmName")%> "><%= rs.getString("vmName")%></option>

                                    <% }
                                        rs.close();
                                        ps.close();
                                    }
                                    catch(Exception sqe)
                                    {
                                        response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                                    }
                                    %>
                                        </select>
                                    </td>
                                    <td align="center" width="150px">
                                        <select id="metricName" onchange="populate()">
                                            <option value="cpu">CPU Utilization</option>
                                            <option value="mem">Memory Utilization</option>
                                            <option value="diskwrite">Disk Write Utilization</option>
                                            <option value="diskread">Disk Read Utilization</option>
                                            <option value="net">Network Utilization</option>
                                        </select>
                                    </td>
                                    <td align="center" width="180px">
                                        <button type="button" onclick="reloadGraph()">Refresh</button>
                                    </td>
                                </tr>
                            </table>
                        </form>
                        <br>
                        <!-- <iframe id ="iFrameContent" src="http://54.183.233.221:5601/#/visualize/edit/New-Visualization?embed&_a=(filters:!(),linked:!f,query:(query_string:(analyze_wildcard:!t,query:'*')),vis:(aggs:!((id:'1',params:(field:cpu),schema:metric,type:avg),(id:'2',params:(extended_bounds:(),field:'@timestamp',interval:second,min_doc_count:1),schema:segment,type:date_histogram),(id:'3',params:(filters:!((input:(query:(query_string:(analyze_wildcard:!t,query:'vmname:%22T08-VM01-Lin%22'))))),row:!t),schema:split,type:filters)),listeners:(),params:(addLegend:!t,addTooltip:!t,defaultYExtents:!f,shareYAxis:!t),type:line))&_g=()" width="1000px" height="750px"> -->
                            <!-- <iframe id ="iFrameContent" src="http://54.183.233.221:5601/#/dashboard/Team08?embed&_g=(refreshInterval:(display:'5%20seconds',section:1,value:5000),time:(from:now-30m,mode:quick,to:now))&_a=(filters:!(),panels:!((col:1,id:test-Visualization,row:1,size_x:11,size_y:2,type:visualization)),query:(query_string:(analyze_wildcard:!t,query:'vmname:%22T08-VM01-Lin%22')),title:'New%20Dashboard')&_g=()" width="1000px" height="750px"> -->
                            <iframe id ="iFrameContent" src="http://54.183.233.221:5601/#/visualize/edit/Team08?embed&_g=(refreshInterval:(display:'5%20seconds',section:1,value:5000),time:(from:now-30m,mode:relative,to:now))&_a=(filters:!(),linked:!f,query:(query_string:(analyze_wildcard:!t,query:'*')),vis:(aggs:!((id:'1',params:(field:cpu),schema:metric,type:avg),(id:'2',params:(extended_bounds:(),field:'@timestamp',interval:second,min_doc_count:1),schema:segment,type:date_histogram),(id:'3',params:(filters:!((input:(query:(query_string:(analyze_wildcard:!t,query:'vmname:%22T08-VM01-Lin%22')))))),schema:group,type:filters)),listeners:(),params:(addLegend:!t,addTooltip:!t,defaultYExtents:!f,shareYAxis:!t),type:line))" width="1000px" height="750px">
                            <p>Your browser does not support iframes.</p>
                        </iframe>
                    </div>
                    <div class="panel-footer clearfix">
                        <div class="pull-left">
                            <a href="welcome.jsp" class="btn btn-primary">Go Back to Home?</a>
                        </div>
                        <div class="pull-right">
                            <a href="logout.jsp" class="btn btn-primary">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>