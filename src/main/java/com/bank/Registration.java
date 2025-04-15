package com.bank; 

import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import java.util.Properties;

@WebServlet("/Registration")
public class Registration extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		String name = request.getParameter("firstName");
		if(request.getParameter("middleName") != null) {
			name = name + " " +request.getParameter("middleName");
		}
		if(request.getParameter("lastName") != null) {
			name = name + " " +request.getParameter("lastName");
		}
		
		String mobile = request.getParameter("mobile");
		String email = request.getParameter("email");
		String address = request.getParameter("address");
		String password = request.getParameter("password");
		
		// Generating Customer ID
		String GeneratedCustomerId = "CU";
	    String query = "SELECT COUNT(*) FROM Customer";
	    try {	
			Class.forName("com.mysql.cj.jdbc.Driver");  
			Connection con = DriverManager.getConnection(  
			"jdbc:mysql://localhost:3306/bank","root","Admin@123");
			
	    Statement stmt = con.createStatement();
	    ResultSet rs = stmt.executeQuery(query);
	    
	    int count = 0;
	    if (rs.next()) count = rs.getInt(1);
	    rs.close();
	    stmt.close();

	    GeneratedCustomerId =  GeneratedCustomerId + (25 * 1000000 + count + 1);  // e.g., CU2025000001
	    
	    PreparedStatement ps = con.prepareStatement("Insert into Customer (CustomerId, Name, Password, MobileNumber, Email, Address) Value (?,?,?,?,?,?)");
		ps.setString(1, GeneratedCustomerId);
		ps.setString(2, name);
		ps.setString(3, password);
		ps.setString(4, mobile);
		ps.setString(5, email);
		ps.setString(6, address);
		
		int work = ps.executeUpdate();
		
		if(work > 0) {
			System.out.println("Registration Done...");
			
		 String from = "rahul.redcliffsharma@gmail.com";
			final String Gpassword = "jfsc blfl myxy zmdn"; // Use App Password if 2FA is enabled

			    // SMTP properties
			    Properties props = new Properties();
			    props.put("mail.smtp.host", "smtp.gmail.com");
			    props.put("mail.smtp.port", "587");
			    props.put("mail.smtp.auth", "true");
			    props.put("mail.smtp.starttls.enable", "true");

			    // Create Session
			    Session mailSession = Session.getInstance(props,
			        new javax.mail.Authenticator() {
			            protected PasswordAuthentication getPasswordAuthentication() {
			                return new PasswordAuthentication(from, Gpassword);
			            }
			        });

			    try {
			        // Compose message
			        Message message = new MimeMessage(mailSession);
			            message.setFrom(new InternetAddress(from));
			            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
			            message.setSubject("Registration Done. Customer ID Generated.");
			            String htmlMessage =
			            		"<p>Congratulations <strong>"+ name +"</strong></p>" +
			            	    "<p>Welcome to <strong>Trust Bank!</strong></p>" +
			            	    "<p>Thanks for choosing our bank.</p>" +
			            	    "<p>You successfully completed Registration process.</p>" +
			            	    "<p>Your Customer Id is: <strong style='font-size: 18px;'>" + GeneratedCustomerId + "</strong></p>" +
			            	    "<p>Keep this Customer Id secure for future purpose.</p>"+
			            	    "<br>"+
			            	    "<br>"+
			            	    "<br>"+
			            	    "<p>Thank you!!</p>";

			            	message.setContent(htmlMessage, "text/html");

			        // Send message
			        Transport.send(message);

			    } catch (MessagingException e) {
			    	e.printStackTrace(new java.io.PrintWriter(out));

			    }
			
			    request.setAttribute("message", "Registration Completed Successfully!! Your Customer ID has been sent to your registered E-mail Id. Please Login!");
			    RequestDispatcher rd = request.getRequestDispatcher("/LoginPage.jsp");
			    rd.forward(request, response);

		}else {
			request.setAttribute("message", "'Some thing went wrong!! Try Again.'");
			RequestDispatcher rd = request.getRequestDispatcher("/Registration.jsp");
			rd.forward(request, response);

		}
	    
	    
	    }catch(Exception e){
			System.out.println(e);
			request.setAttribute("message", "'Some thing went wrong!! Try Again.'");
			RequestDispatcher rd = request.getRequestDispatcher("/Registration.jsp");
			rd.forward(request, response);
	}
		
		
		
	}
}