package com.rsnorrena;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.rsnorrena.database.CRUD;
import com.rsnorrena.util.DateOfNextGame;
import com.rsnorrena.data.Player;
import org.apache.log4j.Logger;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	static Logger log = Logger.getLogger(Login.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
//		log.trace("Hello World!");
//		log.debug("How are you today?");
//		log.info("I am fine.");
//		log.error("I am programming.");
//		log.warn("I love programming.");
//		log.fatal("I am now dead. I should have been a movie star.");
		log.info("Login called");
		
		HttpSession session = request.getSession();
		
			//retrieve the user name and password passed in through the html form
			String uname = request.getParameter("uname");
			String pass = request.getParameter("pass");
			
			//retrieve the isMobile variable from the html form
			boolean isMobile = request.getParameter("isMobile").equals("true") ? true: false;
			log.info("Session isMobile = " + isMobile);
			
			//set of a session variable to determine if viewing on a mobile device
			if(isMobile){
				session.setAttribute("isMobile", true);
			}else{
				session.setAttribute("isMobile", false);
			}
			
			//check email as user name here. prompt for set of a new password and save in the database if not already set.
			//generate a list of registered players and pass on to the welcome jsp for detail display.

			// The login method of the class CRUD checks if the user name and password exist in the database.
			if (CRUD.login(uname, pass) > 0) {
				log.info("User name:" + uname + " login was successful!");
				
				String date = DateOfNextGame.getDateOfNextGame();
				int daysToNextGame = DateOfNextGame.getNumberOfDaysToNextGame();
				
				//the getRecord method of class CRUD returns the player object associated with
				//the passed in uname/email parameter
				Player currentPlayer = CRUD.getRecord(uname);
				
				session.setAttribute("username", currentPlayer.getFirstName());
				session.setAttribute("uname", currentPlayer.getEmailAddress());
				//				session.setAttribute("pass", currentPlayer.getPassword());
				session.setAttribute("userMessage", null);
				session.setAttribute("isregistered", new Boolean(currentPlayer.isRegistered()));
				session.setAttribute("email", currentPlayer.getEmailAddress());
				session.setAttribute("date", date);
				session.setAttribute("daysToNextGame", daysToNextGame);

				if (uname.equals("admin")) {
					//user is an administrator 
					if(isMobile){
						request.getRequestDispatcher("admin.jsp").forward(request, response);
					}else{
						request.getRequestDispatcher("admin.jsp").forward(request, response);
					}
				}else{
					
					if(isMobile){
						request.getRequestDispatcher("m.welcome.jsp").forward(request, response);
					}else{
						request.getRequestDispatcher("welcome.jsp").forward(request, response);
					}
				}

			} else {
				// send the user back to the login page if an incorrect user name and password are entered
//				String msg = "Login Error:-<br/>-<br/>-Invalid user name and/or password.";
				String msg = "Login Error: Invalid user name and/or password.";
				session.setAttribute("userMessage", msg); 
				
				response.sendRedirect("index.jsp");
				
			}
	}
}
