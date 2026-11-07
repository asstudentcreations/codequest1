
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    Integer xp = (Integer) request.getAttribute("xp");
    Integer level = (Integer) request.getAttribute("level");
    Integer progress = (Integer) request.getAttribute("progress");

    if (username == null || xp == null || level == null || progress == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - CodeQuest</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f5fb;
            margin: 0;
            padding: 30px;
            color: #222;
        }

        .container {
            max-width: 650px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #00000015;
        }

        h1 {
            color: #2446a6;
            text-align: center;
        }

        .item {
            padding: 14px;
            margin: 12px 0;
            background: #f4f6fc;
            border-radius: 8px;
        }

        .progress-bg {
            height: 18px;
            background: #ddd;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress {
            height: 100%;
            background: #2eaf70;
        }

        a {
            display: inline-block;
            margin: 10px 8px 0 0;
            padding: 11px 16px;
            background: #2446a6;
            color: white;
            text-decoration: none;
            border-radius: 7px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>My CodeQuest Profile</h1>

    <div class="item">
        <strong>Username:</strong> <%= username %>
    </div>

    <div class="item">
        <strong>Email:</strong> <%= email == null ? "Not available" : email %>
    </div>

    <div class="item">
        <strong>Current Level:</strong> <%= level %>
    </div>

    <div class="item">
        <strong>Total XP:</strong> <%= xp %>
    </div>

    <h3>Progress to Next Level: <%= progress %>%</h3>
    <div class="progress-bg">
        <div class="progress" style="width: <%= progress %>%;"></div>
    </div>

    <p>You need <%= 100 - progress %> more XP to reach the next level.</p>

    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    <a href="<%= request.getContextPath() %>/missions">Missions</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>
</body>
</html>
