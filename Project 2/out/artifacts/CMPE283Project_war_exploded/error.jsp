<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/11/2015
  Time: 3:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Error Page</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
</head>
<body background="images/backgroundPic.jpg">
</br>
</br>
<div class="container">
    <div class="row vcenter">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Error Page</h4>
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label style='margin-left: 100px'>Oops!!! There is an error.</label>
                            </br>
                            </br>
                            <label style='margin-left: 100px'>Error Details: <%=request.getParameter("error")%></label>
                        </div>
                    </form>
                </div>
                <div class="panel-footer clearfix">
                    <div class="pull-right">
                        <a href="index.jsp" class="btn btn-primary">Redirect to Login?</a>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
