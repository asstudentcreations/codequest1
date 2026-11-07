<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>CodeQuest - Student Registration</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Join CodeQuest!</h1>
        <p>Create your account and start learning programming.</p>

        <form action="register" method="post">
            <label>Username</label>
            <input type="text" name="username" required>

            <label>Email</label>
            <input type="email" name="email" required>

            <label>Password</label>
            <input type="password" name="password" required minlength="6">

            <button type="submit">Register</button>
        </form>

        <p>Already registered? <a href="login.jsp">Login here</a></p>
    </div>
    
    
<div style="text-align: center; margin-top: 20px;">
    <a href="<%= request.getContextPath() %>/index.jsp"
       style="display: inline-block;
              padding: 10px 18px;
              background: #e5e7eb;
              color: #222;
              text-decoration: none;
              border-radius: 6px;">
        ← Back to Home
    </a>
</div>
</body>
</html>
    