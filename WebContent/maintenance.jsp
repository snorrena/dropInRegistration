<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="com.rsnorrena.data.Player"%>
<%@ page import="com.rsnorrena.database.CRUD"%>
<%@ page import="java.util.*"%>
<%@page import="org.apache.log4j.Logger"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Maintenance</title>
<link rel="stylesheet" href="css/style.css">
<script>
function getSelectedValue(){

	var myPlayer = document.getElementById("playerList").value;
	var elements = myPlayer.split(",");
	
	document.getElementById("firstName").value = elements[0];
	document.getElementById("lastName").value = elements[1];
	document.getElementById("password").value = elements[2];	
	document.getElementById("isRegistered").value = elements[3];
	document.getElementById("email").value = elements[4];
	document.getElementById("position").value = elements[5];
	document.getElementById("status").value = elements[6];
	document.getElementById("registrationIndex").value = elements[7];
}
function validateForm() {
    var firstName = document.forms["form1"]["firstName"].value;
    var lastName = document.forms["form1"]["firstName"].value;
    var password = document.forms["form1"]["password"].value;
    var isRegistered = document.forms["form1"]["registrationStatus"].value;
    var email = document.forms["form1"]["email"].value;
    var position = document.forms["form1"]["playerPosition"].value;
    var status = document.forms["form1"]["playerStatus"].value;
    if (firstName == "" || lastName == "" || password == "" || isRegistered == "" || email == "" || position == "" || status == "") {
        alert("All form fields must be filled out");
        return false;
    }
}
function updateStatus(selectObj){
	
	var index = selectObj.selectedIndex;
	var value = selectObj.options[index].value;
	
	if(value == "false"){
		document.getElementById("status").selectedIndex="0";
	}
	if(value == "true"){
		document.getElementById("status").selectedIndex="1";
	}
	if(value == "TBD"){
		document.getElementById("isRegistered").selectedIndex="0";
	}
	if(value == "Confirmed"){
		document.getElementById("isRegistered").selectedIndex="1";
	}
	if(value == "Goalie"){
		document.getElementById("status").selectedIndex="1";
		document.getElementById("isRegistered").selectedIndex="1";
	}
}
</script>
<style>

.abs{
	width: 100%;
}
.box{
	width:400px;
	margin: 0 auto;
	color:black;
}
.login-input{
	height: 25px;
  margin-bottom: 10px;
  padding: 0 9px;
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

<%-- the session attribute is used to confirm successful login.
If not, the user is send back to the login jsp --%>

<%
Logger log= Logger.getLogger("maintenance.jsp");
log.info("maintenance.jsp called");
%>

	<%
	
	HttpSession nsession = request.getSession();
	
		if ((String) nsession.getAttribute("uname") == null) {%>
		
		<jsp:forward page="index.jsp"/>
		
		<% }
	%>

<%ArrayList<Player> playerList = CRUD.getAllPlayers();
    Collections.sort(playerList);%>
    
    <div class="login" style="width:400px">
    
    <h1>FNH - Player Data Maintenance</h1>
    
    <select id="playerList" class="login-input" onchange="getSelectedValue()" >
        <option value="" selected>Select Player</option>
        <%
        for(int i=0;i<playerList.size();i++) {
        	Player player = playerList.get(i);
            String playerName = player.getFirstName() + " " + player.getLastName();
            String playerData = player.getFirstName() + "," + player.getLastName() + ","
            		+ player.getPassword() + "," + player.isRegistered() + ","
            		+ player.getEmailAddress() + "," + player.getPosition() + ","
            		+ player.getStatus()+ "," + Integer.toString(player.getIndex());
        %>
        <option value="<%=playerData %>"><%=playerName %></option>
        <%} %>
    </select>
    <form action="ManagePlayerData" id="form1" name="form1" onsubmit="return validateForm()">
    	<br>
    	
    	<table>
    	
    		<tr>
    			<td>First Name</td><td><input type="text" class="login-input" id="firstName" name="firstName" value=""></td>
    		</tr>
    		
    		<tr>
    			<td>Last Name</td><td><input type="text" class="login-input" id="lastName" name="lastName" value=""></td>
    		</tr>
    		
    		<tr>
    			<td>Password</td><td><input type="text" class="login-input" id="password" name="password" value=""></td>
    		</tr>
    		
    		<tr>
    			<td>Registration</td>
    			<td>
    				<select id="isRegistered" class="login-input" name="registrationStatus" onchange="updateStatus(this)" >
    					<option id="r1" value="false">False</option>
    					<option id="r2" value="true">True</option>
    				</select>
    			</td>
    		</tr>
    		
    		<tr>
    			<td>Email</td><td><input type="text" class="login-input" id="email" name="email" value=""></td>
    		</tr>
    		
    		<tr>
    			<td>Position</td>
    			<td>
    				<select id="position" class="login-input" name="playerPosition" onchange="updateStatus(this)">
    					<option value="Forward">Forward</option>
    					<option value="Defense">Defense</option>
    					<option value="Goalie">Goalie</option>
    				</select>
    			</td>
    		</tr>
    		
    		<tr>
    			<td>Status</td>
    			<td>
    				<select id="status" class="login-input" name="playerStatus" onchange="updateStatus(this)">
    					<option id="s1" value="TBD">TBD</option>
    					<option id="s2" value="Confirmed">Confirmed</option>
    					<option id="s3" value="Waitlist">Waitlist</option>
    				</select>
    			</td>
    		</tr>
    		
    	</table>
    	
    <input type="hidden" name="registrationIndex" id="registrationIndex" value=""/>
    
    </form>
    
    <br>
    <table class="box">
    	<tr>
    		<td style="padding-right:10px">
    			<button type="submit" form="form1" class="login-submit" name="dataChange" value="update" >Update</button>
    		</td>
    		<td style="padding-right:10px">
    			<button type="submit" form="form1" class="login-submit" name="dataChange" value="add" >Add</button>
    		</td>
    		<td style="padding-right:10px">
    			<button type="submit" form="form1" class="login-submit" name="dataChange" value="delete">Delete</button>
    		</td>
    		<td style="padding-right:10px">
    		<form action = "admin.jsp" method = "GET">
    			<input type="submit" class="login-submit" name="view" value="View Roster"/>
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
  		
  		<%
				String msg = (String) request.getSession().getAttribute("userMessage");
  				session.setAttribute("userMessage", ""); 
				
				if (msg != null && msg != "") {
				String[] parts = msg.split("-");
			%>
			
			<div class="abs">
			
				<div class="box login" style="color: white">
				
					<%if (parts[0].contains("Error")) { %>
			
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
</body>
</html>