<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <!-- import of log4j for use in this jsp page -->
<%@page import="org.apache.log4j.Logger"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- adjusts the view size according to the device type -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">

<!-- javascript method to detect for mobile device -->
<script type="text/javascript">

function checkForMobile(){
	
	var isMobile = "false";
	
	if (screen.width <= 800) {
		  <%--window.location = "http://192.168.1.54:8080/DropInRegistration/m.index.jsp";--%>
		  isMobile = "true";
	  }
		document.getElementById("isMobile").value = isMobile;
}

</script>

<title>FNH Login</title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="css/style.css">

<!-- javascript method to validate form data on submit -->
<script>

function validateForm() {
    
    var email = document.forms["form1"]["uname"].value;
    var password = document.forms["form1"]["pass"].value;
    
    if (email == "" || password == "") {
        alert("Enter your email and password.");
        return false;
    }
}

</script>
<!-- additional styles overriding base css file -->
<style>

.abs{
	width: 100%;
}
.box{
	width:300px;
	margin: 0 auto;
	color: black;
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
#mydiv{
	position: fixed;
	top: 50%;
	left: 50%;
	width: 30em;
	height: 18em;
	margin-top: -9em;
	margin-left: -15em;
}
</style>
</head>

<!-- call to the js method check for mobile on body load -->
<body onLoad="checkForMobile()">

<!-- java scriptlet to initialize log4j -->
<% 
Logger log= Logger.getLogger("index.jsp");
log.info("index.jsp called");
%>


<!-- inline style adjustment for the login box size -->
<div class="login" style="width:300px; height:260px">

<h1>Friday Night Hockey - Britannia Ice Rink @ Commercial Drive, 11:15 PM.</h1>

<!-- form to collect user information and forward to the login servlet after data validation -->
	<form action="Login" id="form1" name="form1" onsubmit="return validateForm()" >
		<input type="text" class="login-input" placeholder="email" name="uname" />
		<input type="password" class="login-input" placeholder="password" name="pass" />
		<input type="hidden" name="isMobile" id="isMobile" value=""/>
		<input type="submit" class="login-submit" value="login" />
	</form>
	<!-- hyperlinks to direct to pages for password recovery and password reset -->
	<p class="login-help"><a href="passwordRecovery.jsp">Forgot password</a> - <a href="passwordReset.jsp">Password reset</a></p>
	
</div>	
			<!-- java scriplet to check if a session user message has been set -->
			<%
				String msg = (String) request.getSession().getAttribute("userMessage");
				
				if (msg != null && msg != "") {
				String[] parts = msg.split("-");
			%>
			
			<div class="abs">
			
				<div class="box login" style="color: white">
				
					<%if (parts[0].contains("Error") || parts[0].contains("Sorry") ) { %>
			
							<%for (int i=0;i<parts.length;++i){ %>
							<font color="white"><%out.print(parts[i]);%></font>
							<%} %>
			
						<%} else { %>
				
							<%for (int i=0;i<parts.length;++i){ %>
								<%out.print(parts[i]);%>
							<%} %>
				
						<%} %>
			
					<%}%>
					
					<%
					session.removeAttribute("userMessage");
					session.invalidate(); %>
				
				</div>
			
			</div>
			
			
				
	</body>
</html>