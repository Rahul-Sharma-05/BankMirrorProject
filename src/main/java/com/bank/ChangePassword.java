package com.bank;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ChangePassword")
public class ChangePassword extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		PrintWriter out = response.getWriter();
		String role = request.getParameter("role");
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank", "root", "Admin@123");

			PreparedStatement pstm = con.prepareStatement("UPDATE " + role + " SET password = ? WHERE email = ?");
			pstm.setString(1, password);
			pstm.setString(2, email);

			int rowsAffected = pstm.executeUpdate(); // use executeUpdate() for INSERT/UPDATE/DELETE

			if (rowsAffected > 0) {
				
				// Sending Mail
				final String from = "rahul.redcliffsharma@gmail.com";
				final String password2 = "jfsc blfl myxy zmdn"; // Use App Password if 2FA is enabled

				// SMTP properties
				Properties props = new Properties();
				props.put("mail.smtp.host", "smtp.gmail.com");
				props.put("mail.smtp.port", "587");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.starttls.enable", "true");

				// Create Session
				Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(from, password2);
					}
				});

				try {
					// Compose message
					Message message = new MimeMessage(mailSession);
					message.setFrom(new InternetAddress(from));
					message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
					message.setSubject("Password Changed Successfully");

					String htmlMessage = "<div style='font-family: Arial, sans-serif; font-size: 15px; color: #333;'>"
					        + "<p>Dear <strong>" + role + "</strong>,</p>"
					        + "<p>This is to inform you that your password has been successfully changed.</p>"
					        + "<p>If you made this change, no further action is needed.</p>"
					        + "<p>If you did not change your password, please contact our support team immediately.</p>"
					        + "<br>"
					        + "<p>Thank you for using our services!</p>"
					        + "<p style='color: #007bff; font-weight: bold;'>Trust Bank Support Team</p>"
					        + "</div>";

					message.setContent(htmlMessage, "text/html");


					// Send message
					Transport.send(message);

				} catch (MessagingException e) {
					e.printStackTrace(new java.io.PrintWriter(out));

				}
				
				
				
				out.println("<script>alert('Password Changed Successfully.')</script>");
				out.println("<script>window.location.href = \"LoginPage.jsp\";</script>");
			} else {
				out.println("✘ No matching user found.");
			}

			con.close();
		} catch (Exception e) {
			e.printStackTrace(new java.io.PrintWriter(out));
		}
	}
}