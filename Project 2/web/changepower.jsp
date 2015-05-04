<%@ page import="cmpe283Project.PStatistics" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 5/1/2015
  Time: 4:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Change Power Status</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
</head>
<body background="images/backgroundPic.jpg">
</br>
</br>
<%
    String vmName = request.getParameter("vmName");
    String powerStat = request.getParameter("do");

    if(powerStat.equalsIgnoreCase("Power Off")) {
        PStatistics.powerOffVM(vmName);
    }
    else {
PStatistics.powerOnVM(vmName);
}
response.sendRedirect("listvms.jsp?userName="+session.getAttribute("userName"));
%>
</body>
</html>
