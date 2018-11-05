package com.rsnorrena;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.rsnorrena.data.Player;
import com.rsnorrena.database.CRUD;

/**
 * Servlet implementation class SendGroupMail
 */
@WebServlet("/SendGroupMail")
public class SendGroupMail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendGroupMail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		String emailRequest = request.getParameter("emailRequest");
		String groupMailMessage = request.getParameter("groupMailMessage");
		String emailSubject = request.getParameter("emailSubject");
		
		ArrayList<Player> playerList = CRUD.getAllPlayers();
		
		ArrayList<String> emailList = new ArrayList<String>();
		
		//build distribution list for group email
		for(Player player:playerList){
			emailList.add(player.getEmailAddress());
		}
		
		request.setAttribute("emailRequest", emailRequest);
		request.setAttribute("sendEmailTo", emailList);
		request.setAttribute("pageDirect", "admin.jsp");
		request.setAttribute("groupMailMessage", groupMailMessage);
		request.setAttribute("emailSubject", emailSubject);
		
		RequestDispatcher rd = request.getRequestDispatcher("SendMail");
		rd.forward(request,response);
		
		
	}

	

}
