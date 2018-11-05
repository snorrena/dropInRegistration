
<%@ page import="java.util.*"%>
<%@ page import="com.rsnorrena.data.Player"%>
<%@ page import="com.rsnorrena.database.CRUD"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="org.apache.log4j.Logger"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">


<title>Welcome</title>
<link rel="stylesheet" href="css/style.css">
<style>

u { 
    text-decoration: underline;
}
em {
	font-size: 150%;
}
td.pr{
    padding-right:10px;
    }
body, html {
	margin: 0;
	background-image: url("images/backhand.jpg");
	height: 100%;
	width: 100%;
	background-size: cover;
	background-repeat: no-repeat;
	background-position: center center;
}
 .login {
	opacity: 0.9;
	filter: Alpha(opacity=90);
	width: auto;
	margin: 10px 10px 10px 10px;
}
#mydiv{
	height: 100px;
	overflow-y: auto;
}
table.center {
	margin-left:auto;
	margin-right:auto;
	color:white;
}
.login-submit {
	margin-bottom: 0px;
}
</style>
</head>
<body>

	<%-- the session attribute is used to confirm successful login.
If not, the user is send back to the login jsp --%>

	<%
	
	Logger log= Logger.getLogger("m.welcome.jsp");
	log.info("m.welcome.jsp called");
	
	HttpSession nsession = request.getSession();
	
		if ((String) nsession.getAttribute("uname") == null) {%>
		
		<jsp:forward page="index.jsp"/>
		
		<% }
	%>

	<div class="login" style="color:white">

		<h1>Friday Night Hockey</h1>
			

		<%if ((String)request.getAttribute("registrationRequestSubmitted") == null) {%>

		Welcome <em>${username}</em> ! 
		
		<%}else{%>
		
			Thanks <em>${username}</em> !<br><br>
			Your request has been processed.
			
		<%} %>
		
		<br></br>

		<%
			int daysToNextGame = (int) session.getAttribute("daysToNextGame");

			String dateOfNextGame = (String) session.getAttribute("date");

			boolean isRegistered = false;

			String email = (String) session.getAttribute("email");

			//Player currentPlayer = null;
			Player player = null;
			Player waitlistPlayer = null;

			String currentUser = null;
			String emailOfPlayerOnWaitList = null;
			String indexOfPlayerOnWaitlist = null;

			int waitListCount = 0;

			//initialize lists of players, goalies and waitlist
			String[] goalieList = new String[2];
			for (int i = 0; i < goalieList.length; ++i) {
				goalieList[i] = "TBD";
			}

			String[] playerList = new String[80];
			for (int i = 0; i < playerList.length; ++i) {
				playerList[i] = "TBD";
			}

			String[] waitList = new String[4];
			for (int i = 0; i < waitList.length; ++i) {
				waitList[i] = "TBD";
			}

			//retrieve the list of registered players and convert to an arraylist
			//Object obj = request.getAttribute("playerList");

			ArrayList<Player> registeredPlayers = CRUD.getAllPlayers();

			//if (obj instanceof ArrayList<?>) {
				//registeredPlayers = (ArrayList<?>) obj;
			//}
			//sort the collect so that the player will display in order of index	
			Collections.sort(registeredPlayers, Player.indexComparator);

			int playerIndex = 0;
			int goalieIndex = 0;
			int waitListIndex = 0;
			int goalieCount = 0;
			int skaterCount = 0;

			for (Player currentPlayer : registeredPlayers) {

				//if (playerObj instanceof Player) {
					//currentPlayer = (Player) playerObj;
				//}

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

					//assign the email address of the first person on the waitlist to a variable
					if (emailOfPlayerOnWaitList == null) {
						emailOfPlayerOnWaitList = currentPlayer.getEmailAddress();
						waitlistPlayer = currentPlayer;
						indexOfPlayerOnWaitlist = String.valueOf(currentPlayer.getIndex());
					}
					
					waitList[waitListIndex++] = playerName;
					++waitListCount;
				}

				if (email.equals(currentPlayer.getEmailAddress())) {
					currentUser = playerName;
					player = currentPlayer;
					isRegistered = player.isRegistered();
				}

			}//end of foreach loop
			log.info("Registered: Goalies:" + goalieCount + ", Skaters:" + skaterCount + ", Waitlist:" + waitListCount);
			log.info("Email of the first player on the waitlist: " + emailOfPlayerOnWaitList);
			log.info("The current user: " + currentUser + " is a " + player.getPosition() + " of status: " + player.getStatus());
		%>

		<%
			if (daysToNextGame == 0) {
		%>
		Game on tonight at 11:15 PM.
		<%
			} else {
		%>
		The next game is
		<%=daysToNextGame%>
		<%
			out.print(daysToNextGame > 1 ? "days" : "day");
		%>
		from today on
		<%=dateOfNextGame%>.
		<%
			}
		%>

		<br></br>

		<%
			if (player.isRegistered() == true && player.getStatus().equals("Confirmed")) {
		%>

		You are confirmed to play.
		<br></br>
		If for any reason you are unable to attend,
		please return to this website, login and click the cancel registration button to release your spot to
		another skater.

		<%
			} else if (player.isRegistered() == true && player.getStatus().equals("Waitlist")) {
		%>

		Please note that you are on the waitlist and will be notified by email if a spot
		opens up.

		<%
			//} else if(player.getPosition() != "Goalie" && skaterCount <= 20 && waitListCount < 4) {
			} else if(player.getPosition().equals("Forward") || player.getPosition().equals("Defense")) {
		%>
				<%if(skaterCount < 20) { %>
					Click the button below to reserve your spot in the line up.
				<%}else if(waitListCount < 4){ %>
					Unfortunately, the roster is full. However, you may click the button below to be added to the waitlist. You will
					be notified by email if a spot opens up.
				<%}else{ %>
					Unfortunately, the roster is full and there are already four skaters on the waitlist. Better luck next week!
				<%} %>
		
		<%
			//Player is a goal tender
			} else {
		%>
			<%
				if(goalieCount < 2){
			%>
				Click the button below to reserve your spot in the line up.
			<%}else{ %>
				Unfortunately, there are already two goal tenders registered. Please contact us directly by email if your intention was to register as a skater.
			<%} %>

		<%
			}
		%>
		
		<br></br>

		Currently,
		<%=goalieCount%>
		<%
			out.print((goalieCount == 0 || goalieCount > 1) ? "goalies " : "goalie ");
		%>
		and <%=skaterCount%> 
		<%
			out.print((skaterCount == 0 || skaterCount > 1) ? "skaters are " : "skater is ");
		%>
		scheduled to play and
		<%=waitListCount%>
		<%
			out.print((waitListCount == 0 || waitListCount > 1) ? "players are " : "player is ");
		%>
		on the waitlist.

	</div>

	<%--this form presents a logout button that when pressed invokes the logout 
