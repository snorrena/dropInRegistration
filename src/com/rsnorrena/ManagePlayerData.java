package com.rsnorrena;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.rsnorrena.data.Player;
import com.rsnorrena.database.CRUD;

/**
 * Servlet implementation class ManagePlayerData
 */
@WebServlet("/ManagePlayerData")
public class ManagePlayerData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(ManagePlayerData.class);
	
	String playerStatus = "";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ManagePlayerData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("ManagePlayerData called");
		
		String dataChangeRequest = "";
		
		String firstName = "";
		String lastName = "";
		String password = "";
		boolean isRegistered;
		String email = "";
		String playerPosition = "";
		String emailOfPlayerOnWaitlist = "";
		
		int skaterCount = 0;
		int waitlistCount = 0;
		int goalieCount = 0;
		int highestValueIndex = 0;
		int registeredPlayerIndex = 0;
		
		boolean sendMail = false;
		boolean indexChange = false;
		
		HttpSession session = request.getSession();
		session.setAttribute("userMessage", "");
		
		//code to send back to index if invalid access
		if(session.getAttribute("uname") == null){
			String msg = "Login Error:-<br/>-<br/>-Invalid user name and/or password.";
			session.setAttribute("userMessage", msg); 
			
			response.sendRedirect("index.jsp");
		}
		//check for type of request send from the html maintenance form. (add, update, delete)		
		dataChangeRequest = request.getParameter("dataChange");
		
		firstName = request.getParameter("firstName");
		lastName = request.getParameter("lastName");
		password = request.getParameter("password");
		isRegistered = request.getParameter("registrationStatus").equals("true") ? true:false;
		email = request.getParameter("email");
		playerPosition = request.getParameter("playerPosition");
		playerStatus = request.getParameter("playerStatus");
		
		log.info("Form data");
		log.info("---------");
		log.info("dataChangeRequest: " + dataChangeRequest);
		log.info("firsName: " + firstName);
		log.info("lastName: " + lastName);
		log.info("password: " + password);
		log.info("isRegistered: " + isRegistered);
		log.info("email: " + email);
		log.info("playerPosition: " + playerPosition);
		log.info("playerStatus: " + playerStatus);
		
		
		//get the list of players from the database.
		ArrayList<Player> allPlayers = CRUD.getAllPlayers();
		
		//sort the collection by index value ascending.
		Collections.sort(allPlayers, Player.indexComparator);
		
		//loop through the collection starting with the player with the lowest value of index.
		for(Player player: allPlayers){
			
			//collect the email address of the first player on the waitlist.
			if(player.getStatus().equals("Waitlist") && emailOfPlayerOnWaitlist.equals("")){
				emailOfPlayerOnWaitlist = player.getEmailAddress();
			}
			
			//set boolean testing whether or not to reset the index.
			if(player.getEmailAddress().equals(email)){
				
				if(isRegistered == true){
					if(player.getIndex() == 99){//if the registration status is set to true and the index is the default value set index to next spot.
						//the next index value is calculated inside this loop and set on completion.
						indexChange = true;
					}else{
						//the player index will remain unchanged if the registration status is also unchanged.
						registeredPlayerIndex = player.getIndex();
					}
				//player registration status is false so the index is reset to default	
				}else{
					registeredPlayerIndex = 99;
				}
			}
			
			if(player.isRegistered()){
				
				//while looping through the player list collect the highest value index to determine the next index value to be set.
				if(player.getIndex() > highestValueIndex){
					highestValueIndex = player.getIndex();
				}
				
				//collect count values of confirmed skaters and goalies.
				if(player.getStatus().equals("Confirmed")){
					
					if((player.getPosition().equals("Forward") || player.getPosition().equals("Defense"))){
						++skaterCount;
					}
					if(player.getPosition().equals("Goalie")){
						++goalieCount;
					}
				}
				
				//collect count of waitlist players.
				if(player.getStatus().equals("Waitlist")){
					++waitlistCount;
				}
			}
		}//end for loop
		log.info("The highest value player index # is " + highestValueIndex);
		log.info("Registered: Goalies:" + goalieCount + ", Skaters:" + skaterCount + ", Waitlist:" + waitlistCount);
		log.info("Email of the first player on the waitlist: " + emailOfPlayerOnWaitlist);
		
		/*
		 * if add of a new skater and registrations is true then add to next highest index.
		 * Otherwise, the player data is entered into the system and the index set to the default value.
		 */
		if(dataChangeRequest.equals("add")){
			if(isRegistered == true){
				indexChange = true;
			}else{
				registeredPlayerIndex = 99;
			}
		}
		
		
		//set index to next value if player status is changed to registered.
		if(indexChange){
			registeredPlayerIndex = ++highestValueIndex;
		log.info("Index changed: " + registeredPlayerIndex);
		}
		
		
		//pull data parameters from request obj, validate and process change request
		//set user message (success or failure) and return to the maintenance page
		String dataUpdateMessage = "";
		
		//request for update
		if(dataChangeRequest.equals("update")){
			log.info("update called");
			
			//check for valid email
			if(CRUD.playerCheck(email)){
				log.info("Email provided is valid");
				
					dataUpdateMessage = verifyRequest(playerStatus, playerPosition, firstName, lastName, dataUpdateMessage
							, skaterCount, waitlistCount, goalieCount, dataChangeRequest, sendMail);
					log.info("dataUpdateMessage = " + dataUpdateMessage);
					
				//invalid email entered	
			}else{
					dataUpdateMessage = "Error: The user email does not exist in the database!";
					log.info("dataUpdateMessage = " + dataUpdateMessage);
				}
			
				//execute the update if the dataUpdate message does not contain the word 'Error'.
			if( !dataUpdateMessage.contains("Error")){
				
				CRUD.updateRecord(firstName, lastName, password, isRegistered, email,
					playerPosition, playerStatus, registeredPlayerIndex);
				}
		
		//request is a player addition	
		}else if(dataChangeRequest.equals("add")){
			log.info("add request called");
			
			//check if email exists in the database
			if(!CRUD.playerCheck(email)){
				log.info("email given does not exist in the database player may be added");
				
				//check registration status in here. 
				dataUpdateMessage = verifyRequest(playerStatus, playerPosition, firstName, lastName, dataUpdateMessage
						, skaterCount, waitlistCount, goalieCount, dataChangeRequest, sendMail);
				log.info("dataUpdateMessage = " + dataUpdateMessage);
				
				//execute the update if the dataUpdate message does not contain the word 'Error'.
				if( !dataUpdateMessage.contains("Error")){

					CRUD.insertRecord(firstName, lastName, password, isRegistered, email,
							playerPosition, playerStatus, registeredPlayerIndex);
				}
				
			//email already exists in the system	
			}else{
				dataUpdateMessage = "Error: The user email already exists in the database!";
				log.info("dataUpdateMessage = " + dataUpdateMessage);
			}
		//request is for player deletion	
		}else if(dataChangeRequest.equals("delete")){
			log.info("delete request called");
			
			if(CRUD.playerCheck(email)){
				log.info("email given is valid");
				CRUD.deleteRecord(email);
				dataUpdateMessage = "Record Deleted! " + firstName + " " + lastName + "'s information has been removed from the database";
				log.info("dataUpdateMessage = " + dataUpdateMessage);
			}else{
				dataUpdateMessage = "Error: The user email does not exist in the database!";
				log.info("dataUpdateMessage = " + dataUpdateMessage);
			}
		}
		//player status is TBD change request is simple data update
		if(dataUpdateMessage.equals("")){
			dataUpdateMessage = "Update Complete!";
			log.info("dataUpdateMessage = " + dataUpdateMessage);
		}

		//get an updated list after changes are completed.
		allPlayers = CRUD.getAllPlayers();
		
		int confirmedPlayers = 0;
		
		for(Player player:allPlayers){
			if(player.getStatus().equals("Confirmed")){
				
				//count of the confirmed skaters
				if((player.getPosition().equals("Forward") || player.getPosition().equals("Defense"))){
					++confirmedPlayers;
				}
			}
		}
		
		log.info("Confirmed skaters before test for add of a waitlist player = " + confirmedPlayers);
		if(confirmedPlayers < 20){//check if there is space then move a waitlist player and send email notification.
			
			
			if(emailOfPlayerOnWaitlist != ""){
				
				Player player = CRUD.getRecord(emailOfPlayerOnWaitlist);
				log.info("Waitlist player index = " + player.getIndex());
				
				CRUD.updateRegistration(emailOfPlayerOnWaitlist, true, "Confirmed", player.getIndex());
				dataUpdateMessage = dataUpdateMessage + " " + player.getFirstName() + " " + player.getLastName() + " has been moved from the "
						+ "waitlist into the active roster and an email has been sent notifying of the status change.";
				log.info("dataUpdateMessage = " + dataUpdateMessage);
				sendMail = true;
			}
		}
		
		//set the user message to a session variable
		session.setAttribute("userMessage", dataUpdateMessage);
		
		if(sendMail){
			
			request.setAttribute("sendEmailTo", emailOfPlayerOnWaitlist);
			request.setAttribute("pageDirect", "maintenance.jsp");
			request.setAttribute("emailRequest", "waitlistPlayerMoved");
			request.setAttribute("emailSubject", "Friday Night Hockey");
			
			RequestDispatcher rd = request.getRequestDispatcher("SendMail");
			rd.forward(request,response);	
		}else{
			session.setAttribute("userMessage", dataUpdateMessage); 
			response.sendRedirect("maintenance.jsp");
		}
		
	}


	private String verifyRequest(String playerStatus, String playerPosition, String firstName
			, String lastName, String dataUpdateMessage, int skaterCount, int waitlistCount, int goalieCount
			, String dataChangeRequest, boolean sendMail) {
		
		log.info("Verifying data change request based on input data parameters");
		
		
		if(dataChangeRequest.equals("add")){
			
				if(playerPosition.equals("Goalie")){
						
					if(playerStatus.equals("Confirmed")){
							
						if(goalieCount < 2){
							dataUpdateMessage = "Addition Complete: " + firstName + " " + lastName + "'s information has been added into the "
									+ "database and is now registered to play in the next game.";
						}else{//two goalies are registered
							dataUpdateMessage = "Notice: " + firstName + " " + lastName + "'s information has been added into"
									+ " the database, however there are already " + goalieCount + " goalies registered to"
											+ " play in the next session.";
							//status is changed because there are already to goalies scheduled to play
							this.playerStatus = "TBD";
						}
						
					}else{//add Goalie to the database status is TBD
						dataUpdateMessage = "Addition Complete: " + firstName + " " + lastName + "'s information has been added into the "
								+ "database.";
					}
					
				}else{//player is a skater
					
						if(playerStatus.equals("Confirmed")){
							//check for space and change status and message as needed
							
							if(skaterCount == 20 && waitlistCount == 4){
								dataUpdateMessage = "Notice: " + firstName + " " + lastName + "'s information has been added into"
										+ " the database, however, there are already " + skaterCount + " skaters registered to"
												+ " play in the next session and the waitlist is full.";
								playerStatus = "TBD";
							}else if(skaterCount == 20 && waitlistCount < 4){
								dataUpdateMessage = "Notice: " + firstName + " " + lastName + "'s information has been added into"
										+ " the database, however there are already " + skaterCount + " skaters registered to"
												+ " play in the next session. "
									+ firstName + " has been added to the waitlist and will be notified by email if a spot comes available.";
									//player status is changed to waitlist
									this.playerStatus = "Waitlist";
							}else if(skaterCount < 20){	
								dataUpdateMessage = "Addition Complete: " + firstName + " " + lastName + " has been added into the "
										+ "database and registered to play in the next game.";
							}	
							
						}else{//simple addition and player status is TBD
							
							dataUpdateMessage = "Addition Complete: " + firstName + " " + lastName + "'s information has been added into the "
									+ "database.";
						}
					
				}
			
		}else{//data change request is an update
			
				if(playerPosition.equals("Goalie")){
						
						if(playerStatus.equals("Confirmed")){
							
								if(goalieCount < 2){
									dataUpdateMessage = "Update Complete: " + firstName + " " + lastName + " has been "
											+ "registered to play in the next game.";
								}else{//two goalies are already booked
									dataUpdateMessage = "Error: There are already " + goalieCount + " goalies registered to"
													+ " play in the next session.";
								}
							
						}else{//simple data update and player status is TBD
							dataUpdateMessage = "Update Complete: " + firstName + " " + lastName + "'s information has been changed in the "
									+ "database.";
						}
					
				}else{//player is a skater
					
						if(playerStatus.equals("Confirmed")){
							
							if(skaterCount == 20 && waitlistCount == 4){
								dataUpdateMessage = "Error: There are already " + skaterCount + " skaters registered to"
												+ " play in the next session and the waitlist is full.";
							}else if(skaterCount == 20 && waitlistCount < 4){
								dataUpdateMessage = "Notice: " + firstName + " " + lastName + "'s information has been updated"
										+ " in the database, however, there are already " + skaterCount + " skaters registered to"
												+ " play in the next session. " + firstName + " has been added to the waitlist"
														+ " and will be notified by email if a spot comes available.";
									//player status is changed to waitlist
									this.playerStatus = "Waitlist";
							}else if(skaterCount < 20){	
								dataUpdateMessage = "Update Complete: " + firstName + " " + lastName + " is now registered to play in the next game.";
							}	
						
						}else{//player status is TBD
							dataUpdateMessage = "Update Complete: " + firstName + " " + lastName + "'s information"
									+ " has been updated in the database.";
						}
					
				}
			
		}
		
		return dataUpdateMessage;
	}
}
