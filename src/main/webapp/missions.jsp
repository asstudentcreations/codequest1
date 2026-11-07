<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.Mission" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Mission> missions =
        (List<Mission>) request.getAttribute("missions");

    String result = request.getParameter("result");
    String alreadyAttempted =
        request.getParameter("alreadyAttempted");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Missions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f5fb;
            margin: 0;
            padding: 25px;
            color: #222;
        }

        .container {
            max-width: 850px;
            margin: auto;
        }

        .header {
            background: #243b80;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .mission {
            background: white;
            padding: 22px;
            margin-bottom: 18px;
            border-radius: 10px;
            box-shadow: 0 2px 8px #ddd;
        }

        .tag {
            color: #243b80;
            font-weight: bold;
        }

        .option {
            display: block;
            padding: 10px;
            margin: 8px 0;
            background: #f2f5fb;
            border-radius: 6px;
            cursor: pointer;
        }

        button {
            background: #243b80;
            color: white;
            border: none;
            padding: 11px 20px;
            border-radius: 6px;
            cursor: pointer;
        }

        .message {
            background: #e1f5e8;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .error {
            background: #fff0d8;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        a {
            color: #243b80;
        }
    </style>
</head>
<body>
<div class="container">

    <div class="header">
        <h1>CodeQuest Missions</h1>
        <p>Learn programming, answer questions, and earn XP!</p>
        <a href="<%= request.getContextPath() %>/dashboard"
           style="color:white;">Back to Dashboard</a>
    </div>

    <% if ("correct".equals(result)) { %>
        <div class="message">
            Correct answer! Well done. You earned XP!
        </div>
    <% } else if ("wrong".equals(result)) { %>
        <div class="error">
            Incorrect answer. Keep learning and try another mission.
        </div>
    <% } %>

    <% if ("1".equals(alreadyAttempted)) { %>
        <div class="error">
            You have already attempted this mission.
        </div>
    <% } %>

    <% if (missions == null || missions.isEmpty()) { %>
        <div class="mission">
            <h3>No missions available</h3>
            <p>All missions may have been attempted, or no missions were found.</p>
        </div>
    <% } else { %>

        <% for (Mission m : missions) { %>
            <div class="mission">

                <h2><%= m.title %></h2>

                <p><%= m.description %></p>

                <p class="tag">
                    Category: <%= m.category %>
                    | Difficulty: <%= m.difficulty %>
                    | Reward: <%= m.xpReward %> XP
                </p>

                <form action="<%= request.getContextPath() %>/submit-answer"
                      method="post">

                    <input type="hidden"
                           name="missionId"
                           value="<%= m.id %>">

                    <label class="option">
                        <input type="radio" name="answer"
                               value="A" required>
                        A. <%= m.optionA %>
                    </label>

                    <label class="option">
                        <input type="radio" name="answer"
                               value="B">
                        B. <%= m.optionB %>
                    </label>

                    <label class="option">
                        <input type="radio" name="answer"
                               value="C">
                        C. <%= m.optionC %>
                    </label>

                    <label class="option">
                        <input type="radio" name="answer"
                               value="D">
                        D. <%= m.optionD %>
                    </label>

                    <button type="submit">Submit Answer</button>
                </form>

            </div>
        <% } %>

    <% } %>

</div>
</body>
</html>