servlet --%>
	<div class="login">
		<%
			if (player.isRegistered()) {
		%>
		
		<table class="center">
			<tr>
				<td class="pr" style="width:150px">
					<form action="CancelRegistration">

						<input type="hidden" class="login-input" name="email" value=<%=player.getEmailAddress()%> />
						<input type="hidden" name="isMobile" id="isMobile" value="true" />
						
						<%if(player.getEmailAddress() != emailOfPlayerOnWaitList) {%>
							<input type="hidden" class="login-input" name="emailOfPlayerOnWaitList" value=<%=emailOfPlayerOnWaitList%> />
							<input type="hidden" name="index" id="index" value=<%=indexOfPlayerOnWaitlist%> />
						<%} %>
						
						<input type="submit" class="login-submit" value="Cancel Registration">

					</form>
				</td>
				<td style="width:150px">
					<form action="Logout">

						<input type="submit" class="login-submit" value="Logout">

					</form>
				</td>
			</tr>
		</table>
		
		<%
			} else if((player.getPosition().equals("Forward") || player.getPosition().equals("Defense")) && skaterCount <= 20 && waitListCount < 4) {
		%>
		
		<table class="center">
			<tr>
				<td class="pr" style="width:150px">
					<form action="SubmitRegistration">

						<input type="hidden" class="login-input" name="email" value=<%=player.getEmailAddress()%> />
						<input type="hidden" name="isMobile" id="isMobile" value="true" />
						<input type="submit" class="login-submit" value="Count me in!">

					</form>
				</td>
				<td style="width:150px">
					<form action="Logout">

						<input type="submit" class="login-submit" value="Logout">

					</form>
				</td>
			</tr>
		</table>
		
		<%
			//player is a goal tender and the goalie count is less than two.
			} else if(player.getPosition().equals("Goalie") && goalieCount < 2) {
		%>
		
			<table class="center">
			<tr>
				<td class="pr" style="width:150px">
					<form action="SubmitRegistration">

						<input type="hidden" class="login-input" name="email" value=<%=player.getEmailAddress()%> />
						<input type="hidden" name="isMobile" id="isMobile" value="true" />
						<input type="submit" class="login-submit" value="Count me in!">

					</form>
				</td>
				<td style="width:150px">
					<form action="Logout">

						<input type="submit" class="login-submit" value="Logout">

					</form>
				</td>
			</tr>
		</table>
		
		<%
			} else {
		%>
		
		<table class="center">
			<tr>
				<td style="width:150px">
					<form action="Logout">

						<input type="submit" class="login-submit" value="Logout">

					</form>
				</td>
			</tr>
		</table>
		
		<%
			}
		%>
			
		</div>

</body>

</html>