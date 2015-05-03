<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="cmpe283Project.PStatistics" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 5/2/2015
  Time: 1:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Alarm Creation</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
</head>
<body background="images/backgroundPic.jpg">
<%
    Connection con= null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int noOfInserts;
    boolean alarmSet = false;

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
    String user = "clouduser";
    String dbpsw = "clouduser";

    String usernm = session.getAttribute("userName").toString();
    String email = "";
    String vmname = request.getParameter("vmName");
    String alarmname = request.getParameter("alarmName");
    String alarmdescr = request.getParameter("alarmDescr");
    String metric = request.getParameter("metric");
    String metricComparator = request.getParameter("metricComparator");
    String period = request.getParameter("period") + " Minutes";
    String maxmemusage = PStatistics.getMaxMemoryUsage(vmname);
    String maxcpuusage = PStatistics.getMaxCPUUsage(vmname);
    System.out.println(maxmemusage);
    System.out.println(maxcpuusage);

    String sql1 = "select * from users where userName=?";
    String sql2 = "insert into alarms values(?,?,?,?,?,?,?,?,?)";
    String sql3 = "select * from alarms where userName=? and vmName=? and metricAttribute=?";
    try {
        Class.forName(driverName);
        con = DriverManager.getConnection(url, user, dbpsw);
        ps = con.prepareStatement(sql1);
        ps.setString(1, usernm);
        rs = ps.executeQuery();
        while(rs.next()) {
            email = rs.getString("email");
        }
        rs.close();
        ps.close();
        if(!(StringUtils.isNullOrEmpty("email"))) {
            ps = con.prepareStatement(sql3);
            ps.setString(1, usernm);
            ps.setString(2, vmname);
            ps.setString(3, metric);
            rs = ps.executeQuery();
            while(rs.next()) {
                if(!(StringUtils.isNullOrEmpty(rs.getString("metricAttribute"))) && rs.getString("metricAttribute").equalsIgnoreCase(metric) &&
                        !(StringUtils.isNullOrEmpty(rs.getString("vmName"))) && rs.getString("vmName").equalsIgnoreCase(vmname)) {
                    alarmSet = true;
                    response.sendRedirect("error.jsp?error=Duplicate metric found for the same VM");
                }
            }
            rs.close();
            ps.close();
            if(!alarmSet) {
                ps = con.prepareStatement(sql2);
                ps.setString(1, usernm);
                ps.setString(2, vmname);
                ps.setString(3, email);
                ps.setString(4, alarmname);
                ps.setString(5, alarmdescr);
                ps.setString(6, metric);
                ps.setString(7, metricComparator);
                ps.setString(8, period);
                ps.setString(9, "100");
                noOfInserts = ps.executeUpdate();
                if(noOfInserts==1)
                {
                    response.sendRedirect("createalarm.jsp");
                }
                else
                    response.sendRedirect("error.jsp?error=Error during creating alarm");
                ps.close();
            }
        }
    }
    catch(Exception sqe)
    {
        response.sendRedirect("error.jsp?" + sqe);
    }

%>
</body>
</html>
