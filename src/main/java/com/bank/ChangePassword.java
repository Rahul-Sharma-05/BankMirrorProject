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
	        Connection con = DriverManager.getConnection(  
	            "jdbc:mysql://localhost:3306/bank", "root", "Admin@123");

	        PreparedStatement pstm = con.prepareStatement("UPDATE "+role+" SET password = ? WHERE email = ?");
	        pstm.setString(1, password);
	        pstm.setString(2, email);

	        int rowsAffected = pstm.executeUpdate(); // use executeUpdate() for INSERT/UPDATE/DELETE

	        if (rowsAffected > 0) {
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