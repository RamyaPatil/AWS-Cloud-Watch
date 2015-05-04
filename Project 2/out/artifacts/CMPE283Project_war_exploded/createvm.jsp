<%@ page import="cmpe283Project.CloudManager" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.sql.*" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/10/2015
  Time: 9:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Create VM</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
</head>
<body background="images/backgroundPic.jpg">
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
                    <h4>Created VM?</h4>
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <%
                                String vmName1 = request.getParameter("vmName");
                                String vmName2 = request.getParameter("vmName1");
                                String disksize = request.getParameter("diskSize");
                                String selectos = request.getParameter("selectOS");
                                String ramsize = request.getParameter("ramSize");
                                String ostype = request.getParameter("ostype");
                                String userName = session.getAttribute("userName").toString();
                                String email = "";
                                boolean isCreated = false;
                                Connection con;
                                PreparedStatement ps;
                                ResultSet rs = null;
                                String driverName = "com.mysql.jdbc.Driver";
                                String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
                                String user = "clouduser";
                                String dbpsw = "clouduser";
                                String sql = "insert into vm_users values(?,?)";
                                String sql1 = "insert into alarms values(?,?,?,?,?,?,?,?,?,?)";
                                String sql2 = "select * from users where userName=?";
                                if(StringUtils.isNullOrEmpty(vmName2) && disksize.equalsIgnoreCase("noSel") &&
                                        ramsize.equalsIgnoreCase("noSel") && ostype.equalsIgnoreCase("noSel")) {
                                    if(!(StringUtils.isNullOrEmpty(vmName1)) && !(selectos.equalsIgnoreCase("noSel"))) {
                                        if(selectos.equalsIgnoreCase("winOS")) {
                                            vmName1 = vmName1 + "-Win";
                                        }
                                        else {
                                            vmName1 = vmName1 + "-Ubu";
                                        }
                                        try {
                                            isCreated = CloudManager.myVMCreation(vmName1);
                                        }
                                        catch(Exception sqe) {
                                            response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                                        }
                                    }
                                    else {
                                        response.sendRedirect("error.jsp?error=Give all details before clicking on Create VM");
                                    }
                                }
                                else {
                                    if(!(StringUtils.isNullOrEmpty(vmName2)) && !(disksize.equalsIgnoreCase("noSel")) &&
                                            !(ramsize.equalsIgnoreCase("noSel")) && !(ostype.equalsIgnoreCase("noSel"))) {
                                        long tempDisk = Long.parseLong(disksize);
                                        long ramDisk = Long.parseLong(ramsize);
                                        try {
                                            isCreated = CloudManager.myScratchVMCreation(vmName2,tempDisk,ramDisk);
                                        }
                                        catch(Exception sqe) {
                                            response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                                        }
                                    }
                                    else {
                                       response.sendRedirect("error.jsp?error=Give all details before clicking on Create VM");
                                    }
                                }
                                if(isCreated) {
                                    out.print("<label class=\"col-lg-2 control-label\" id=\"errorLabel\">VM Created</label>");
                                }
                                else {
                                    out.print("<label class=\"col-lg-2 control-label\" id=\"errorLabel\">VM Not Created</label>");
                                }
                                if(isCreated) {
                                    try {
                                        Class.forName(driverName);
                                        con = DriverManager.getConnection(url, user, dbpsw);
                                        //Getting emailid from users table
                                        ps = con.prepareStatement(sql2);
                                        ps.setString(1, userName);
                                        rs = ps.executeQuery();
                                        while(rs.next()) {
                                            email = rs.getString("email");
                                        }
                                        rs.close();
                                        ps.close();

                                        //Inserting to alarms table
                                        ps = con.prepareStatement(sql1);
                                        if(StringUtils.isNullOrEmpty(vmName1)) {
                                            ps.setString(1, vmName2);
                                        }
                                        else {
                                            ps.setString(1, vmName1);
                                        }
                                        ps.setString(2, userName);
                                        ps.setString(3, email);
                                        ps.setInt(4, -1);
                                        ps.setInt(5, -1);
                                        ps.setInt(6, -1);
                                        ps.setInt(7, -1);
                                        ps.setInt(8, -1);
                                        ps.setInt(9, 1);
                                        ps.setString(10, "false");
                                        ps.executeUpdate();
                                        ps.close();

                                        //Inserting to vm_users table
                                        ps = con.prepareStatement(sql);
                                        ps.setString(1, userName);
                                        if(isCreated) {
                                            if(StringUtils.isNullOrEmpty(vmName1)) {
                                                ps.setString(2, vmName2);
                                            }
                                            else {
                                                ps.setString(2, vmName1);
                                            }
                                        }
                                        ps.executeUpdate();
                                        ps.close();
                                    }
                                    catch(Exception sqe)
                                    {
                                        response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                                    }
                                }
                            %>
                        </div>
                    </form>
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
