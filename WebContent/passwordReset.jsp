<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link rel="apple-touch-icon" sizes="76x76" href="images/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="images/favicon-16x16.png">
<link rel="manifest" href="images/site.webmanifest">
<link rel="mask-icon" href="images/safari-pinned-tab.svg" color="#5bbad5">
<link rel="shortcut icon" href="images/favicon.ico">
<meta name="msapplication-TileColor" content="#da532c">
<meta name="msapplication-config" content="images/browserconfig.xml">
<meta name="theme-color" content="#ffffff">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>FNH Password Reset</title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="css/style.css">
<script>

function addListeners(){
	var inp = document.querySelector( '#target' );

inp.addEventListener( 'focus', function(){
    inp.type = 'text';
});
inp.addEventListener( 'blur', function(){
    inp.type = 'password';
});

var inp1 = document.querySelector( '#target1' );

inp1.addEventListener( 'focus', function(){
    inp1.type = 'text';
});
inp1.addEventListener( 'blur', function(){
    inp1.type = 'password';
});

}



function validateForm() {
    
    var email = document.forms["form1"]["emailAddress"].value;
    var pass1 = document.forms["form1"]["password1"].value;
    var pass2 = document.forms["form1"]["password2"].value;
    
    if (email == "" || pass1 == "" || pass2 == "") {
        alert("All form fields must be complete.");
        return false;
    }else if(pass1 != pass2){
    	alert("Passwords do not match.");
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
	background-color: black;
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
.wrapper{
	position: absolute;
	height: 100%;
	width: 100%; 
}
</style>
</head>

<body onLoad="addListeners()">

<div class="wrapper">

<div class="login"  style="width:300px; height:325px">

<h1>FNH - Password Reset</h1>

<br>

	
	<form action="PasswordReset" id="form1" name="form1" onsubmit="return validateForm()" >
		<input type="text" class="login-input" placeholder="Email address" name="emailAddress" />
		<input class="login-input" type="text" placeholder="Current password" name="password"/>
    	<input class="login-input" type="password" id="target" placeholder="Choose a new password" name="password1"/>
    	<input class="login-input" type="password" id="target1" placeholder="Re-type new password" name="password2"/>
		<input type="submit" class="login-submit" value="Submit" />
	</form>
	
	
	
</div>	
			
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
					
				
				</div>
			
			</div>
			
	</div>
			
			<%session.removeAttribute("userMessage"); %>
				
	</body>
</html>