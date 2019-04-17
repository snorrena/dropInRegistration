
<%@ page import="java.util.*"%>
<%@ page import="com.rsnorrena.data.Player"%>
<%@ page import="com.rsnorrena.database.CRUD"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="org.apache.log4j.Logger"%>


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
#container {
	display: table-cell;
	verticle-align: middle;
}
 .login {
	opacity: 0.9;
	filter: Alpha(opacity=90);
}
.login-submit {
	margin-bottom: 0px;
}
@media screen and (min-width: 0px) and (max-width 720px){
	.mobile-hide{display: none;}
}
table.center {
	margin-left:auto;
	margin-right:auto;
	color:white;
}
</style>
</head>
<body>

	<%-- the session attribute is used to confirm successful login.
If not, the user is send back to the login jsp --%>

	<%
	
	Logger log= Logger.getLogger("welcome.jsp");
	
		log.info("welcome.jsp called");
	HttpSession nsession = request.getSession();
	
		if ((String) nsession.getAttribute("uname") == null) {%>
		
		<jsp:forward page="index.jsp"/>
		
		<% }
	%>
	

	<div class="login" style="color:white">

		<h1>Friday Night Hockey - Britania Rink @ Commercial Drive, 11:15
			PM</h1>
			

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
		another player.

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
			out.print((skaterCount == 1) ? "skater are" : "skaters are ");
		%>
		scheduled to play and
		<%=waitListCount%>
		<%
			out.print((waitListCount == 0 || waitListCount > 1) ? "players are " : "player is ");
		%>
		on the waitlist.

	</div>


	<div class="login mobile-hide" style="height:200px">
		<H1>Player Roster</H1>

		
		<%-- start new table data here --%>
		
		<table style="width:100%; color:white;">
		
		<tr>
			<th></th>
			<th style="text-align:left"><u><b><font color="ffffff">Goalies:</font></b></u></th>
			<th></th>
			<th style="text-align:left"><u><b><font color="ffffff">Players:</font></b></u></th>
			<th></th>
			<th></th>	
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th style="text-align:left"><u><b><font color="ffffff">Waitlist:</font></b></u></th>
		</tr>
			
	<tr>
		<td>1:</td>
		<td>
			<%
								if (currentUser.equals(goalieList[0])) {
							%> <font color="red"><%=goalieList[0]%></font> <%
 	} else {
 %> <%=goalieList[0]%> <%
 	}
 %>
		</td>
		<td>1:</td>
		<td>
			<%
								if (currentUser.equals(playerList[0])) {
							%> <font color="red"><%=playerList[0]%></font> <%
 	} else {
 %> <%=playerList[0]%> <%
 	}
 %>
		</td>
		<td>6:</td>
		<td>
			<%
								if (currentUser.equals(playerList[5])) {
							%> <font color="red"><%=playerList[5]%></font> <%
 	} else {
 %> <%=playerList[5]%> <%
 	}
 %>
		</td>
		<td>11:</td>
		<td>
			<%
								if (currentUser.equals(playerList[10])) {
							%> <font color="red"><%=playerList[10]%></font> <%
 	} else {
 %> <%=playerList[10]%> <%
 	}
 %>
		</td>
		<td>16:</td>
		<td>
			<%
								if (currentUser.equals(playerList[15])) {
							%> <font color="red"><%=playerList[15]%></font> <%
 	} else {
 %> <%=playerList[15]%> <%
 	}
 %>
		</td>
		<td>1:</td>
		<td>
		<%
								if (currentUser.equals(waitList[0])) {
							%> <font color="red"><%=waitList[0]%></font> <%
 	} else {
 %> <%=waitList[0]%> <%
 	}
 %>
 </td>
	</tr>	
	
	<tr>
		<td>2:</td>
		<td>
			<%
								if (currentUser.equals(goalieList[1])) {
							%> <font color="red"><%=goalieList[1]%></font> <%
 	} else {
 %> <%=goalieList[1]%> <%
 	}
 %>
		</td>
		<td>2:</td>
		<td>
			<%
								if (currentUser.equals(playerList[1])) {
							%> <font color="red"><%=playerList[1]%></font> <%
 	} else {
 %> <%=playerList[1]%> <%
 	}
 %>
		</td>
		<td>7:</td>
		<td>
			<%
								if (currentUser.equals(playerList[6])) {
							%> <font color="red"><%=playerList[6]%></font> <%
 	} else {
 %> <%=playerList[6]%> <%
 	}
 %>
		</td>
		<td>12:</td>
		<td>
			<%
								if (currentUser.equals(playerList[11])) {
							%> <font color="red"><%=playerList[11]%></font> <%
 	} else {
 %> <%=playerList[11]%> <%
 	}
 %>
		</td>
		<td>17:</td>
		<td>
			<%
								if (currentUser.equals(playerList[16])) {
							%> <font color="red"><%=playerList[16]%></font> <%
 	} else {
 %> <%=playerList[16]%> <%
 	}
 %>
		</td>
		<td>2:</td>
		<td>
			<%
								if (currentUser.equals(waitList[1])) {
							%> <font color="red"><%=waitList[1]%></font> <%
 	} else {
 %> <%=waitList[1]%> <%
 	}
 %>
		</td>
	</tr>
	
	<tr>
		<td></td>
		<td></td>
		<td>3:</td>
		<td>
			<%
								if (currentUser.equals(playerList[2])) {
							%> <font color="red"><%=playerList[2]%></font> <%
 	} else {
 %> <%=playerList[2]%> <%
 	}
 %>
		</td>
		<td>8:</td>
		<td>
			<%
								if (currentUser.equals(playerList[7])) {
							%> <font color="red"><%=playerList[7]%></font> <%
 	} else {
 %> <%=playerList[7]%> <%
 	}
 %>
		</td>
		<td>13:</td>
		<td>
		<%
								if (currentUser.equals(playerList[12])) {
							%> <font color="red"><%=playerList[12]%></font> <%
 	} else {
 %> <%=playerList[12]%> <%
 	}
 %></td>
		<td>18:</td>
		<td>
		<%
								if (currentUser.equals(playerList[17])) {
							%> <font color="red"><%=playerList[17]%></font> <%
 	} else {
 %> <%=playerList[17]%> <%
 	}
 %></td>
		<td>3:</td>
		<td>
			<%
								if (currentUser.equals(waitList[2])) {
							%> <font color="red"><%=waitList[2]%></font> <%
 	} else {
 %> <%=waitList[2]%> <%
 	}
 %>
		</td>
	</tr>
	
	<tr>
		<td></td>
		<td></td>
		<td>4:</td>
		<td>
		<%
								if (currentUser.equals(playerList[3])) {
							%> <font color="red"><%=playerList[3]%></font> <%
 	} else {
 %> <%=playerList[3]%> <%
 	}
 %></td>
		<td>9:</td>
		<td>
		<%
								if (currentUser.equals(playerList[8])) {
							%> <font color="red"><%=playerList[8]%></font> <%
 	} else {
 %> <%=playerList[8]%> <%
 	}
 %></td>
		<td>14:</td>
		<td>
		<%
								if (currentUser.equals(playerList[13])) {
							%> <font color="red"><%=playerList[13]%></font> <%
 	} else {
 %> <%=playerList[13]%> <%
 	}
 %></td>
		<td>19:</td>
		<td>
		<%
								if (currentUser.equals(playerList[18])) {
							%> <font color="red"><%=playerList[18]%></font> <%
 	} else {
 %> <%=playerList[18]%> <%
 	}
 %></td>
		<td>4:</td>
		<td>
			<%
								if (currentUser.equals(waitList[3])) {
							%> <font color="red"><%=waitList[3]%></font> <%
 	} else {
 %> <%=waitList[3]%> <%
 	}
 %>
		</td>
	</tr>
	
	<tr>
		<td></td>
		<td></td>
		<td>5:</td>
		<td>
		<%
								if (currentUser.equals(playerList[4])) {
							%> <font color="red"><%=playerList[4]%></font> <%
 	} else {
 %> <%=playerList[4]%> <%
 	}
 %></td>
		<td>10:</td>
		<td>
		<%
								if (currentUser.equals(playerList[9])) {
							%> <font color="red"><%=playerList[9]%></font> <%
 	} else {
 %> <%=playerList[9]%> <%
 	}
 %></td>
		<td>15:</td>
		<td>
		<%
								if (currentUser.equals(playerList[14])) {
							%> <font color="red"><%=playerList[14]%></font> <%
 	} else {
 %> <%=playerList[14]%> <%
 	}
 %></td>
		<td>20:</td>
		<td>
		<%
								if (currentUser.equals(playerList[19])) {
							%> <font color="red"><%=playerList[19]%></font> <%
 	} else {
 %> <%=playerList[19]%> <%
 	}
 %></td>
		<td></td>
		<td></td>
	</tr>
		
		</table>
		
		<%-- end new table data here --%>
		
	</div>
	
	<div class="login">
		<%
			//the player is already registered to play in the next game.
			if (player.isRegistered()) {
		%>
		
		<table class="center">
			<tr>
				<td class="pr" style="width:150px">
					<form action="CancelRegistration">

						<input type="hidden" class="login-input" name="email" value=<%=player.getEmailAddress()%> />
						<input type="hidden" name="isMobile" id="isMobile" value="false" />
						
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
			//player is a skater and there is space remaining in the roster or waitlist
			} else if((player.getPosition().equals("Forward") || player.getPosition().equals("Defense")) && skaterCount <= 20 && waitListCount < 4) {
		%>
		
		<table class="center">
			<tr>
				<td class="pr" style="width:150px">
					<form action="SubmitRegistration">

						<input type="hidden" class="login-input" name="email" value=<%=player.getEmailAddress()%> />
						<input type="hidden" name="isMobile" id="isMobile" value="false" />
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
						<input type="hidden" name="isMobile" id="isMobile" value="false" />
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
		
		<div>
			
		</div>
	</div>
	


</body>

</html>