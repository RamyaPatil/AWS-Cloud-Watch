<%@ page import="java.sql.*" %>
<%@ page import="cmpe283Project.CloudManager" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/11/2015
  Time: 1:31 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>List VMs</title>
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
                    <h4>List of VMs</h4>
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <table>
                                <tr>
                                    <th>
                                        <label style='margin-left: 30px'>VM Name</label>
                                    </th>
                                    <th>
                                        <label style='margin-left: 30px'>Power Status</label>
                                    </th>
                                    <th>
                                        <label style='margin-left: 30px'>Action</label>
                                    </th>
                                </tr>
                                <%! String userName;
                                    String vmName;
                                %>
                                <%
                                    Connection con= null;
                                    PreparedStatement ps = null;
                                    ResultSet rs = null;
                                    String tempStatus = "";

                                    String driverName = "com.mysql.jdbc.Driver";
                                    String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
                                    String user = "clouduser";
                                    String dbpsw = "clouduser";

                                    String usrName = request.getParameter("userName");
                                    String powerStats = "";
                                    String sql = "select * from vm_users where userName=?";
                                    try {
                                        Class.forName(driverName);
                                        con = DriverManager.getConnection(url, user, dbpsw);
                                        ps = con.prepareStatement(sql);
                                        ps.setString(1, usrName);
                                        rs = ps.executeQuery();
                                        while(rs.next())
                                        {
                                            int i = 0;
                                            userName = rs.getString("userName");
                                            vmName = rs.getString("vmName");
                                            if(usrName.equals(userName))
                                            {
                                                i++;
                                                powerStats = CloudManager.getPowerStatus(vmName);
                                                if(powerStats != null) {
                                                    if(powerStats.equalsIgnoreCase("poweredOn")) {
                                                        tempStatus = "Power Off";
                                                    }
                                                    else {
                                                        tempStatus = "Power On";
                                                    }
                                %>
                                    <tr>
                                <%
                                                    out.println("<td><label style='margin-left: 30px'>"+ vmName + "</label></td>" +
                                                            "<td><label style='margin-left: 30px'>" + powerStats + "</label></td>");
                                %>
                                        <td>
                                            <a class='btn btn-primary' id='powerBtn<%=i%>' href="changepower.jsp?vmName=<%=vmName%>&do=<%=tempStatus%>" style='margin-left: 30px;width: 105px'><%=tempStatus%></a>
                                        </td>
                                    </tr>
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
                            </table>
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
