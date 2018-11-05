package com.rsnorrena;

import java.io.IOException;
import java.util.ArrayList;

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
 * Servlet implementation class PasswordRecovery
 */
@WebServlet("/PasswordRecovery")
public class PasswordRecovery extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(PasswordRecovery.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PasswordRecovery() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("PasswordRecovery called");
		
		HttpSession session = request.getSession();
		
		String emailAddress = (String) request.getParameter("emailAddress");
		
		ArrayList<Player> playerList = CRUD.getAllPlayers();
		
		String validPassword = "";
		String firstName = "";
		
		for(Player player:playerList){
			if(player.getEmailAddress().equals(emailAddress)){
				validPassword = player.getPassword();
				firstName = player.getFirstName();
			}
		}
		
		log.info("The recovered password is: " + validPassword);
		
		String userMessage = "";
		
		if(validPassword != ""){
			request.setAttribute("sendEmailTo", emailAddress);
			request.setAttribute("pageDirect", "index.jsp");
			request.setAttribute("emailRequest", "passwordRecovery");
			userMessage = "Thanks " + firstName + "!<br><br>Your password has been sent to your email address.";
			session.setAttribute("userMessage", userMessage);
			
			RequestDispatcher rd = request.getRequestDispatcher("SendMail");
			rd.forward(request,response);
		}else{
			userMessage = "Error: The email address you entered \"" + emailAddress + "\" does not exist in the database."
					+ " Please contact the webmaster for further assistance.<br><br>"
					+ "<a href=\"mailto:snorrena@gmail.com\" style='color: white;'>snorrena@gmail.com</a>";
			session.setAttribute("userMessage", userMessage);
			request.getRequestDispatcher("passwordRecovery.jsp").forward(request, response);
		}
		
	}

}
