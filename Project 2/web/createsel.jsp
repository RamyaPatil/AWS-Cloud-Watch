<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 4/11/2015
  Time: 12:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Selection</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <script type="text/javascript">
        function setDisplay() {
            if(document.getElementById("template").checked) {
                document.getElementById("vmname1").value = "";
                document.getElementById("disksize").value = "noSel";
                document.getElementById("ramsize").value = "noSel";
                document.getElementById("osType").value = "noSel";
                document.getElementById("scratchSel").style.display = "none";
                document.getElementById("tempSel").style.display = "block";
            }
            else if(document.getElementById("scratch").checked) {
                document.getElementById("vmname").value = "";
                document.getElementById("selOS").value = "noSel";
                document.getElementById("tempSel").style.display = "none";
                document.getElementById("scratchSel").style.display = "block";
            }
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
                    <h4>How do you want to create?</h4>
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form" action="createvm.jsp">
                        <div class="col-md-4">
                            <input type="radio" name="groupSelect" value="From Template" required id="template" onclick="setDisplay()"> From Template
                        </div>
                        <div class="col-md-4">
                            <input type="radio" name="groupSelect" value="From Scratch" required id="scratch" onclick="setDisplay()"> From Scratch
                        </div>
                        </br>
                        </br>
                        <div id="tempSel" style="display: none">
                            <div class="form-group">
                                <label for="vmname" class="col-lg-2 control-label">VM Name</label>
                                <div class="col-md-8">
                                    <input type="text" class="form-control" id="vmname" name="vmName" placeholder="">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="selOS" class="col-lg-2 control-label">Select OS</label>
                                <div class="col-md-8">
                                    <select class="form-control" id="selOS" name="selectOS">
                                        <option value="noSel">-Select-</option>
                                        <option value="winOS">Windows OS</option>
                                        <option value="linuxOS">Linux OS</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div id="scratchSel" style="display: none">
                            <div class="form-group">
                                <label for="vmname1" class="col-lg-2 control-label">VM Name</label>
                                <div class="col-md-8">
                                    <input type="text" class="form-control" id="vmname1" name="vmName1" placeholder="">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="disksize" class="col-lg-2 control-label">Disk Size in KB</label>
                                <div class="col-md-8">
                                    <select class="form-control" id="disksize" name="diskSize">
                                        <option value="noSel">-Select-</option>
                                        <option value="5000000">5000000</option>
                                        <option value="7500000">7500000</option>
                                        <option value="10000000">10000000</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="ramsize" class="col-lg-2 control-label">Memory Size(RAM) in MB</label>
                                <div class="col-md-8">
                                    <select class="form-control" id="ramsize" name="ramSize">
                                        <option value="noSel">-Select-</option>
                                        <option value="512">512</option>
                                        <option value="1024">1024</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="osType" class="col-lg-2 control-label">Select OS</label>
                                <div class="col-md-8">
                                    <select class="form-control" id="osType" name="ostype">
                                        <option value="noSel">-Select-</option>
                                        <option value="winOS">Windows OS</option>
                                        <option value="linuxOS">Linux OS</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-3">
                                <button type="submit" class="btn btn-primary">Create</button>
                            </div>
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
