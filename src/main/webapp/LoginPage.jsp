<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bank Login | Customer & Admin</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.tailwindcss.com"></script>
<style>
.tab-active { @apply border-b-2 border-blue-600 text-blue-600;
	
}
</style>
</head>
<body class="bg-gray-100">

	<%
	String message = (String) request.getAttribute("message");
	if (message != null) {
	%>
	<script>
        alert("<%=message%>
		");
	</script>
	<%
	}
	%>


	<!-- Navbar -->
	<header class="bg-white shadow">
		<div
			class="container mx-auto px-6 py-4 flex justify-between items-center">
			<h1 class="text-2xl font-bold text-blue-700">TrustBank</h1>
			<nav class="space-x-4">
				<a href="index.html" class="text-gray-600 hover:text-blue-600">Home</a>
				<a href="#" class="text-gray-600 hover:text-blue-600">Services</a> <a
					href="#" class="text-gray-600 hover:text-blue-600">About</a> <a
					href="#" class="text-gray-600 hover:text-blue-600">Contact</a>
			</nav>
		</div>
	</header>

	<div class="min-h-screen flex items-center justify-center"
		style="margin-top: -50px">
		<div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
			<h2 class="text-2xl font-bold text-center text-blue-700 mb-6">TrustBank
				Login</h2>

			<!-- Tabs -->
			<div class="flex justify-center mb-6">
				<button id="customerTab"
					class="px-4 py-2 font-semibold text-gray-600 hover:text-blue-600"
					onclick="showForm('customer')">Customer</button>
				<button id="adminTab"
					class="px-4 py-2 font-semibold text-gray-600 hover:text-blue-600"
					onclick="showForm('admin')">Admin</button>
			</div>

			<!-- Customer Login Form -->
			<form id="customerForm" class="space-y-4" method="post"
				Action="Login">
				<div>
					<label class="block text-sm font-medium text-gray-700">Customer
						ID</label> <input type="text" required id="name" name="t1"
						placeholder="Enter your ID"
						class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>
				<div>
					<label class="block text-sm font-medium text-gray-700">Password</label>
					<input type="password" required placeholder="Enter password"
						id="password" name="t2"
						class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
					<br> <span id="passwordError"
						style="color: red; font-size: medium;"></span> <br>
				</div>
				<button type="submit" name="b1" value="CustomerLogin"
					class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">Login
					as Customer</button>
				<div style="text-align: center;">
					<a href="Forget.jsp?role=Customer"
						style="color: Red; padding-right: 15px;">Forget Details</a> <span><strong>|</strong></span>
					<a href="Registration.jsp" style="color: Red; padding-left: 15px;">New
						Customer? Register!</a>
				</div>
			</form>

			<!-- Admin Login Form -->
			<form id="adminForm" class="space-y-4 hidden" method="post"
				Action="Login">
				<div>
					<label class="block text-sm font-medium text-gray-700">Admin
						ID</label> <input type="text" name="t1" required
						placeholder="Enter Admin ID"
						class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
				</div>
				<div>
					<label class="block text-sm font-medium text-gray-700">Password</label>
					<input type="password" name="t2" required
						placeholder="Enter password" id="adminPassword"
						class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
					<br> <span id="adminPasswordError"
						style="color: red; font-size: medium;"></span> <br>
				</div>
				<button type="submit" name="b1" value="AdminLogin"
					class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">Login
					as Admin</button>
				<div style="text-align: center;">
					<a href="Forget.jsp?role=Admin" style="color: Red">Forget
						Details</a>
				</div>
			</form>
		</div>
	</div>

	<script>
		function showForm(role) {
			const customerForm = document.getElementById('customerForm');
			const adminForm = document.getElementById('adminForm');
			const customerTab = document.getElementById('customerTab');
			const adminTab = document.getElementById('adminTab');

			if (role === 'customer') {
				customerForm.classList.remove('hidden');
				adminForm.classList.add('hidden');
				customerTab.classList.add('tab-active');
				adminTab.classList.remove('tab-active');
			} else {
				adminForm.classList.remove('hidden');
				customerForm.classList.add('hidden');
				adminTab.classList.add('tab-active');
				customerTab.classList.remove('tab-active');
			}
		}

		// Set default to customer tab
		showForm('customer');
	</script>

	<script>
		function validatePassword(inputId, errorId) {
			const passwordInput = document.getElementById(inputId);
			const passwordError = document.getElementById(errorId);

			passwordInput
					.addEventListener(
							'input',
							function() {
								const password = passwordInput.value;
								const minLength = 8;
								const hasLower = /[a-z]/.test(password);
								const hasUpper = /[A-Z]/.test(password);
								const hasNumber = /\d/.test(password);
								const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/
										.test(password);

								passwordError.textContent = '';

								if (password.length < minLength) {
									passwordError.textContent = 'Password must be at least 8 characters long.';
								} else if (!hasLower || !hasUpper || !hasNumber
										|| !hasSpecial) {
									passwordError.textContent = 'Password must contain a lowercase, uppercase, number, and special character.';
								}
							});
		}

		// Apply to both customer and admin forms
		validatePassword('password', 'passwordError'); // Customer
		validatePassword('adminPassword', 'adminPasswordError'); // Admin
	</script>


</body>
</html>