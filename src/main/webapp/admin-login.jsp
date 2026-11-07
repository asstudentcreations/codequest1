<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("adminId") != null) {
        response.sendRedirect(
                request.getContextPath() + "/admin-dashboard");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Admin Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f5fb;
            margin: 0;
            padding: 40px 15px;
        }

        .login-box {
            max-width: 380px;
            margin: 50px auto;
            background: white;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #ddd;
        }

        h1 {
            color: #243b80;
            text-align: center;
        }

        label {
            display: block;
            margin-top: 15px;
        }

        input {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            margin-top: 7px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            margin-top: 22px;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: #243b80;
            color: white;
            cursor: pointer;
        }

        .error {
            color: #b00020;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h1>Admin Login</h1>
        <p style="text-align:center">
            Manage CodeQuest missions
        </p>

        <% if ("1".equals(error)) { %>
            <p class="error">
                Invalid username or password.
            </p>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin-login"
              method="post">

            <label>Username</label>
            <input type="text" name="username" required>

            <label>Password</label>
            <input type="password" name="password" required>

            <button type="submit">Login as Admin</button>
        </form>
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
	