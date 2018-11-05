package com.rsnorrena;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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
 * Servlet implementation class SendMail
 */
@WebServlet("/SendMail")
public class SendMail extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static Logger log = Logger.getLogger(SendMail.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendMail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.info("SendMail called");
		
		//messages are sent from my gmail account
		final String username = "snorrena";
		final String password = "51Tangynorgm";
		
		//ArrayList to hold the email distribution list
		ArrayList<String> toList = new ArrayList<String>();
		String to = "";
		Player currentPlayer = null;
		
		//collect the email message text body from the calling jsp
		String emailRequest = (String) request.getAttribute("emailRequest");
		log.info("The email request attribute is: " + emailRequest);
		
		if(emailRequest.equals("groupEmail")){
			toList = (ArrayList<String>) request.getAttribute("sendEmailTo");
			
			log.info("Contents of the email distribution list: " + toList.toString());
			
			//reset while testing
			toList.clear();
			toList.add("snorrena@hotmail.com");
			toList.add("snorrena@gmail.com");
//			toList.add("natejohn@telus.net");
			
		}else{
			to = (String) request.getAttribute("sendEmailTo");
			String test = to;
			log.info("Email recipient: " + to);
			//reset while testing
			to = "snorrena@gmail.com";
//			to = "natejohn@telus.net";
			
			//get a player obj by reference to the passed in email address
			//change parameter back to 'to' for production.
			currentPlayer = CRUD.getRecord(test);
			
		}
		
		//collect page to return to after send of email
		String pageDirect = (String) request.getAttribute("pageDirect");
		
		String from = "snorrena@gmail.com";
		String subject = (String) request.getAttribute("emailSubject");
		
		String body = "";
		
		if (emailRequest.equals("waitlistPlayerMoved")) {
			body = "Hi " + currentPlayer.getFirstName() + "! \n\n" + "A spot has opened up and you have been added to the roster"
					+ " to play hockey on " + DateOfNextGame.getDateOfNextGame() + ".\n\n"
					+ "If for any reason you are unable to attend, please click on the link below "
					+ "to cancel and release your place to the next skater on the wait list.\n\n"
					+ "\'http://snorrena.getmyip.com:8080/DropInRegistration/\'\n\n" + "Thanks\n\n" + "The management";
		}else if(emailRequest.equals("passwordRecovery")){
			body = "Hi " + currentPlayer.getFirstName() + "! \n\n" + "Your password is:  \"" + currentPlayer.getPassword() + "\"\n\n"
					+ "Click on the link below to login and register to play in the next game.\n\n"
					+ "\'http://snorrena.getmyip.com:8080/DropInRegistration/\'\n\n" + "Thanks\n\n" + "The management";
		}else if (emailRequest.equals("goalieCancelled")){
			
			//retrieve the goalie name from the request
			String goalieName = (String) request.getAttribute("goalieName");
			
			body = "Hi " + "Nate" + "! \n\n" + "Please note that goalie " + goalieName
					+ " has cancelled his registration for the game on " + DateOfNextGame.getDateOfNextGame()
					+ " and will need to be replaced!\n\n" + "Thanks\n\n" + "The management";
		}else{
			body = (String) request.getAttribute("groupMailMessage");
			body = body.replaceAll("<br>", "");
		}

		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session msgSession = Session.getInstance(props, new javax.mail.Authenticator(){
			protected PasswordAuthentication getPasswordAuthentication(){
				return new PasswordAuthentication(username, password);
			}
		});
		
		//if the email is to the group then loop through the distribution list to send to all otherwise send to the individual.
		if (emailRequest.equals("groupEmail")) {
			for (String email : toList) {
				try {
					Message msg = new MimeMessage(msgSession);
					msg.setFrom(new InternetAddress(from));
					InternetAddress[] address = { new InternetAddress(email) };
					msg.setRecipients(Message.RecipientType.TO, address);
					msg.setSubject(subject);
					msg.setSentDate(new Date());
					msg.setText(body);

					// Hand the message to the default transport service
					// for delivery.

					Transport.send(msg);

				} catch (AddressException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (MessagingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} 
		}else{
			try {
				Message msg = new MimeMessage(msgSession);
				msg.setFrom(new InternetAddress(from));
				InternetAddress[] address = { new InternetAddress(to) };
				msg.setRecipients(Message.RecipientType.TO, address);
				msg.setSubject(subject);
				msg.setSentDate(new Date());
				msg.setText(body);

				// Hand the message to the default transport service
				// for delivery.

				Transport.send(msg);

			} catch (AddressException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (MessagingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}//end of if statement
		
		HttpSession session = request.getSession();
		
		
		//send the user back to the appropriate jsp
		if(pageDirect.equals("maintenance.jsp")){
			
			response.sendRedirect("maintenance.jsp");
			
		}else if(emailRequest.equals("passwordRecovery")){
			
			response.sendRedirect("index.jsp");
			
		}else if(emailRequest.equals("groupEmail")){
			
			response.sendRedirect("admin.jsp");
			
		}else{
			
			session.removeAttribute("email");
			session.removeAttribute("uname");
			
			String msg = "";
			
			if(emailRequest.equals("goalieCancelled")){
				msg = "Thanks " + (String) session.getAttribute("username") + ",-<br/>-<br/>-Your request has been processed and Nate has been notified by email to find a replacement goal tender.-<br/>-<br/>-See you next week.-<br/>-<br/>-The Management";
			}else{
				msg = "Thanks " + (String) session.getAttribute("username") + ",-<br/>-<br/>-Your request has been processed and your spot has been released to another skater.-<br/>-<br/>-See you next week.-<br/>-<br/>-The Management";
			}
			
			
			session.setAttribute("userMessage", msg); 
			
			response.sendRedirect("index.jsp");
			
		}
		
	}

}
