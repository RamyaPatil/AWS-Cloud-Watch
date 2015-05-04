<%@ page import="cmpe283Project.CloudManager" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/10/2015
  Time: 5:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Welcome</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <script type="text/javascript">
        function sendSession() {
            window.location.href = "listvms.jsp?userName=<%=session.getAttribute("userName")%>";
        }
    </script>
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
                    <h4>Welcome</h4>
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label class="col-lg-2 control-label" style="width:200px">Create a VM</label>
                            <div class="col-md-4">
                                <a href="createsel.jsp" class="btn btn-primary" style="width: 200px">Create VM</a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-lg-2 control-label" style="width:200px">List all VMs</label>
                            <div class="col-md-4">
                                <a class="btn btn-primary" onclick="sendSession()" style="width: 200px">List VMs</a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-lg-2 control-label" style="width:200px">Performance Statistics</label>
                            <div class="col-md-4">
                                <a href="perfstats.jsp" class="btn btn-primary" style="width: 200px">Performance Statistics</a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-lg-2 control-label" style="width:200px">Private Cloud Statistics</label>
                            <div class="col-md-4">
                                <a href="cloudwatch.jsp" class="btn btn-primary" style="width: 200px">Cloud Watch</a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-lg-2 control-label" style="width:200px">Alarm Management</label>
                            <div class="col-md-4">
                                <a href="createalarm.jsp" class="btn btn-primary" style="width: 200px">Alarm Management</a>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="panel-footer clearfix">
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
