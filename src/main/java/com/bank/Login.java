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

@WebServlet("/Login")
public class Login extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
                
        String bt = request.getParameter("b1");
    	PrintWriter out = response.getWriter();
    	if(bt.equalsIgnoreCase("AdminLogin")) {
    		
    		String id = request.getParameter("t1");
    		String givenPass = request.getParameter("t2");
    	
    			
    	try{  
    		Class.forName("com.mysql.cj.jdbc.Driver");  
    		Connection con = DriverManager.getConnection(  
    		"jdbc:mysql://localhost:3306/bank","root","Admin@123"); 
    		PreparedStatement pstm = con.prepareStatement("SELECT AdminName, password, status FROM Admin WHERE AdminId=?"); 
    		pstm.setString(1, id);
    		ResultSet rs = pstm.executeQuery();
    		
    		if (rs.next()) {
    			String pass = rs.getString("password");
    			if(givenPass.equals(pass)) {
    				System.out.println("Admin Login Done...");
    				
    				out.println("<script>alert('Login Successfull..')</script>");
    				String AdminName = rs.getString("AdminName");
    				Boolean Status  = rs.getBoolean("Status");
    				
    				HttpSession hs = request.getSession();
    				hs.setAttribute("AdminName", AdminName);
    				hs.setAttribute("AdminId", id);
    				hs.setAttribute("Status", Status);
    				
    				
    				RequestDispatcher rd = request.getRequestDispatcher("/AdminDashboard.jsp");
    				rd.forward(request, response);
    				
    			}else {
    				out.println("<script>alert('Login Faild. User Id or Password Mismachted.')</script>");
//    				response.setContentType("text/html");
//    				out.print("<h3 style='color:red>Email Id and password did not match.</h3>");
    				RequestDispatcher rd = request.getRequestDispatcher("/LoginPage.jsp");
    				rd.include(request, response);
    			}
    		}else {
    			out.println("<script>alert('Admin Id Not found.')</script>");
//    			response.setContentType("text/html");
//				out.print("<h3 style='color:red>User Id not Found.</h3>");
				RequestDispatcher rd = request.getRequestDispatcher("/LoginPage.jsp");
				rd.include(request, response);
    		}
    			
    			
    		}catch(Exception e){
    			System.out.println(e);
    	}
    	}
    	       //End Of Admin Login
    	       
    	       //Start of Student Login
    	       
    	       
    	 if(bt.equalsIgnoreCase("CustomerLogin")) {
    		
    		String id = request.getParameter("t1");
    		String givenPass = request.getParameter("t2");
    	
    			
    	try{  
    		Class.forName("com.mysql.cj.jdbc.Driver");  
    		Connection con = DriverManager.getConnection(  
    		"jdbc:mysql://localhost:3306/bank","root","Admin@123");  
    		
    		PreparedStatement pstm = con.prepareStatement("SELECT CustomerName,Password, Status FROM Customer WHERE CustomerId=?"); 
    		pstm.setString(1, id);
    		ResultSet rs = pstm.executeQuery();
    		
    		if (rs.next()) {
    			String pass = rs.getString("password");
    			if(givenPass.equals(pass)) {
    				
    				out.println("<script>alert('Login Successfull..')</script>");
    				
    				String StudentName = rs.getString("CustomerName");
    				Boolean Status = rs.getBoolean("Status");
    				
    				HttpSession hs = request.getSession();
    				hs.setAttribute("StudentName", StudentName);
    				hs.setAttribute("StudentId", id);
    				hs.setAttribute("Status", Status);
    				
    				RequestDispatcher rd = request.getRequestDispatcher("/CustomerDashboard.jsp");
    				rd.forward(request, response);
    			}else {
    				out.println("<script>alert('Login Faild. User Id or Password Mismachted.')</script>");
    				
//    				response.setContentType("text/html");
//    				out.print("<h3 style='color:red>Email Id and password did not match.</h3>");
    				RequestDispatcher rd = request.getRequestDispatcher("/LoginPage.jsp");
    				rd.include(request, response);
    			}
    		}else {
    			out.println("<script>alert('User Id Not found.')</script>");
//    			response.setContentType("text/html");
//				out.print("<h3 style='color:red>User Id not Found.</h3>");
				RequestDispatcher rd = request.getRequestDispatcher("/LoginPage.jsp");
				rd.include(request, response);
    		}
    			
    			
    		}catch(Exception e){
    			System.out.println(e);
    	}
    	
    	}
    }
}

