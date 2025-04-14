<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Registration</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f2f2f2;
            padding: 50px;
        }

        .container {
            width: 600px;
            margin: auto;
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px #999;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            margin-right : 20px;
        }

        input[type=text],
        input[type=tel],
        input[type=email],
        input[type=password] {
            width: 160px;
            padding: 8px;
            margin: 8px 0 16px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        textarea {
            width: 70%;
            padding: 8px;
            margin: 8px 0 16px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            vertical-align: middle;
        }

        .name-row {
            display: flex;
            gap: 10px;
        }

        .name-row .form-group {
            flex: 1;
        }

        button{
            background-color: Black;
            color: White;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: Red;
            color: Green;
        }
        input[type=submit] {
            background-color: #007bff;
            color: white;
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        input[type=submit]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Customer Registration</h2>
        <form action="/Registration" method="post">
            <div class="name-row">
                <div class="form-group">
                    <label>First Name:</label>
                    <input type="text" name="firstName"  id="Fname"required>
                </div>
                <div class="form-group">
                    <label>Middle Name:</label>
                    <input type="text" name="middleName" id="Mname">
                </div>
                <div class="form-group">
                    <label>Last Name:</label>
                    <input type="text" name="lastName" id="Lname">
                </div>
            </div>

            <label>Mobile Number:</label>
            <input type="tel" name="mobile" pattern="[0-9]{10}" required placeholder="10-digit mobile number">
            <br>

            <label style="margin-right:25px;">Email Address:</label>
            <input type="email" id="email" name="email" required onchange="checkGmail()">
            <br>

            <!-- OTP Section (Initially Hidden) -->
            <div id="otpSection" style="display: none; margin-top: 10px;">
                <label style="margin-right:57px;">Enter OTP:</label>
                <input type="text" id="otpInput" placeholder="Enter OTP">
                <button type="button" onclick="verifyOtp()">Verify OTP</button>
                <span id="otpStatus" style="margin-left: 10px;"></span>
                <br>
                <label style="margin-right:70px;">OTP has been sent your e-mail. Expires after 3 minutes.</label>
            </div>

            <label style="margin-right:70px;">Address:</label>
            <textarea name="address" rows="3" required></textarea>
            <br>

            <label for="password" style="margin-right: 60px;">Password:</label>
            <input type="password" id="password" name="password" required>
            <span id="passwordError" style="color: red;"></span>
            <br>

            <input type="submit" value="Register" id="registerBtn">
        </form>
    </div>
    
    <script>
    let generatedOtp = "";
    let otpVerified = false;
    let otpExpirationTime = null;

    function checkGmail() {
    	const firstName = document.querySelector('input[name="firstName"]').value;
        const middleName = document.querySelector('input[name="middleName"]').value;
        const lastName = document.querySelector('input[name="lastName"]').value;
        const fullName = [firstName, middleName, lastName].filter(Boolean).join(' ');
        const email = document.getElementById("email").value; // Added this line
        const otpSection = document.getElementById("otpSection");
        const registerBtn = document.getElementById("registerBtn");

        if (email.endsWith("@gmail.com")) {
            // Generate OTP
            generatedOtp = Math.floor(100000 + Math.random() * 900000).toString();
      //      alert("Your OTP is: " + generatedOtp); // For demo purposes only

            otpVerified = false;
            registerBtn.disabled = true;
            otpSection.style.display = "block";

            // Set OTP expiration time to 3 minutes from now
            otpExpirationTime = Date.now() + 3 * 60 * 1000;

            // Send OTP to server (optional)
            fetch("SendOtpMail.jsp", {
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
    },
    body: "email=" + encodeURIComponent(email) +
          "&otp=" + encodeURIComponent(generatedOtp) +
          "&name=" + encodeURIComponent(fullName)
}).then(response => response.text())
            .then(data => {
                console.log("Server response:", data);
            })
            .catch(error => {
                console.error("Error sending OTP:", error);
            });
        } else {
            otpSection.style.display = "none";
            registerBtn.disabled = false;
        }
    }

    function verifyOtp() {
        const userOtp = document.getElementById("otpInput").value;
        const otpStatus = document.getElementById("otpStatus");
        const registerBtn = document.getElementById("registerBtn");

        const currentTime = Date.now();

        if (currentTime > otpExpirationTime) {
            otpStatus.textContent = "✘ OTP Expired";
            otpStatus.style.color = "red";
            otpVerified = false;
            registerBtn.disabled = true;
            return;
        }

        if (userOtp === generatedOtp) {
            otpStatus.textContent = "✔ Verified";
            otpStatus.style.color = "green";
            otpVerified = true;
            registerBtn.disabled = false;
        } else {
            otpStatus.textContent = "✘ Invalid OTP";
            otpStatus.style.color = "red";
            otpVerified = false;
            registerBtn.disabled = true;
        }
    }
    </script>
</body>
</html>
