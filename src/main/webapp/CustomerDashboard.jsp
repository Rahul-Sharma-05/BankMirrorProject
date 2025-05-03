<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String customerName = (String) session.getAttribute("CustomerName"); // Set this on login
if (customerName == null) {
	request.getRequestDispatcher("Login").forward(request, response);
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Customer Dashboard</title>
<style>
body {
	font-family: Arial;
	background-color: #f9f9f9;
	margin: 0;
}

.navbar {
	background-color: #007bff;
	padding: 15px;
	color: white;
	text-align: center;
	font-size: 20px;
}

.container {
	max-width: 1000px;
	margin: 30px auto;
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20px;
}

.card {
	background-color: white;
	border-radius: 10px;
	padding: 25px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	text-align: center;
	transition: transform 0.3s ease;
}

.card:hover {
	transform: translateY(-5px);
}

.card a {
	text-decoration: none;
	color: #007bff;
	font-weight: bold;
}

.logout {
	text-align: center;
	margin-top: 40px;
}

.logout a {
	color: red;
	text-decoration: none;
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="navbar">
		Welcome,
		<%=customerName%>
		— Customer Dashboard
	</div>

	<div class="container">
		<div class="card">
			<h3>Account Details</h3>
			<p>View your account number, balance, and more.</p>
			<a href="ViewAccount.jsp">View Account</a>
		</div>

		<div class="card">
			<h3>Transaction History</h3>
			<p>View all your deposits, withdrawals, and transfers.</p>
			<a href="TransactionHistory.jsp">View Transactions</a>
		</div>

		<div class="card">
			<h3>Fund Transfer</h3>
			<p>Send money to another account.</p>
			<a href="TransferFunds.jsp">Transfer Funds</a>
		</div>

		<div class="card">
			<h3>Update Profile</h3>
			<p>Change your contact details, password, and address.</p>
			<a href="UpdateProfile.jsp">Update Info</a>
		</div>
	</div>

	<div class="logout">
		<a href="LogoutServlet">Logout</a>
	</div>
</body>
</html>
-

