<%@ page import="com.mysql.jdbc.StringUtils" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/10/2015
  Time: 1:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Login</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
</head>
<body background="images/backgroundPic.jpg">
</br>
</br>
<%
    if(session.getAttribute("userName") != null) {
        session.removeAttribute("userName");
    }
%>
<div class="container">
    <div class="row vcenter">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Login</h4>
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form" action="home.jsp">
                        <div class="form-group">
                            <label for="username" class="col-lg-2 control-label">Username</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" id="username" name="userName" placeholder="" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputPassword" class="col-lg-2 control-label">Password</label>
                            <div class="col-md-4">
                                <input type="password" class="form-control" id="inputPassword" name="passWord" placeholder="" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-3">
                                <button type="submit" class="btn btn-primary">Log In</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="panel-footer clearfix">
                    <div class="pull-right">
                        <a href="signup.jsp" class="btn btn-primary">Sign Up?</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
</body>
</html>
