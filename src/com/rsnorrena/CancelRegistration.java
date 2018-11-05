package com.rsnorrena;

import java.io.IOException;
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
 * Servlet implementation class CancelRegistration
 */
@WebServlet("/CancelRegistration")
public class CancelRegistration extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(CancelRegistration.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CancelRegistration() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("CancelRegistration called");
		
		//retrieve variables
		String email = request.getParameter("email");
		
		//check if player canceling registration is a goalie
		Player player = CRUD.getRecord(email);
		
		String emailOfPlayerOnWaitList = request.getParameter("emailOfPlayerOnWaitList");
		
		//change registration status of current player and reset the player index
		CRUD.updateRegistration(email, false, "TBD", 99);
		log.info(player.getFirstName() + " " + player.getLastName() +"'s registration has been cancelled.");
		
		//canceling player is a skater and there is a player on the waitlist.
		if((player.getPosition().equals("Forward") || player.getPosition().equals("Defense")) && emailOfPlayerOnWaitList != null && emailOfPlayerOnWaitList.contains("@")){
			
			int index = Integer.valueOf(request.getParameter("index"));
			
			// registered first waitlist player and change status to confirmed
			CRUD.updateRegistration(emailOfPlayerOnWaitList, true, "Confirmed", index);
			log.info("The first skater on the waitlist has been moved into the roster");
			
			//set email parameter to be passed to send email notification
			request.setAttribute("sendEmailTo", emailOfPlayerOnWaitList);
			request.setAttribute("pageDirect", "index.jsp");
			request.setAttribute("emailRequest", "waitlistPlayerMoved");
			request.setAttribute("emailSubject", "Friday Night Hockey - Status Change");
			
			RequestDispatcher rd = request.getRequestDispatcher("SendMail");
			rd.forward(request,response);
			
		}else if(player.getPosition().equals("Goalie")){
			
			//set email parameter to be passed to send email notification
			request.setAttribute("sendEmailTo", "snorrena@gmail.com");//notification email for a goalie cancellation should go to the admin
			request.setAttribute("pageDirect", "index.jsp");
			request.setAttribute("emailRequest", "goalieCancelled");
			request.setAttribute("emailSubject", "Friday Night Hockey - Goalie Cancellation");
			
			//set the goalie name and pass as an attribute
			String goalieName = player.getFirstName() + " " + player.getLastName();
			request.setAttribute("goalieName", goalieName);
			
			RequestDispatcher rd = request.getRequestDispatcher("SendMail");
			rd.forward(request,response);
		
		}else{
			HttpSession session = request.getSession();
			
			session.removeAttribute("email");
			session.removeAttribute("uname");
			
			String msg = "Thanks " + (String) session.getAttribute("username") 
			+ "!-<br/>-<br/>-Your request has been processed and your spot "
			+ "has been released to another skater.-<br/>-<br/>-See you next week.-<br/>-<br/>-The Management";
			
			session.setAttribute("userMessage", msg); 
			
			//send user to a page that confirms registration cancellation
			response.sendRedirect("index.jsp");
			
		}
	}

}
