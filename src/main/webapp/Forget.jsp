<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .form-container {
            background-color: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px #ccc;
            width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        label {
            display: block;
            margin-top: 20px;
            font-weight: bold;
        }

        input[type="email"],
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        button, input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px;
            margin-top: 15px;
            width: 100%;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover, input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #007bff;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        #passwordError {
            color: red;
            font-size: 14px;
        }
    </style>
</head>
<body>

<%
    String role = request.getParameter("role");
%>

<script>
    const role = "<%=role%>";
</script>

<div class="form-container">
    <h2>Forgot Details (<%=role%>)</h2>
    <form action="ChangePassword?role=<%=role%>" method="post" id="forgotForm">
        <label for="email">Registered Email Address</label>
        <input type="email" name="email" id="email" required placeholder="Enter your registered email">

        <button type="button" onclick="checkGmail()" id="sendRecoveryEmailBtn">Send Recovery Email</button>

        <!-- OTP Section -->
        <div id="otpSection" style="display: none;">
            <label for="otpInput">Enter OTP</label>
            <input type="text" id="otpInput" placeholder="Enter OTP">
            <button type="button" onclick="verifyOtp()" id="verifyOtpBtn">Verify OTP</button>
            <span id="otpStatus"></span>
            <p style="color: red;" id="otpInstructionParagraph">OTP has been sent to your email. Expires after 3 minutes.</p>
        </div>

        <!-- Details Section -->
        <div id="detailsSection" style="display: none;">
            <label for="customerIdSpan">Your ID:</label>
            <input type="text" id="customerIdSpan" name="CustomerId" readonly>
            <p>Keep your User ID safe for future references.</p>

            <button type="button" onclick="ChangePassword()" id="changePasswordBtn">Change Password</button>

            <!-- Password Section -->
            <div id="passwordSection" style="display: none;">
                <label for="password">Enter New Password : </label>
                <input type="password" id="password" name="password" required>
                <span id="passwordError"></span>
            </div>

            <input type="submit" value="Submit" id="submitBtn" style="display: none;">
        </div>

        <a href="LoginPage.jsp" class="back-link">← Back to Login</a>
    </form>
</div>

<script>
    const passwordInput = document.getElementById('password');
    const passwordError = document.getElementById('passwordError');
    
    passwordInput.addEventListener('input', function () {
        const password = passwordInput.value;
        const minLength = 8;
        const hasLower = /[a-z]/.test(password);
        const hasUpper = /[A-Z]/.test(password);
        const hasNumber = /\d/.test(password);
        const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);

        // Clear previous error message
        passwordError.textContent = '';

        // Validate password
        if (password.length < minLength) {
            passwordError.textContent = 'Password must be at least 8 characters long.';
        } else if (!hasLower || !hasUpper || !hasNumber || !hasSpecial) {
            passwordError.textContent = 'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character.';
        }
    });
</script>

	<script>
    let generatedOtp = "";
    let otpVerified = false;
    let otpExpirationTime = null;

    function checkGmail() {
    	
    	const work = "forget";
    	const fullName = role;
        const email = document.getElementById("email").value; // Added this line
        const emailBtn = document.getElementById("email");
        const otpSection = document.getElementById("otpSection");
        const sendRecoveryEmailBtn = document.getElementById("sendRecoveryEmailBtn");
        const submitBtn = document.getElementById("submitBtn");
        const verifyOtpBtn = document.getElementById("verifyOtpBtn");
        
        if (email.endsWith("@gmail.com")) {
        	
        	//Verifying Email Uniqueness
        	fetch("CheckEmailServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "email=" + encodeURIComponent(email)+
        "&role=" + encodeURIComponent(role)
    })
        .then(res => res.text())
        .then(data => {
            if (data === "unique") {
                alert("Email Not Registered!");
            }
            if (data === "exists"){
            	   
            	// Generate OTP
                generatedOtp = Math.floor(100000 + Math.random() * 900000).toString();
          //      alert("Your OTP is: " + generatedOtp); // For demo purposes only

                otpVerified = false;
                submitBtn.disabled = true;
                emailBtn.readOnly = true;
                sendRecoveryEmailBtn.style.display = "none";
                otpSection.style.display = "block";

                // Set OTP expiration time to 3 minutes from now
                otpExpirationTime = Date.now() + 3 * 60 * 1000;

                // Send OTP to server (optional)
                fetch("SendOtpMail", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "email=" + encodeURIComponent(email) +
              "&otp=" + encodeURIComponent(generatedOtp) +
              "&name=" + encodeURIComponent(fullName)+
              "&work=" + encodeURIComponent(work)
              
    }).then(response => response.text())
                .then(data => {
                    console.log("Server response:", data);
                })
                .catch(error => {
                    console.error("Error sending OTP:", error);
                });
            	
            }
        });
        	
        	
            
        } else {
            otpSection.style.display = "none";
            registerBtn.disabled = false;
        }
    }

    function verifyOtp() {
        const userOtp = document.getElementById("otpInput").value;
        const otpStatus = document.getElementById("otpStatus");
        const submitBtn = document.getElementById("submitBtn");
        const email = document.getElementById("email").value;
        const otpInstructionParagraph = document.getElementById("otpInstructionParagraph");
        

        const detailsSection = document.getElementById("detailsSection");
        


        const currentTime = Date.now();

        if (currentTime > otpExpirationTime) {
            otpStatus.textContent = "✘ OTP Expired";
            otpStatus.style.color = "red";
            otpVerified = false;
            submitBtn.disabled = true;
            return;
        }

        if (userOtp === generatedOtp) {
            otpStatus.textContent = "✔ Verified";
            otpStatus.style.color = "green";
            verifyOtpBtn.style.display = "none";
            otpVerified = true;
            submitBtn.disabled = false;
            detailsSection.style.display = "block";
            otpInstructionParagraph.style.display = "none";
            
            fetch("GetCustomerIdServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "email=" + encodeURIComponent(email)
            })
            .then(res => res.text())
            .then(customerId => {
                console.log("Customer ID:", customerId);
                // Optionally set it into a hidden input or span:
                document.getElementById("customerIdSpan").value = customerId;
            })
            .catch(err => console.error(err));

            
        } else {
            otpStatus.textContent = "✘ Invalid OTP";
            otpStatus.style.color = "red";
            otpVerified = false;
            submitBtn.disabled = true;
        }
    }
    
    
    function ChangePassword(){
    	const passwordSection = document.getElementById("passwordSection");
    	passwordSection.style.display = "block";
    	const submitBtn = document.getElementById("submitBtn");
    	submitBtn.style.display = "block";
    	const changePasswordBtn = document.getElementById('changePasswordBtn');
    	changePasswordBtn.style.display = "none";
    }
    </script>

</body>
</html>
