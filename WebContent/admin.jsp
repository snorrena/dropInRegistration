<%@ page import="java.util.*"%>
<%@ page import="com.rsnorrena.data.Player"%>
<%@ page import="com.rsnorrena.database.CRUD"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="org.apache.log4j.Logger"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- js method to confirm a reset request -->
<script>

function resetCheck() {
    
    var confirmation = confirm("Are you sure?");
    
    if (confirmation == true) {
         return true;
    }else{
    	return false;
    }
}

</script>


<title>Administration</title>
<link rel="stylesheet" href="css/style.css">
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

	<%-- the session attribute is used to confirm successful login.
If not, the user is send back to the login jsp --%>

<%
Logger log= Logger.getLogger("admin.jsp");
log.info("admin.jsp called");
%>

	<%
	
		session = request.getSession();
	
		if ((String) session.getAttribute("uname") == null) {%>
		
		<jsp:forward page="index.jsp"/>
		
		<% }
	%>

	<div class="login" style="color:white">

		<h1>Friday Night Hockey - Britania Rink @ Commercial Drive, 11:15
			PM</h1>

		Welcome to the Friday Night Hockey administration page!
		
		<br></br>

		<%
			int daysToNextGame = (int) session.getAttribute("daysToNextGame");

			String dateOfNextGame = (String) session.getAttribute("date");

			boolean isRegistered = false;

			String email = (String) session.getAttribute("email");

			Player currentPlayer = null;

			String currentUser = "";
			String emailOfPlayerOnWaitList = "";

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

			//ArrayList<?> registeredPlayers = null;

			//if (obj instanceof ArrayList<?>) {
				//registeredPlayers = (ArrayList<?>) obj;
			//}

			int playerIndex = 0;
			int goalieIndex = 0;
			int waitListIndex = 0;
			int goalieCount = 0;
			int skaterCount = 0;
			int totalNumberRegisteredPlayers = 0;
			
			//ArrayList<Player> playerListTemp = new ArrayList<Player>();
			ArrayList<Player> playerListTemp = CRUD.getAllPlayers();;
			
			//for(Object objTemp:registeredPlayers){
				//if(objTemp instanceof Player){
					//Player p = (Player)objTemp;
					//playerListTemp.add(p);
				//}
			//}
			//sort the collect so that the player will display in order of index	
			Collections.sort(playerListTemp, Player.indexComparator);
			
			//Only process if the arraylist has elements
			if(!playerListTemp.isEmpty()){
				
				for (Player playerObj : playerListTemp) {
					
						currentPlayer = (Player) playerObj;
					
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
						}

						waitList[waitListIndex++] = playerName;
						++waitListCount;
					}

				}	
				
				
			}

			
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
		<%=dateOfNextGame%>
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

	<div class="login" style="height:200px">
		<H1>Player registrations for the current session</H1>

		
		<%-- start new table data here --%>
		
		<table style="width:100%; color:white;">
		
		<tr>
			<th></th>
			<th align="left"><u><font color="ffffff">Goalies:</font></u></th>
			<th></th>
			<th align="left"><u><font color="ffffff">Players:</font></u></th>
			<th></th>
			<th></th>	
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th align="left"><u><font color="ffffff">Waitlist:</font></u></th>
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
	<div class="login">
	
	<table class="center">
	
		<tr>
	
			<td class="pr">
				<form action="ResetPlayerRegistrations" onsubmit="return resetCheck()">

					<input type="submit" class="login-submit" value="Reset Registrations" >

				</form>
			</td>
			
			<td class="pr">
				<form action="emailInvite.jsp">

					<input type="submit" class="login-submit" value="Email - New Session">

				</form>
			</td>
			
			<td class="pr">
				<form action="emailUpdate.jsp">

					<input type="submit" class="login-submit" value="Email - Roster Status">

				</form>
			</td>
			
			<td class="pr">
				<form action="maintenance.jsp">

				<input type="submit" class="login-submit" value="Maintenance">

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