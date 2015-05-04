<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/10/2015
  Time: 1:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
</head>
<body background="images/backgroundPic.jpg">
<%! String userName;
    String passWord;
%>
<%
    URL location = this.getClass().getProtectionDomain().getCodeSource().getLocation();
    System.out.println(location.getFile());
    Connection con= null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int noOfInserts;
    boolean userNamePresent = false;

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
    String user = "clouduser";
    String dbpsw = "clouduser";


    String usernm = request.getParameter("userName");
    String passwd = request.getParameter("passWord");
    String myemail = request.getParameter("email");
    String fullname = request.getParameter("myName");

    if(StringUtils.isNullOrEmpty(fullname) && StringUtils.isNullOrEmpty(myemail)) {
        if(!(StringUtils.isNullOrEmpty(usernm)) && !(StringUtils.isNullOrEmpty(passwd)))
        {
            String sql1 = "select * from users where userName=? and passWord=?";
            try {
                Class.forName(driverName);
                con = DriverManager.getConnection(url, user, dbpsw);
                ps = con.prepareStatement(sql1);
                ps.setString(1, usernm);
                ps.setString(2, passwd);
                rs = ps.executeQuery();
                while(rs.next())
                {
                    userName = rs.getString("userName");
                    passWord = rs.getString("passWord");
                    if(usernm.equals(userName) && passwd.equals(passWord))
                    {
                        session.setAttribute("userName",userName);
                        userNamePresent = true;
                        response.sendRedirect("welcome.jsp");
                    }
                }
                if(!userNamePresent) {
                    response.sendRedirect("error.jsp?error=Error during login");
                }
                rs.close();
                ps.close();
            }
            catch(Exception sqe)
            {
                response.sendRedirect("error.jsp?error=" + sqe.getMessage());
            }
        }
        else
        {
%>
            <p style="color:red">Error In Login</p>
<%
            response.sendRedirect("index.jsp");
        }
    }
    else {
                String sql3 = "select * from users where userName=?";
                String sql2 = "insert into users values(?,?,?,?)";
                if(!(StringUtils.isNullOrEmpty(usernm)) && !(StringUtils.isNullOrEmpty(passwd)) &&
                        !(StringUtils.isNullOrEmpty(myemail)) && !(StringUtils.isNullOrEmpty(fullname))) {
                    try {
                        Class.forName(driverName);
                        con = DriverManager.getConnection(url, user, dbpsw);
                        ps = con.prepareStatement(sql3);
                        ps.setString(1, usernm);
                        rs = ps.executeQuery();
                        while(rs.next()) {
                            userName = rs.getString("userName");
                            if(usernm.equals(userName)) {
                                userNamePresent = true;
                                response.sendRedirect("error.jsp?error=Duplicate registration found");
                            }
                        }
                        rs.close();
                        ps.close();
                        if(!(userNamePresent)) {
                            ps = con.prepareStatement(sql2);
                            ps.setString(1, fullname);
                            ps.setString(2, usernm);
                            ps.setString(3, myemail);
                            ps.setString(4, passwd);
                            noOfInserts = ps.executeUpdate();
                            if(noOfInserts==1)
                            {
                                session.setAttribute("userName",usernm);
                                response.sendRedirect("welcome.jsp");
                            }
                            else
                                response.sendRedirect("error.jsp?error=Error during registration");
                            ps.close();
                        }
                    }
                    catch(Exception sqe)
                    {
                        response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                    }
                }
                else {
%>
            <p style="color:red">Error In Registration</p>
<%
                }
    }
%>
</body>
</html>
