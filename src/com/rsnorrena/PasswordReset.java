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

/**
 * Servlet implementation class PasswordRecovery
 */
@WebServlet("/PasswordReset")
public class PasswordReset extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(PasswordReset.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PasswordReset() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("PasswordReset called");
		
		HttpSession session = request.getSession();
		
		String emailAddress = (String) request.getParameter("emailAddress");
		String currentPassword = (String) request.getParameter("password");
		String newPassword = (String) request.getParameter("password1");
		
		
		String firstName = "";
		boolean validCurrentPassword = false;
		boolean validEmail = false;
		boolean passwordReset = false;
		
		ArrayList<Player> playerList = CRUD.getAllPlayers();
		
		for(Player player:playerList){
			if(player.getEmailAddress().equals(emailAddress)){
				validEmail = true;
				if(player.getPassword().equals(currentPassword)){
					validCurrentPassword = true;
					passwordReset = true;
				}
				
				firstName = player.getFirstName();
				
				CRUD.updateRecord(firstName, player.getLastName(), newPassword, player.isRegistered(), player.getEmailAddress(),
						player.getPosition(), player.getStatus(), player.getIndex());
				log.info("The reset password is: " + newPassword);
			}
		}
		
		
		String userMessage = "";
		
		if(passwordReset){
			userMessage = "Thanks " + firstName + "!<br><br> Your password has been reset.<br><br>"
					+ "Please login and registered to play in the next game.";
			session.setAttribute("userMessage", userMessage);
			
			request.getRequestDispatcher("index.jsp").forward(request, response);
		}else{
			if(validEmail && !validCurrentPassword){
				
				userMessage = "Error: The current password entered is incorrect.<br><br>"
						+ " Please 	contact the webmaster for further assistance<br><br>"
						+ "<a href=\"mailto:snorrena@gmail.com\" style='color: white;'>snorrena@gmail.com</a>";
				
			}else{
				userMessage = "Error: The email address you entered \"" + emailAddress + "\" "
						+ "does not exist in the database. <br><br>"
						+ "Please contact the webmaster "
						+ "for further assistance.<br><br>"
						+ "<a href=\"mailto:snorrena@gmail.com\" style='color: white;'>snorrena@gmail.com</a>";
			}
			session.setAttribute("userMessage", userMessage);
			request.getRequestDispatcher("passwordReset.jsp").forward(request, response);
		}
		
	}

}
