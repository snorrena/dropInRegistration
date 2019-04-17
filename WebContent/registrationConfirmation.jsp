
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.rsnorrena.data.Player"%>
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

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome</title>
<link rel="stylesheet" href="css/style.css">
<style type="text/css">
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
		if (session.getAttribute("username") == null) {
			response.sendRedirect("index.jsp");
		}
	%>

	<div class="login">

		<h1>Friday Night Hockey - Britania Rink @ Commercial Drive, 11:15
			PM</h1>


		Welcome ${username}! You are logged in! <br></br>

		<%
			int daysToNextGame = (int) request.getAttribute("daysToNextGame");

			String dateOfNextGame = (String) request.getAttribute("date");

			Boolean isRegistered = (Boolean) request.getAttribute("isregistered");

			String email = (String) request.getAttribute("email");

			Player currentPlayer = null;
			Player player = null;

			String currentUser = null;
			String emailOfPlayerOnWaitList = null;

			int waitListCount = 0;

			//initialize lists of players, goalies and waitlist
			String[] goalieList = new String[2];
			for (int i = 0; i < goalieList.length; ++i) {
				goalieList[i] = "TBD";
			}

			String[] playerList = new String[20];
			for (int i = 0; i < playerList.length; ++i) {
				playerList[i] = "TBD";
			}

			String[] waitList = new String[4];
			for (int i = 0; i < waitList.length; ++i) {
				waitList[i] = "TBD";
			}

			//retrieve the list of registered players and convert to an arraylist
			Object obj = request.getAttribute("playerList");

			ArrayList<?> registeredPlayers = null;

			if (obj instanceof ArrayList<?>) {
				registeredPlayers = (ArrayList<?>) obj;
			}

			int playerIndex = 0;
			int goalieIndex = 0;
			int waitListIndex = 0;
			int totalNumberRegisteredPlayers = 0;

			for (Object playerObj : registeredPlayers) {

				if (playerObj instanceof Player) {
					currentPlayer = (Player) playerObj;
				}

				//the playerName will be used in the player list
				String playerName = currentPlayer.getFirstName() + " " + currentPlayer.getLastName();

				if (currentPlayer.isRegistered() == true && currentPlayer.getStatus().equals("Confirmed")) {

					if (currentPlayer.getPosition().equals("Goalie")) {

						goalieList[goalieIndex++] = playerName;
						++totalNumberRegisteredPlayers;

					} else {

						playerList[playerIndex++] = playerName;
						++totalNumberRegisteredPlayers;

					}

				} else if (currentPlayer.isRegistered() == true && currentPlayer.getStatus().equals("Waitlist")) {

					//assign the email address of the first person on the waitlist to a variable
					if (emailOfPlayerOnWaitList == null) {
						emailOfPlayerOnWaitList = currentPlayer.getEmailAddress();
					}

					waitList[waitListIndex++] = playerName;
					++waitListCount;
				}

				if (email.equals(currentPlayer.getEmailAddress())) {
					currentUser = playerName;
					player = currentPlayer;
				}

			}
		%>

		<%
			if (daysToNextGame == 0) {
		%>
		Game on tonight at 11:15 PM
		<%
			} else {
		%>
		The next game is
		<%=daysToNextGame%>
		<%
			out.print(daysToNextGame > 1 ? "days" : "day");
		%>
		from today on
		<%=dateOfNextGame%>
		<%
			}
		%>

		<br></br>

		<%
			if (player.isRegistered() == true && player.getStatus().equals("Confirmed")) {
		%>

		You are confirmed to play. If for any reason you are unable to attend,
		click the cancel registration button below to release your spot to
		another skater.

		<%
			} else if (player.isRegistered() == true && player.getStatus().equals("Waitlist")) {
		%>

		Presently you are on the wait list and will be notified if a spot
		opens up.

		<%
			} else {
		%>

		Click the button below to reserve your spot in the line up.

		<%
			}
		%>

		<br></br> Currently
		<%=totalNumberRegisteredPlayers%>
		players are scheduled to attend and
		<%=waitListCount%>
		<%
			out.print((waitListCount == 0 || waitListCount > 1) ? "are " : "is ");
		%>
		on the wait list.

	</div>

	

	<div class="login" style="height:200px">
		<H1>Player Roster</H1>

		
		<%-- start new table data here --%>
		
		<table style="width:100%">
		
		<tr>
			<th></th>
			<th align="left"><font color="ffffff">Goalies:</font></th>
			<th></th>
			<th align="left"><font color="ffffff">Players:</font></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th align="left"><font color="ffffff">Waitlist:</font></th>
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
	
	<%--this form presents a logout button that when pressed invokes the logout 
servlet --%>
	<div class="login" style="width:200px">
		<%
			if (Boolean.TRUE.equals(isRegistered)) {
		%>
		<div>
			<form action="CancelRegistration">

				<input type="hidden" class="login-input" name="email"
					value=<%=player.getEmailAddress()%> /> <input type="hidden"
					class="login-input" name="emailOfPlayerOnWaitList"
					value=<%=emailOfPlayerOnWaitList%> /> <input type="submit"
					class="login-submit" value="Cancel Registration">

			</form>
		</div>
		<%
			} else {
		%>
		<div>
			<form action="SubmitRegistration">

				<input type="hidden" class="login-input" name="email"
					value=<%=player.getEmailAddress()%> /> <input type="submit"
					class="login-submit" value="Count me in!">

			</form>
		</div>
		<%
			}
		%>
		<div>
			<form action="Logout">

				<input type="submit" class="login-submit" value="Logout">

			</form>
		</div>
	</div>


</body>

</html>