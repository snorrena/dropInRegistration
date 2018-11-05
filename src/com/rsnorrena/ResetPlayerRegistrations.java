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
 * Servlet implementation class ResetPlayerRegistrations
 */
@WebServlet("/ResetPlayerRegistrations")
public class ResetPlayerRegistrations extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(ResetPlayerRegistrations.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ResetPlayerRegistrations() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("ResetPlayerRegistrations called");
		
		HttpSession session = request.getSession();
		
		boolean isMobile = session.getAttribute("isMobile").equals("true") ? true: false;
		
		ArrayList<Player> allPlayers = CRUD.getAllPlayers();

		for(Player player:allPlayers){
//			if (player.isRegistered()) {
				player.setRegistered(false);
				player.setStatus("TBD");
				player.setIndex(99);
				CRUD.updateRegistration(player.getEmailAddress(), false, "TBD", 99);
//			}
		}
		
		request.setAttribute("playerList", allPlayers);
		
		if(isMobile){
			request.getRequestDispatcher("m.admin.jsp").forward(request, response);
		}else{
			request.getRequestDispatcher("admin.jsp").forward(request, response);
		}
		
		
		
	}

	
}
