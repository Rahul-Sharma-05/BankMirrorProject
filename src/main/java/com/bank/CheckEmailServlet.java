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

@WebServlet("/CheckEmailServlet")
public class CheckEmailServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
		String email = request.getParameter("email");
	try {	
		Class.forName("com.mysql.cj.jdbc.Driver");  
		Connection con = DriverManager.getConnection(  
		"jdbc:mysql://localhost:3306/bank","root","Admin@123"); 
		PreparedStatement ps = con.prepareStatement("SELECT * FROM Customer WHERE email = ?");
		ps.setString(1, email);
		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
		    response.getWriter().write("exists");
		} else {
		    response.getWriter().write("unique");
		}
	}catch(Exception e){
		System.out.println(e);
}
	}
}