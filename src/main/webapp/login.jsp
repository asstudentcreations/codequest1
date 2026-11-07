
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String savedUsername = "";

    Cookie[] cookies = request.getCookies();

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("savedUsername".equals(cookie.getName())) {
                savedUsername = cookie.getValue();
                break;
            }
        }
    }

    String registered = request.getParameter("registered");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>CodeQuest - Login</title>
    <link rel="stylesheet" href="css/style.css">

</head>

<body>

    <div class="container">

        <h1>Welcome Back!</h1>

        <p>Login to continue your coding journey.</p>

        <%
            if ("1".equals(registered)) {
        %>

            <p style="color: green;">
                Registration successful! Please log in.
            </p>

        <%
            }
        %>

        <%
            if ("1".equals(error)) {
        %>

            <p style="color: red;">
                Invalid username or password.
            </p>

        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/login"
              method="post">

            <label>Username or Email</label>

            <input type="text"
                   name="username"
                   value="<%= savedUsername %>"
                   required>

            <label>Password</label>

            <input type="password"
                   name="password"
                   required>

            <button type="submit">Login</button>

        </form>

        <p>
            New student?
            <a href="register.jsp">Register here</a>
        </p>

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
