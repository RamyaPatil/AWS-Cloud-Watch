<%@ page import="cmpe283Project.PStatistics" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 5/1/2015
  Time: 9:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <title>Alarm Management</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        var cpuFlag=true,memFlag=true,ntwFlag=true,diskWriteFlag=true,diskReadFlag=true;
        function cpuSetVisibility(){
            if(document.getElementById('attr1').checked){
                document.getElementById('cpuThreshold').style.visibility="visible";
                document.getElementById('cpuThresholdVal').style.visibility="visible";
                if(document.getElementById('cpuThreshold').value == 0){
                    cpuFlag=false;
                } else{
                    cpuFlag=true;
                }
                validateForm();
            }
            else {
                document.getElementById('cpuThreshold').style.visibility="hidden";
                document.getElementById('cpuThresholdVal').style.visibility="hidden";
                document.getElementById('cpuThreshold').value = 0;
                document.getElementById('cpuThresholdVal').innerHTML = 0;
                cpuFlag=true;
                validateForm();
            }
        }
        function memSetVisibility(){
            if(document.getElementById('attr2').checked){
                document.getElementById('memThreshold').style.visibility="visible";
                document.getElementById('memThresholdVal').style.visibility="visible";
                if(document.getElementById('memThreshold').value == 0){
                    memFlag=false;
                } else{
                    memFlag=true;
                }
                validateForm();
            }
            else {
                document.getElementById('memThreshold').style.visibility="hidden";
                document.getElementById('memThresholdVal').style.visibility="hidden";
                document.getElementById('memThreshold').value = 0;
                document.getElementById('memThresholdVal').innerHTML = 0;
                memFlag=true;
                validateForm();
            }
        }
        function ntwSetVisibility(){
            if(document.getElementById('attr3').checked){
                document.getElementById("ntwThreshold").style.visibility="visible";
                ntwFlag=false;
                validateForm();
            }
            else {
                document.getElementById("ntwThreshold").style.visibility="hidden";
                document.getElementById('ntwThreshold').value = 0;
                ntwFlag=true;
                validateForm();
            }
        }
        function diskReadSetVisibility(){
            if(document.getElementById('attr4').checked){
                document.getElementById("diskReadThreshold").style.visibility="visible";
                diskReadFlag=false;
                validateForm();
            }
            else {
                document.getElementById("diskReadThreshold").style.visibility="hidden";
                document.getElementById('diskReadThreshold').value = 0;
                diskReadFlag=true;
                validateForm();
            }
        }
        function diskWriteSetVisibility(){
            if(document.getElementById('attr5').checked){
                document.getElementById("diskWriteThreshold").style.visibility="visible";
                diskWriteFlag=false;
                validateForm();
            }
            else {
                document.getElementById("diskWriteThreshold").style.visibility="hidden";
                document.getElementById('diskWriteThreshold').value = 0;
                diskWriteFlag=true;
                validateForm();
            }
        }
        function changecpuSpan(){
            var cpuThesholdValue = document.getElementById('cpuThreshold').value;
            var cpuThresholdSpan = document.getElementById('cpuThresholdVal');
            cpuThresholdSpan.innerHTML = cpuThesholdValue;
            var showCPUUsageSpan = document.getElementById('showCPUUsage');
            showCPUUsageSpan.innerHTML = cpuThesholdValue;
            if(cpuThesholdValue != 0){
                cpuFlag=true;
                if(cpuFlag && memFlag && ntwFlag && diskWriteFlag && diskReadFlag) {
                    document.getElementById('createAlarmBtn').disabled = false;
                }
            }
            else {
                cpuFlag = false;
                document.getElementById('createAlarmBtn').disabled = true;
            }
        }
        function changememSpan(){
            var memThesholdValue = document.getElementById('memThreshold').value;
            var memThresholdSpan = document.getElementById('memThresholdVal');
            memThresholdSpan.innerHTML = memThesholdValue;
            var showMemUsageSpan = document.getElementById('showMemUsage');
            showMemUsageSpan.innerHTML = memThesholdValue;
            if(memThesholdValue != 0){
                memFlag=true;
                if(cpuFlag && memFlag && ntwFlag && diskWriteFlag && diskReadFlag) {
                    document.getElementById('createAlarmBtn').disabled = false;
                }
            }
            else {
                memFlag = false;
                document.getElementById('createAlarmBtn').disabled = true;
            }
        }
        function ntwValValidate(){
            var ntwThesholdValue = document.getElementById('ntwThreshold').value;
            var showNetUsageSpan = document.getElementById('showNetUsage');
            showNetUsageSpan.innerHTML = ntwThesholdValue;
            if(ntwThesholdValue != 0){
                ntwFlag=true;
                if(cpuFlag && memFlag && ntwFlag && diskWriteFlag && diskReadFlag) {
                    document.getElementById('createAlarmBtn').disabled = false;
                }
            }
            else {
                ntwFlag = false;
                document.getElementById('createAlarmBtn').disabled = true;
            }
        }
        function diskReadValidate(){
            var diskReadThesholdValue = document.getElementById('diskReadThreshold').value;
            var showDiskReadSpan = document.getElementById('showDiskRead');
            showDiskReadSpan.innerHTML = diskReadThesholdValue;
            if(diskReadThesholdValue != 0){
                diskReadFlag=true;
                if(cpuFlag && memFlag && ntwFlag && diskWriteFlag && diskReadFlag) {
                    document.getElementById('createAlarmBtn').disabled = false;
                }
            }
            else {
                diskReadFlag = false;
                document.getElementById('createAlarmBtn').disabled = true;
            }
        }
        function diskWriteValidate(){
            var diskWriteThesholdValue = document.getElementById('diskWriteThreshold').value;
            var showDiskWriteSpan = document.getElementById('showDiskWrite');
            showDiskWriteSpan.innerHTML = diskWriteThesholdValue;
            if(diskWriteThesholdValue != 0){
                diskWriteFlag=true;
                if(cpuFlag && memFlag && ntwFlag && diskWriteFlag && diskReadFlag) {
                    document.getElementById('createAlarmBtn').disabled = false;
                }
            }
            else {
                diskReadFlag = false;
                document.getElementById('createAlarmBtn').disabled = true;
            }
            validateForm();
        }
        function periodVal(){
            var periodValue = document.getElementById('period').value;
            var periodSpanContent = document.getElementById('periodSpan');
            periodSpanContent.innerHTML = periodValue;
        }
        function validateForm(){
            if(document.getElementById('attr1').checked || document.getElementById('attr2').checked || document.getElementById('attr3').checked || document.getElementById('attr4').checked ||document.getElementById('attr5').checked ){
                if(cpuFlag && memFlag && ntwFlag && diskWriteFlag && diskReadFlag) {
                    document.getElementById('createAlarmBtn').disabled = false;
                }
                else {
                    document.getElementById('createAlarmBtn').disabled = true;
                }
            } else {
                document.getElementById('createAlarmBtn').disabled = true;
            }
        }
        function createAlarm() {
            window.location.href = "alarmcreation.jsp?vmName=" + document.getElementById("vmNameId").innerHTML +
                    "&cpuUsage=" + document.getElementById('cpuThreshold').value + "&memUsage=" + document.getElementById('memThreshold').value +
                    "&diskRead=" + document.getElementById('diskReadThreshold').value + "&diskWrite=" + document.getElementById('diskWriteThreshold').value +
                    "&netUsage=" + document.getElementById('ntwThreshold').value + "&period=" + document.getElementById('period').value;
        }
        function selectDeletion() {
            var radios = document.getElementsByName('radios');
            for(var i = 0; i < radios.length; i++){
                if(radios[i].checked){
                    var j = i+1;
                    vmName = document.getElementById('vmName'+ j).innerHTML;
                    document.getElementById("vmNameId").innerHTML = vmName;
                    if(document.getElementById('cpuAlrm'+ j).innerHTML != '-1' && document.getElementById('cpuAlrm'+ j).innerHTML != '-') {
                        document.getElementById("cpuThreshold").value = document.getElementById('cpuAlrm'+ j).innerHTML;
                        document.getElementById("cpuThresholdVal").innerHTML = document.getElementById('cpuAlrm'+ j).innerHTML;
                    }
                    if(document.getElementById('memAlrm'+ j).innerHTML != '-1' && document.getElementById('memAlrm'+ j).innerHTML != '-') {
                        document.getElementById("memThreshold").value = document.getElementById('memAlrm'+ j).innerHTML;
                        document.getElementById("memThresholdVal").innerHTML = document.getElementById('memAlrm'+ j).innerHTML;
                    }
                    if(document.getElementById('netAlrm'+ j).innerHTML != '-1' && document.getElementById('netAlrm'+ j).innerHTML != '-') {
                        document.getElementById("ntwThreshold").value = document.getElementById('netAlrm'+ j).innerHTML;
                    }
                    if(document.getElementById('readAlrm'+ j).innerHTML != '-1' && document.getElementById('readAlrm'+ j).innerHTML != '-') {
                        document.getElementById("diskReadThreshold").value = document.getElementById('readAlrm'+ j).innerHTML;
                    }
                    if(document.getElementById('writeAlrm'+ j).innerHTML != '-1' && document.getElementById('writeAlrm'+ j).innerHTML != '-') {
                        document.getElementById("diskWriteThreshold").value = document.getElementById('writeAlrm'+ j).innerHTML;
                    }
                    document.getElementById("period").value = document.getElementById('period'+ j).innerHTML;
                    document.getElementById("periodSpan").innerHTML = document.getElementById('period'+ j).innerHTML;

                    document.getElementById("deleteAlarm").disabled = false;
                    document.getElementById("createAlarm").disabled = false;
                }
            }
        }
        function deleteAlarm() {
            window.location.href = "alarmdeletion.jsp?vmName=" + vmName;
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

    Connection con= null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String usrName = "";

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://cmpe283.cevc26sazqga.us-west-1.rds.amazonaws.com/cmpe283";
    String user = "clouduser";
    String dbpsw = "clouduser";

    if(session.getAttribute("userName") != null) {
        usrName = session.getAttribute("userName").toString();
    }
%>
<div class="container">
    <div class="row vcenter">
        <div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Alarm Management</h4>
                </div>
                <div class="panel-body">
                    <button type="button" data-toggle="modal" data-target="#myModal" id="createAlarm" class="btn btn-primary" style="margin-left:300px" disabled>Create/Modify Alarm</button>
                    <button type="button" data-toggle="modal" data-target="#myOtherModal" id="deleteAlarm" class="btn btn-primary" style="margin-left:200px;" disabled>Delete Alarm</button>
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
                                    <p style="font-size:14px;">VM Name : &nbsp;<label id="vmNameId"></label><br>
                                        Whenever</p>
                                    <form name="theform">
                                        <table>
                                            <tr>
                                                <td><input type="checkbox" id="attr1" name="attr1" value="cpu" onchange="cpuSetVisibility();"></td><td style="font-size:14px;">CPU Usage is > &nbsp;</td><td> : </td>
                                                <td style="text-align:center;font-size:14px;" width="40px"><span id="cpuThresholdVal">0</span></td><td style="visibility:hidden;" colspan=2><input type="range" id="cpuThreshold" name="cpuThreshold" min="0" max="2400"  value="0" step="1" onchange="changecpuSpan()"> MHz</td>
                                            </tr>
                                            <tr>
                                                <td><input type="checkbox" id="attr2" name="attr2" value="mem" onchange="memSetVisibility()"></td><td style="font-size:14px;">Memory Usage is > &nbsp;</td><td> : </td>
                                                <td style="text-align:center;font-size:14px;" width="40px"><span id="memThresholdVal">0</span></td><td style="visibility:hidden;" colspan=2 ><input type="range" id="memThreshold" name="memThreshold" min="0" max="1024"  value="0" step="1" onchange="changememSpan()"> MB</td>
                                            </tr>
                                            <tr>
                                                <td><input type="checkbox" id="attr3" name="attr3" value="ntw" onchange="ntwSetVisibility()"></td><td style="font-size:14px;">Network Usage is > &nbsp;</td><td> : </td>
                                                <td><input type="text" id="ntwThreshold" name="ntwThreshold" value="0" size="2" style="text-align: center;visibility:hidden;" onchange="ntwValValidate()" style="font-size:14px;"> KbPs</td>
                                            </tr>
                                            <tr>
                                                <td><input type="checkbox" id="attr4" name="attr4" value="diskRead" onchange="diskReadSetVisibility()"></td><td style="font-size:14px;">Disk Read are > &nbsp;</td><td> : </td>
                                                <td><input type="text" id="diskReadThreshold" name="diskReadThreshold" value="0" size="2" style="text-align: center;visibility:hidden;" onchange="diskReadValidate()" style="font-size:14px;"> KbPs</td>
                                            </tr>
                                            <tr>
                                                <td><input type="checkbox" id="attr5" name="attr5" value="diskWrite" onchange="diskWriteSetVisibility()"></td><td style="font-size:14px;">Disk Writes are > &nbsp;</td><td> : </td>
                                                <td><input type="text" id="diskWriteThreshold" name="diskWriteThreshold" value="0" size="2" style="text-align: center;visibility:hidden;" onchange="diskWriteValidate()" style="font-size:14px;"> KbPs</td>
                                            </tr>
                                        </table>
                                        <table>
                                            <tr>
                                                <td style="text-align:right;font-size:14px;">for : </td>
                                                <td style="font-size:14px;text-align: center;width:35px;"><span id="periodSpan">1</span></td><td style="font-size:14px;width:90px;">Times</td><td><input type="range" id="period" name="period" min="1" max="5" step="1" value="1" style="width:50px;" onchange="periodVal()"></td>
                                            </tr>
                                        </table>
                                    </form>
                                    <hr>
                                    <p style="font-size:15px;"><i>
                                        This alarm will be triggered when </br>
                                        <span id="showCPU">CPU Usage > <span id="showCPUUsage"></span> MHz or</span>
                                        <span id="showMem">Memory Usage > <span id="showMemUsage"></span> MBs or</span>
                                        <span id="showNet">Network Usage > <span id="showNetUsage"></span> KbPs or</span>
                                        <span id="showDiskR">Disk Read > <span id="showDiskRead"></span> KbPs or</span>
                                        <span id="showDiskW">Disk Write > <span id="showDiskWrite"></span> KbPs or</span>
                                    </i></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    <button type="button" class="btn btn-primary" id="createAlarmBtn" disabled onclick="createAlarm()">Create Alarm</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="myOtherModal" tabindex="-1" role="dialog" aria-labelledby="myOtherModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h3 class="modal-title"><i>Delete Alarm</i></h3>
                                </div>
                                <div class="modal-body">
                                    <p style="margin-left:30px"> Are you sure you want to delete the alarm?</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    <button type="button" class="btn btn-primary" id="deleteAlarmBtn" onclick="deleteAlarm()">Delete Alarm</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    </br>
                    </br>
                    <%
                        String sql1 = "select * from alarms where userName=?";
                        try {
                            Class.forName(driverName);
                            con = DriverManager.getConnection(url, user, dbpsw);
                            ps = con.prepareStatement(sql1);
                            ps.setString(1, usrName);
                            rs = ps.executeQuery();
                            if (rs.isBeforeFirst()) {
                    %>
                    <div>
                        <label style="text-align:center;font-size: medium">Your Alarms</label>
                        <table border="1">
                            <tr>
                                <th>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>VM Name</label>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>Alarm set for CPU</label>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>Alarm set for memory</label>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>Alarm set for disk read</label>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>Alarm set for disk write</label>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>Alarm set for network usage</label>
                                </th>
                                <th>
                                    <label style='margin-left: 30px'>Alarm set for period</label>
                                </th>
                            </tr>
                                    <%
                                    int i=0;
                                while(rs.next()) {
                                        i++;
                                        String virtualMachineName = rs.getString("vmName");
                                        String cpuAlrm;
                                        if(rs.getInt("cpuUsage")== -1) {
                                            cpuAlrm = "-";
                                        }
                                        else {
                                            cpuAlrm = ((Integer)rs.getInt("cpuUsage")).toString();
                                        }
                                        String memAlrm;
                                        if(rs.getInt("memoryUsage")== -1) {
                                            memAlrm = "-";
                                        }
                                        else {
                                            memAlrm = ((Integer)rs.getInt("memoryUsage")).toString();;
                                        }
                                        String readAlrm;
                                        if(rs.getInt("diskRead") == -1) {
                                            readAlrm = "-";
                                        }
                                        else {
                                            readAlrm = ((Integer)rs.getInt("diskRead")).toString();
                                        }
                                        String writeAlrm;
                                        if(rs.getInt("diskWrite") == -1) {
                                            writeAlrm = "-";
                                        }
                                       else {
                                            writeAlrm = ((Integer)rs.getInt("diskWrite")).toString();
                                        }
                                        String netAlrm;
                                        if(rs.getInt("ntwUsage") == -1) {
                                            netAlrm = "-";
                                        }
                                        else {
                                            netAlrm = ((Integer)rs.getInt("ntwUsage")).toString();
                                        }
                                        int period = rs.getInt("period");

                                        out.println("<tr><td><input type=\"radio\" name=\"radios\" value=\"radio" + i + "\" onclick=\"selectDeletion()\" >  </td>" +
                                         "<td><label style='margin-left: 30px' id='vmName" + i + "'>"+ virtualMachineName + "</label></td>" +
                                          "<td><label style='margin-left: 30px' id='cpuAlrm" + i + "'>"+ cpuAlrm + "</label></td>" +
                                           "<td><label style='margin-left: 30px' id='memAlrm" + i + "'>" + memAlrm + "</label></td>" +
                                            "<td><label style='margin-left: 30px' id='readAlrm" + i + "'>" + readAlrm +"</label></td>" +
                                                "<td><label style='margin-left: 30px' id='writeAlrm" + i + "'>" + writeAlrm +"</label></td>" +
                                                "<td><label style='margin-left: 30px' id='netAlrm" + i + "'>" + netAlrm +"</label></td>" +
                                                "<td><label style='margin-left: 30px' id='period" + i + "'>" + period +"</label></td></tr>");
                                 }
                                 %>
                        </table>
                    </div>
                                <%
                            }
                        }
                        catch(Exception sqe) {
                            response.sendRedirect("error.jsp?error=" + sqe.getMessage());
                        }
                    %>
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
