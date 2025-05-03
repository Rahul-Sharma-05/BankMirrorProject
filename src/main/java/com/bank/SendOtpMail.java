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
		String work = request.getParameter("work");
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
		Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(from, password);
			}
		});

		try {
			// Compose message
			Message message = new MimeMessage(mailSession);
			message.setFrom(new InternetAddress(from));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
			
			String htmlMessage1 = "<div style='font-family: Arial, sans-serif; font-size: 15px; color: #333;'>"
			        + "<p>Dear <strong>" + name + "</strong>,</p>"
			        + "<p>Thank you for choosing our bank. To complete your registration, please use the One-Time Password (OTP) provided below:</p>"
			        + "<p>Your OTP is: <strong style='font-size: 18px; color: #007bff;'>" + otp + "</strong></p>"
			        + "<p>This OTP is valid for <strong>3 minutes</strong>. Please do not share it with anyone for security reasons.</p>"
			        + "<p>If you did not request this OTP, please ignore this email or contact our support team immediately.</p>"
			        + "<br><p>Warm regards,</p>"
			        + "<p style='color: #007bff; font-weight: bold;'>Trust Bank Support Team</p>"
			        + "</div>";

			String htmlMessage2 = "<div style='font-family: Arial, sans-serif; font-size: 15px; color: #333;'>"
			        + "<p>Dear <strong>" + name + "</strong>,</p>"
			        + "<p>This email is in reference to your registered ID with our bank.</p>"
			        + "<p>To recover your details, please use the following OTP within <strong>3 minutes</strong>:</p>"
			        + "<p>Your OTP is: <strong style='font-size: 18px; color: #007bff;'>" + otp + "</strong></p>"
			        + "<p>For your safety, do not share this OTP with anyone.</p>"
			        + "<p>If you did not request this OTP, please ignore this message or contact support.</p>"
			        + "<br><p>Thank you,</p>"
			        + "<p style='color: #007bff; font-weight: bold;'>Trust Bank Support Team</p>"
			        + "</div>";

			if (work.equalsIgnoreCase("registration"))
				message.setSubject("Your OTP Code for registration.");
				message.setContent(htmlMessage1, "text/html");

			if (work.equalsIgnoreCase("forget"))
				message.setSubject("Your OTP Code to get details.");
				message.setContent(htmlMessage2, "text/html");

			// Send message
			Transport.send(message);

		} catch (MessagingException e) {
			e.printStackTrace(new java.io.PrintWriter(out));

		}
	}
}
