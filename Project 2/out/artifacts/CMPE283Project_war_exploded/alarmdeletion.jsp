<%@ page import="java.sql.*" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 5/3/2015
  Time: 4:52 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Alarm Deletion</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
</head>
<body background="images/backgroundPic.jpg">
<%
    Connection con= null;
    PreparedStatement ps = null;

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
    String user = "clouduser";
    String dbpsw = "clouduser";

    String usernm = session.getAttribute("userName").toString();
    String vmname = request.getParameter("vmName");
    String sql1 = "update alarms set cpuUsage=? , memoryUsage=? , diskRead=? , diskWrite=? , ntwUsage=? , period=? where userName=? and vmName=?";
    try {
        Class.forName(driverName);
        con = DriverManager.getConnection(url, user, dbpsw);
        ps = con.prepareStatement(sql1);
        ps.setInt(1, -1);
        ps.setInt(2, -1);
        ps.setInt(3, -1);
        ps.setInt(4, -1);
        ps.setInt(5, -1);
        ps.setInt(6, 1);
        ps.setString(7, usernm);
        ps.setString(8, vmname);
        int result = ps.executeUpdate();
        if(result == 1) {
            response.sendRedirect("createalarm.jsp");
        }
        ps.close();
    }
    catch(Exception sqe) {
        response.sendRedirect("error.jsp?error=" + sqe.getMessage());
    }
%>
</body>
</html>
