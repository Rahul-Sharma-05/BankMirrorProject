<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>

<%
    String to = "rohitkumar35416@gmail.com";      // change this
    String from = "rahul.redcliffsharma@gmail.com";      // your Gmail
    String password = "jfsc blfl myxy zmdn";         // your Gmail password or App Password

    String subject = "Test Email from JSP";
    String messageText = "Rohit shamra gadh h!!";

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
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(messageText);

        // Send message
        Transport.send(message);
%>
        <h3 style="color:green;">Email sent successfully!</h3>
<%
    } catch (MessagingException e) {
    	e.printStackTrace(new java.io.PrintWriter(out));
%>
        <h3 style="color:red;">Error: <%= e.getMessage() %></h3>
<%
    }
%>
