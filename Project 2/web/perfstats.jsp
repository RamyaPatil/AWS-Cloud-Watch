<%@ page import="cmpe283Project.CloudManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="cmpe283Project.PStatistics" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/11/2015
  Time: 1:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Performance Statistics</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
    <script src="https://www.google.com/jsapi"></script>
    <script src="js/jquery.csv-0.71.js"></script>
    <script>
        google.load("visualization", "1", {packages:['corechart']});
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            // grab the CSV
            var data = google.visualization.arrayToDataTable([
            ['Virtual Machine', 'Memory-Usuage'],
                <%!
                    String userName;
                    String vmName;
                    String memUsage;
                    int cpuUsage;
                %>
                <%
                    Connection con;
                    PreparedStatement ps;
                    ResultSet rs;

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
                        while(rs.next())
                        {
                            userName = rs.getString("userName");
                            vmName = rs.getString("vmName");
                            if(usrName.equals(userName))
                            {
                                memUsage = PStatistics.getMemoryUsage(vmName);
                                //String memoryUsage = PStatistics.getMaxMemoryUsage(vmName);
                                int i = Integer.parseInt(memUsage.split(":")[0]);
                                String ip = memUsage.split(":")[1];
                                if(!(rs.isLast())) {
                                    %>
                ['<%=vmName%>'+':'+'<%=ip%>',<%=i%>],
            <%
                                }
                                else {
                                %>
                    ['<%=vmName%>'+':'+'<%=ip%>',<%=i%>]
                <%
                                 }
                            }
                        }
                        rs.close();
                        ps.close();
                    }
                    catch(Exception sqe)
                    {
                        response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                    }
                %>

            ]);
            var data1 = google.visualization.arrayToDataTable([
                ['Virtual Machine', 'CPU-Usuage'],
                    <%
                        try {
                            Class.forName(driverName);
                            con = DriverManager.getConnection(url, user, dbpsw);
                            ps = con.prepareStatement(sql);
                            ps.setString(1, usrName);
                            rs = ps.executeQuery();
                            while(rs.next())
                            {
                                userName = rs.getString("userName");
                                vmName = rs.getString("vmName");
                                if(usrName.equals(userName))
                                {
                                    cpuUsage = Integer.parseInt(PStatistics.getCPUUsage(vmName));
                                    if(!(rs.isLast())) {
                                        %>
                    ['<%=vmName%>',<%=cpuUsage%>],
                    <%
                                        }
                                        else {
                                        %>
                    ['<%=vmName%>',<%=cpuUsage%>]
                    <%
                                     }
                                }
                            }
                            rs.close();
                            ps.close();
                        }
                        catch(Exception sqe) {
                            response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                         }
                    %>
                    ]);
            var options = {
                title: 'Memory-Usage',
                height:230,
                width:500,
                is3D:true,
                pieHole: 0.4,
                sliceVisibilityThreshold: 0,
                'backgroundColor':{'fill':'none'}
            };
            var options1 = {
                title: "CPU-Usage",
                height:230,
                width:500,
                is3D:true,
                bars: 'horizontal',
                'backgroundColor':{'fill':'none'}
            }

            var chart = new google.visualization.PieChart(document.getElementById('Chart_m'));
            var chart1 = new google.visualization.BarChart(document.getElementById('Chart_c'));

            chart.draw(data, options);
            chart1.draw(data1, options1);
        }
    </script>
</head>
<body background="images/backgroundPic.jpg">
<style type="text/css">
    #Chart_c,#Chart_m {
        height:230px;
        width:500px;
        position: center;
        margin: 50px 10px 0 125px;
        border: 2px ridge black;
        background-color: rgba(255,255,255,0.5);
    }

    #main {
        background-repeat: no-repeat;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
        height: 650px;
        width: 760px;
        border:2px solid #dddddd;
        background-color: rgba(245, 245, 245, 1);
    }

    #hold {
        width: 750px;
        height: 680px;
        margin-left: -20px;
        margin-top: -20px;
    }
</style>
</br>
</br>
<%
    if(session.getAttribute("userName") == null) {
        response.sendRedirect("error.jsp?error=No session.. You must login to see the page");
    }
%>
<div class="container">
    <div class="row vcenter">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Performance Statistics</h4>
                </div>
                <div class="panel-body">
                    <div id="hold">
                        <div id="main">
                            <div id="Chart_c"></div>
                            <div id="Chart_m"></div>
                        </div>
                    </div>
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
