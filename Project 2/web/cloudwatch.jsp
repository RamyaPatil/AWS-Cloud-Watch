<%--
  Created by IntelliJ IDEA.
  User: Varun
  Date: 5/1/2015
  Time: 6:45 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../favicon.ico">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootswatch/3.2.0/paper/bootstrap.min.css">
    <title>Cloud Watch</title>
</head>
<body background="images/backgroundPic.jpg">
</br>
</br>
<div class="container">
    <div class="row vcenter">
        <div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Cloud Statistics</h4>
                </div>
                <div class="panel-body">
                    <iframe src="http://54.183.233.221:5601/#/visualize/edit/New-Visualization?embed&_a=(filters:!(),linked:!f,query:(query_string:(analyze_wildcard:!t,query:'*')),vis:(aggs:!((id:'1',params:(field:cpu),schema:metric,type:avg),(id:'2',params:(extended_bounds:(),field:'@timestamp',interval:second,min_doc_count:1),schema:segment,type:date_histogram),(id:'3',params:(filters:!((input:(query:(query_string:(analyze_wildcard:!t,query:'vmname:T08-VM03-Lin')))))),schema:group,type:filters)),listeners:(),params:(addLegend:!t,addTooltip:!t,defaultYExtents:!f,shareYAxis:!t,spyPerPage:10),type:line))&_g=(time:(from:now-15m,to:now))" width="450px" height="450px">
                        <p>Your browser does not support iframes.</p>
                    </iframe>
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