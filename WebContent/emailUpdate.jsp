<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.rsnorrena.util.DateOfNextGame"%>
<%@ page import="java.util.*"%>
<%@ page import="com.rsnorrena.data.Player"%>
<%@ page import="com.rsnorrena.database.CRUD"%>
<%@page import="org.apache.log4j.Logger"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>FNH - Roster Update</title>
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
#mydiv{
	height: 475px;
	overflow-y: auto;
}
</style>
</head>
<body>

<%
Logger log= Logger.getLogger("emailUpdate.jsp");
log.info("emailUpdate.jsp called");
%>

<%
String date = DateOfNextGame.getDateOfNextGame();
int daysToNextGame = DateOfNextGame.getNumberOfDaysToNextGame();

boolean isRegistered = false;

//Player currentPlayer = null;
Player player = null;
Player waitlistPlayer = null;

String currentUser = null;

int waitlistCount = 0;

String userMessage = "";
String subject = "";

//initialize lists of players, goalies and waitlist
String[] goalieList = new String[2];
for (int i = 0; i < goalieList.length; ++i) {
	goalieList[i] = "TBD";
}

String[] playerList = new String[80];
for (int i = 0; i < playerList.length; ++i) {
	playerList[i] = "TBD";
}

String[] waitlist = new String[4];
for (int i = 0; i < waitlist.length; ++i) {
	waitlist[i] = "TBD";
}

ArrayList<Player> registeredPlayers = CRUD.getAllPlayers();

//sort the collect so that the player will display in order of index	
Collections.sort(registeredPlayers, Player.indexComparator);

int playerIndex = 0;
int goalieIndex = 0;
int waitlistIndex = 0;
int goalieCount = 0;
int skaterCount = 0;

for (Player currentPlayer : registeredPlayers) {

		//the playerName will be used in the player list
	String playerName = currentPlayer.getFirstName() + " " + currentPlayer.getLastName();

	if (currentPlayer.isRegistered() == true && currentPlayer.getStatus().equals("Confirmed")) {

		if (currentPlayer.getPosition().equals("Goalie")) {
			
			goalieList[goalieIndex++] = playerName;
			++goalieCount;

		} else {
			
			playerList[playerIndex++] = playerName;
			++skaterCount;

		}

	} else if (currentPlayer.isRegistered() == true && currentPlayer.getStatus().equals("Waitlist")) {

			
		waitlist[waitlistIndex++] = playerName;
		++waitlistCount;
	}

	
}//end of foreach loop

	//int wl = 4 - waitlistCount;
if(skaterCount == 20 && waitlistCount == 4){
	userMessage = "The roster is full and there are four skaters on the waitlist.";
	subject = "FNH - " + date + " - The roster is full";

}else if(skaterCount == 20 && waitlistCount < 4){
	String s = "";
		if(waitlistCount == 0 || waitlistCount > 1){
			s = "players";
		}else{
			s = "player";
		}
		
		String a = "";
		
		if(waitlistCount == 1){
			a = "is";
		}else{
			a = "are";
		}
		
		
	userMessage = "The roster is full and there " + a + " " + waitlistCount + " " + s + " on the waitlist.";
	subject = "FNH - " + date + " - The roster is full";
}else{
	int sk = 20 - skaterCount;
	System.out.println("skaterCount = " + skaterCount);
	System.out.println("skaterCount minus 20 = " + sk);
	userMessage = "There " + (sk==1? "is":"are") + " " + sk + " " + (sk==1?"spot":"spots") + " remaining in the roster and the waitlist is empty.";
	subject = "FNH - " + date + " - " + sk + " " + (sk==1?"spot":"spots") + " remaining";
}

%>


<div class="login" id="mydiv">

<h1>FNH Group Email - Roster Update</h1>

To: all<br>
From: snorrena@gmail.com<br>
Subject: <%=subject %><br><br>

<div id="editablediv" contenteditable="true" style="border:1px solid black;">
Good day all!<br><br><br>

<%if(daysToNextGame == 0) { %>
The next game is tonight at 11:15 pm.<br><br>
<%} else { %>
The next game is <%=daysToNextGame%> <%=daysToNextGame > 1 ? "days" : "day" %> from today on <%=date %>.<br><br>
<%} %>
<%=userMessage %><br><br>

The players listed in the roster below are scheduled to play.<br><br>

Remember, if you are registered but cannot attend, please return to this site to cancel your registration and release your spot to another skater.<br><br>
 
http://snorrena.getmyip.com:8080/DropInRegistration/<br><br><br>


Thanks<br><br>

The Management<br><br><br>

 
Player Roster<br>
----------------<br>

Goalies<br>
---------
<br>1) <%=goalieList[0] %>
<br>2) <%=goalieList[1] %>

<br><br>Skaters<br>
--------- 
<br>1) <%=playerList[0] %>
<br>2) <%=playerList[1] %>
<br>3) <%=playerList[2] %>
<br>4) <%=playerList[3] %>
<br>5) <%=playerList[4] %>
<br>6) <%=playerList[5] %>
<br>7) <%=playerList[6] %>
<br>8) <%=playerList[7] %>
<br>9) <%=playerList[8] %>
<br>10) <%=playerList[9] %>
<br>11) <%=playerList[10] %>
<br>12) <%=playerList[11] %>
<br>13) <%=playerList[12] %>
<br>14) <%=playerList[13] %>
<br>15) <%=playerList[14] %>
<br>16) <%=playerList[15] %>
<br>17) <%=playerList[16] %>
<br>18) <%=playerList[17] %>
<br>19) <%=playerList[18] %>
<br>20) <%=playerList[19] %>

<br><br>Waitlist
<br>---------
<br>1) <%=waitlist[0] %>
<br>2) <%=waitlist[1] %>
<br>3) <%=waitlist[2] %>
<br>4) <%=waitlist[3] %>

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