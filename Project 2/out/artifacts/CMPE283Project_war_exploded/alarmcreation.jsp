<%@ page import="com.mysql.jdbc.StringUtils" %>
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
    int noOfUpdates;

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
    String user = "clouduser";
    String dbpsw = "clouduser";

    int cpuUsage = -1;
    int memUsage = -1;
    int diskRead = -1;
    int diskWrite = -1;
    int netUsage = -1;
    int period = 1;
    String vmname = request.getParameter("vmName");
    String usernm = session.getAttribute("userName").toString();
    if(!(StringUtils.isNullOrEmpty(request.getParameter("cpuUsage"))) && !(request.getParameter("cpuUsage").equalsIgnoreCase("0"))) {
        cpuUsage = Integer.parseInt(request.getParameter("cpuUsage"));
    }
    if(!(StringUtils.isNullOrEmpty(request.getParameter("memUsage"))) && !(request.getParameter("memUsage").equalsIgnoreCase("0"))) {
        memUsage = Integer.parseInt(request.getParameter("memUsage"));
    }
    if(!(StringUtils.isNullOrEmpty(request.getParameter("diskRead"))) && !(request.getParameter("diskRead").equalsIgnoreCase("0"))) {
        diskRead = Integer.parseInt(request.getParameter("diskRead"));
    }
    if(!(StringUtils.isNullOrEmpty(request.getParameter("diskWrite"))) && !(request.getParameter("diskWrite").equalsIgnoreCase("0"))) {
        diskWrite = Integer.parseInt(request.getParameter("diskWrite"));
    }
    if(!(StringUtils.isNullOrEmpty(request.getParameter("netUsage"))) && !(request.getParameter("netUsage").equalsIgnoreCase("0"))) {
        netUsage = Integer.parseInt(request.getParameter("netUsage"));
    }
    if(!(StringUtils.isNullOrEmpty(request.getParameter("period"))) && !(request.getParameter("period").equalsIgnoreCase("0"))) {
        period = Integer.parseInt(request.getParameter("period"));
    }

    String sql = "update alarms set cpuUsage=? , memoryUsage=? , diskRead=? , diskWrite=? , ntwUsage=? , period=? where (vmName=? and userName=?)";
    try {
        Class.forName(driverName);
        con = DriverManager.getConnection(url, user, dbpsw);
        if(!(StringUtils.isNullOrEmpty(vmname))) {
            ps = con.prepareStatement(sql);
            ps.setInt(1, cpuUsage);
            ps.setInt(2, memUsage);
            ps.setInt(3, diskRead);
            ps.setInt(4, diskWrite);
            ps.setInt(5, netUsage);
            ps.setInt(6, period);
            ps.setString(7, vmname);
            ps.setString(8, usernm);
            noOfUpdates = ps.executeUpdate();
            if(noOfUpdates==1)
            {
                response.sendRedirect("createalarm.jsp");
            }
            else
                response.sendRedirect("error.jsp?error=Error during creating alarm");
            ps.close();
        }
        else {
            response.sendRedirect("error.jsp?error=No VM name found in url");
        }
    }
    catch(Exception sqe)
    {
        response.sendRedirect("error.jsp?error=" + sqe.getMessage());
    }

%>
</body>
</html>
