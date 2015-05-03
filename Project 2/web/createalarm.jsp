<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Create Alarm</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
</head>
<script type="text/javascript">
var limitFlag=false,thresholdFlag=false,nameFlag=false;
function populate(){
    var thresholdSpan = document.getElementById('limit');
    var threshold = document.getElementById('thresholdVal').value;
    if(threshold!=0){
        thresholdSpan.innerHTML = threshold;
        thresholdFlag=true;
        if(thresholdFlag && limitFlag && nameFlag) {
            document.getElementById('createAlarmBtn').disabled = false;
        }
    }
    else {
        thresholdFlag=false;
        document.getElementById('createAlarmBtn').disabled = true;
    }
}
function sendValue() {
    var periodSpan = document.getElementById('time');
    var period = document.getElementById('periodVal').value;
    if(period!=0){
        periodSpan.innerHTML = period;
        limitFlag=true;
        if(thresholdFlag && limitFlag && nameFlag) {
            document.getElementById('createAlarmBtn').disabled = false;
        }
    }
    else {
        limitFlag=false;
        document.getElementById('createAlarmBtn').disabled = true;
    }
    checkForm();
}
function populateMetric(){
    var metricSpan = document.getElementById('metrics');
    metricSpan.innerHTML = document.getElementById('metricSel').value;
}
function checkForm(){
    var nameSet = document.getElementById('alarmName').value;
    if(nameSet){
        nameFlag = true;
    }
    else{
        nameFlag = false;
        document.getElementById('createAlarmBtn').disabled = true;
    }
    if(thresholdFlag && limitFlag && nameFlag){
        document.getElementById('createAlarmBtn').disabled = false;
    }
}
</script>
<body background="images/backgroundPic.jpg">
<br>
<br>
<div class="container">
    <div class="row vcenter">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Create Alarm</h4>
                </div>
                <div class="panel-body">
                    <button type="button" data-toggle="modal" data-target="#myModal" id="createAlarm" class="btn btn-primary" style="margin-left:100px">Create Alarm</button>
                    <button type="button" data-toggle="modal" data-target="#myOtherModal" id="deleteAlarm" class="btn btn-primary" style="margin-left:200px;display:none">Delete Alarm</button>
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h3 class="modal-title"><i>Create Alarm</i></h3>
                                </div>
                                <div class="modal-body">
                                    <h5>Alarm Threshold</h5>
                                    <hr>
                                    <p style="font-size:15px;">Provide the details and threshold for your alarm.</p>
                                    <form name="theform">
                                    <table>
                                        <tr><td style="text-align:right;font-size:14px;">Name :  &nbsp;</td><td><input type = "text" id="alarmName" name="alarmName" onchange="checkForm();" style="font-size:14px;"/></td></tr>
                                        <tr><td style="text-align:right;font-size:14px;">Description :  &nbsp;</td><td><input type = "text" id="alarmDesc" name="alarmDesc" style="font-size:14px;"/></td></tr>
                                    </table>
                                    <hr>
                                    <table> 
                                        <tr><td style="text-align:right;font-size:14px;">VM Name : &nbsp;</td>
                                        <td><select required>
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
            
                                            %>
                                        <option value="<%=vmName%>"><%=vmName%></option>
                                        <%
                                                }
                                            rs.close();
                                            ps.close();
                                            }
                                            catch(Exception sqe)
                                            {
                                                out.println(sqe);
                                            }
                                        %>
                                            </select>
                                        </td></tr>
                                        <tr><td style="text-align:right;font-size:14px;">Whenever : &nbsp;</td>
                                        <td style="font-size:14px;"><select id="metricSel" onchange="populateMetric();" required>
                                            <option value="CPU Usage">CPU Usage</option>
                                            <option value="Memory Usage">Memory Usage</option>
                                            <option value="Disk Usage">Disk Usage</option>
                                            <option value="Network Usage">Network Usage</option>
                                            <option value="IO Usage">IO Usage</option>
                                        </select></td></tr>
                                        <tr><td style="text-align:right;font-size:14px;">is > : &nbsp;</td>
                                        <td>
                                            <input type="range" id="thresholdVal" name="thresholdVal" min="0" max="10" step="0.05" onchange="populate();">
                                        </td></tr>
                                        <tr><td style="text-align:right;font-size:14px;">
                                            for : &nbsp;</td><td style="font-size:14px;">
                                            <input type="text" id="periodVal" name="period" value="0" size="2" style="text-align: center;" onchange="sendValue();" style="font-size:14px;" required>
                                            Minutes
                                        </td></tr>
                                    </table>
                                    </form>
                                    <hr>
                                    <p style="font-size:15px;"><i>This alarm will be trigger when the <span id="metrics">CPU Usage</span> value goes above <span id="limit">0</span> for a duration of <span id="time">0</span> minutes.</i></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    <button type="button" class="btn btn-primary" id="createAlarmBtn" disabled>Create Alarm</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    </br>
                    </br>
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
