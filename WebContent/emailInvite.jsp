<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ page import="com.rsnorrena.util.DateOfNextGame"%>
 <%@page import="org.apache.log4j.Logger"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Email Invite</title>
<link rel="stylesheet" href="css/style.css">
<script type="text/javascript">
    function getContent(){
var div_val=document.getElementById("editablediv").innerHTML;
        document.getElementById("formtextarea").value =div_val;
    if(div_val==''){
     //alert("option alert or show error message")
     return false;
     //empty form will not be submit. You can also alert this message like this.
    }
        }</script>
<style>

u { 
    text-decoration: underline;
}
.center {
    margin: auto;
    }
    td.pr{
    padding-right:10px;
    }
    body, html {
	margin: 0;
	background-image: url("images/backhand.jpg");
	height: 100%;
	background-size: cover;
	background-repeat: no-repeat;
	background-position: center center;
}
.login {
	opacity: 0.9;
	filter: Alpha(opacity=90);
}
</style>
</head>
<body>

<%
Logger log= Logger.getLogger("emailInvite.jsp");
log.info("emailInvite.jsp called");
%>

<%
String date = DateOfNextGame.getDateOfNextGame();
int daysToNextGame = DateOfNextGame.getNumberOfDaysToNextGame();
String subject = "Friday Night Hockey - " + date;
%>


<div class="login" >

<h1>FNH Group Email - New Session</h1>

To: all<br>
From: snorrena@gmail.com<br>
Subject: <%=subject %><br><br>

<div id="editablediv" contenteditable="true" style="border:1px solid black;">
Good day all!<br><br><br>

<%if(daysToNextGame == 0) { %>
The next game is tonight at 11:15 pm.<br><br>
<%} else { %>
The next game is <%=daysToNextGame%> <%=daysToNextGame > 1 ? "days" : "day" %> from today on <%=date %> 11:15 pm.<br><br>
<%} %>
Please click on the link below to login and register to play.<br><br>

Remember, if you are registered but cannot attend, please return to this site to cancel your registration and release your spot to another skater.<br><br>

http://snorrena.getmyip.com:8080/DropInRegistration/<br><br><br>


Thanks<br><br>

The Management<br>
 
</div>
<br>
<small>* edit the text body as needed</small>


</div>
<div class="login" style="width:300px">

<table class="center">
<tr>

<td class="pr">
	<form id="form" action="SendGroupMail" onsubmit="return getContent()" >
    	<textarea id="formtextarea" style="display:none" name="groupMailMessage"></textarea>
    	<input type="submit" class="login-submit" value="Email All" />
    	<input type="hidden" name="emailRequest" id="emailRequest" value="groupEmail"/>
    	<input type="hidden" name="emailSubject" id="emailSubject" value=<%=subject %>/>
	</form>
</td>
<td class="pr">
	<form action="admin.jsp">
		<input type="submit" class="login-submit" value="Back">
	</form>
</td>
<td>
	<form action="Logout">
		<input type="submit" class="login-submit" value="Logout">
	</form>
</td>

</tr>
</table>

	
</div>

</body>
</html>