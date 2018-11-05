<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>FNH Password Reset</title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="css/style.css">
<script>

var pw   = $(".input-password"),
    cb   = $("#checkbox-unmask"),
    mask = true;

cb.on("click", function(){
  
  if(mask === true){
    mask = false;
    pw.attr("type", "text");
  } else {
    mask = true;
    pw.attr("type", "password");
  } 
  
});

function validateForm() {
    
    var email = document.forms["form1"]["emailAddress"].value;
    var pass1 = document.forms["form1"]["password1"].value;
    var pass2 = document.forms["form1"]["password2"].value;
    
    if (email == "") {
        alert("Enter your email address.");
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
	width:225px;
	margin: 0 auto;
	color: black;
}

</style>
</head>

<body>

<div class="login" style="width:300px">

<h1>FNH - Password Reset</h1>

<br>

	<form action="PasswordReset" id="form1" name="form1" onsubmit="return validateForm()" >
		<input type="text" class="login-input" placeholder="Email address" name="emailAddress" />
		<input type="password" class="login-input input-password" placeholder="Choose a password" name="password1" />
		<input type="password" class="login-input input-password" placeholder="Re-type password" name="password2" />
		<input id="checkbox-unmask" class="checkbox-unmask" type="checkbox" />
    	<label for="checkbox-unmask" class="label-unmask">Show my password</label><br><br>
		<input type="submit" class="login-submit" value="Submit" />
	</form>
	
</div>	
			
			<%
				String msg = (String) request.getSession().getAttribute("userMessage");
				
				if (msg != null) {
				String[] parts = msg.split("-");
			%>
			
			<div class="abs">
			
				<div class="box">
				
					<%if (parts[0].contains("Error") || parts[0].contains("Sorry") ) { %>
			
							<%for (int i=0;i<parts.length;++i){ %>
							<font color="red"><%out.print(parts[i]);%></font>
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