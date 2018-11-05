package com.rsnorrena;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.rsnorrena.data.Player;
import com.rsnorrena.database.CRUD;
import com.rsnorrena.util.DateOfNextGame;

/**
 * Servlet implementation class SubmitRegistration
 */
@WebServlet("/SubmitRegistration")
public class SubmitRegistration extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(SubmitRegistration.class);

	Player currentPlayer = null;
	Player player = null;
	int skaterCount, goalieCount, waitListCount, playerRegistrationIndex;
	boolean isMobile = false;
	
	
	HttpServletRequest request;
	HttpServletResponse response;

	/**
	 * 
	 * @see HttpServlet#HttpServlet()
	 */
	public SubmitRegistration() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("SubmitRegistration called");
		
		HttpSession session = request.getSession();
		
		this.request = request;
		this.response = response;
		
		// get the user email from the calling jsp
		String email = request.getParameter("email");
		isMobile = request.getParameter("isMobile").equals("true") ? true: false;

		// get the player obj from the database using the user email
		currentPlayer = CRUD.getRecord(email);

		// get the list of players
		ArrayList<Player> playerList = CRUD.getAllPlayers();

		// initialize count variables
		goalieCount = 0;
		skaterCount = 0;
		waitListCount = 0;
		playerRegistrationIndex = 0;

		// iterate through the list of players and count goalies and players registered for the current session and determine the next registration index.
		for (Player player : playerList) {

			//if the player index value is greater than the current value of playerRegistrationIndex set a new value.
			if (player.isRegistered() == true && player.getIndex() > playerRegistrationIndex) {
				playerRegistrationIndex = player.getIndex();
			} 
			
			//collect count of registered and confirmed goalies and skaters
			if (player.isRegistered() == true && player.getStatus().equals("Confirmed")) {
				
				//if player is a goal tender augment the goalie count.
				if (player.getPosition().equals("Goalie")) {
					++goalieCount;
				//player is a skater so augment the playerCount	
				} else {
					++skaterCount;
				}

			} else if (player.isRegistered() == true && player.getStatus().equals("Waitlist")) {
				++waitListCount;
			}
		}
		
		log.info("The highest value player index is: " + playerRegistrationIndex);
		
		log.info("Registered: Goalies:" + goalieCount + ", Skaters:" + skaterCount + ", Waitlist:" + waitListCount);
		
		if (currentPlayer.getPosition().equals("Forward") || currentPlayer.getPosition().equals("Defense")) {

			if (skaterCount < 20) {
				log.info("Skater is added to the roster");
				
				// registered player and change status to confirmed and set to next registration index
				CRUD.updateRegistration(currentPlayer.getEmailAddress(), true, "Confirmed", ++playerRegistrationIndex);
				
				goToRegistrationConfirmationPage(request, response);
				
			} else {
				
				// roster is full add player to the waitlist
				if (waitListCount < 4) {
					log.info("Skater is added to he waitlist");

					//register player and change status to wait list and set to next registration index
					CRUD.updateRegistration(currentPlayer.getEmailAddress(), true, "Waitlist", ++playerRegistrationIndex);
					// update display
					goToRegistrationConfirmationPage(request, response);
				
				} else {
					log.info("Skater is advised that the roseter and waitlist are full");
					// advise that the waitlist is full
					String msg = "Sorry " + (String) session.getAttribute("username") 
						+ ",-<br/>-<br/>-The roster is full and there are already four skaters "
							+ "on the waitlist.-<br/>-<br/>-See you next week.-<br/>-<br/>-The Management";
					
					session.setAttribute("userMessage", msg); 
					response.sendRedirect("index.jsp");
				}
			}

			// player is a goalie
		} else {

			if (goalieCount < 2) {
				log.info("Goalie is add to the roster");
				// register goalie and change status to confirmed and set to next registration index
				CRUD.updateRegistration(currentPlayer.getEmailAddress(), true, "Confirmed", ++playerRegistrationIndex);
				// update display
				goToRegistrationConfirmationPage(request, response);
			} else {
				log.info("Goalie is advised that two goalies are alrealdy registered");
				
				String msg = "Sorry " + (String) session.getAttribute("username") 
				+ ",-<br/>-<br/>-There are already two goalies scheduled to play in " 
						+ "the next session.-<br/>-<br/>-See you next week.-<br/>-<br/>-The Management";
				
				session.setAttribute("userMessage", msg); 
				response.sendRedirect("index.jsp");
			}

		}
	}

	private void goToRegistrationConfirmationPage(HttpServletRequest request2, HttpServletResponse response2) {
		
		//get a refreshed list of players
		ArrayList<Player> allPlayers = CRUD.getAllPlayers();
		
		//collect and add new data to the request obj
		String date = DateOfNextGame.getDateOfNextGame();
		int daysToNextGame = DateOfNextGame.getNumberOfDaysToNextGame();
		
		request2.setAttribute("isregistered", new Boolean(currentPlayer.isRegistered()));
		request2.setAttribute("email", currentPlayer.getEmailAddress());
		request2.setAttribute("date", date);
		request2.setAttribute("daysToNextGame", daysToNextGame);
		request2.setAttribute("playerList", allPlayers);
		request2.setAttribute("registrationRequestSubmitted", "registrationRequestSubmitted");
		
		// update display
		try {
			if(isMobile){
				request.getRequestDispatcher("m.welcome.jsp").forward(request2, response2);
			}else{
				
				request.getRequestDispatcher("welcome.jsp").forward(request2, response2);
			}
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
