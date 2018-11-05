<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>FNH Password Recovery</title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="css/style.css">
<script>

function validateForm() {
    
    var email = document.forms["form1"]["emailAddress"].value;
    
    if (email == "") {
        alert("Enter your email address.");
        return false;
    }
}

</script>
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

<body>



<div class="login" style="width:300px; height:175px">

<h1>FNH - Password Recovery</h1>

<p>Enter your email address</p>
<br>

	<form action="PasswordRecovery" id="form1" name="form1" onsubmit="return validateForm()" >
		<input type="text" class="login-input" placeholder="email address" name="emailAddress" />
		<input type="submit" class="login-submit" value="Submit" />
	</form>
	
</div>	
			
			<%
				String msg = (String) request.getSession().getAttribute("userMessage");
				
				if (msg != null && msg != "") {
				String[] parts = msg.split("-");
			%>
			
			<div class="abs">
			
				<div class="box login">
				
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
					
				
				</div>
			
			</div>
			
			<%session.removeAttribute("userMessage"); %>
				
	</body>
</html>