package com.bank;
import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/SendOtpMail")
public class SendOtpMail extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		String email = request.getParameter("email");
		String name = request.getParameter("name");
		String otp = request.getParameter("otp");

		final String from = "rahul.redcliffsharma@gmail.com";
		final String password = "jfsc blfl myxy zmdn"; // Use App Password if 2FA is enabled

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
		                return new PasswordAuthentication(from, password);
		            }
		        });

		    try {
		        // Compose message
		        Message message = new MimeMessage(mailSession);
		            message.setFrom(new InternetAddress(from));
		            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
		            message.setSubject("Your OTP Code");
		            String htmlMessage =
		            		"<p>Hello <strong>"+ name +"</strong></p>" +
		            	    "<p>Thanks for choosing our bank.</p>" +
		            	    "<p>To complete your registration, enter the given OTP within 3 min.</p>" +
		            	    "<p>Your OTP is: <strong style='font-size: 18px;'>" + otp + "</strong></p>" +
		            	    "<p>Thank you!!</p>";

		            	message.setContent(htmlMessage, "text/html");

		        // Send message
		        Transport.send(message);

		    } catch (MessagingException e) {
		    	e.printStackTrace(new java.io.PrintWriter(out));

		    }
    }
}
