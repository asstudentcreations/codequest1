<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.LeaderboardServlet.LeaderboardEntry" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<LeaderboardEntry> entries =
        (List<LeaderboardEntry>) request.getAttribute("leaderboard");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Leaderboard</title>

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
            padding: 22px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .header a {
            color: white;
        }

        .leaderboard {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px #ddd;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #e8edfc;
            color: #243b80;
        }

        tr:hover {
            background: #f7f8fc;
        }

        .rank {
            font-weight: bold;
        }

        .xp {
            color: #243b80;
            font-weight: bold;
        }
    </style>
</head>

<body>
<div class="container">

    <div class="header">
        <h1>🏆 CodeQuest Leaderboard</h1>
        <p>Learn more. Solve missions. Earn XP.</p>

        <a href="<%= request.getContextPath() %>/dashboard">
            Back to Dashboard
        </a>
    </div>

    <div class="leaderboard">
        <h2>Top Students</h2>

        <% if (entries == null || entries.isEmpty()) { %>

            <p>No students found.</p>

        <% } else { %>

            <table>
                <tr>
                    <th>Rank</th>
                    <th>Username</th>
                    <th>XP</th>
                    <th>Level</th>
                </tr>

                <% for (LeaderboardEntry entry : entries) { %>
                    <tr>
                        <td class="rank">
                            <% if (entry.rank == 1) { %>
                                🥇 1
                            <% } else if (entry.rank == 2) { %>
                                🥈 2
                            <% } else if (entry.rank == 3) { %>
                                🥉 3
                            <% } else { %>
                                <%= entry.rank %>
                            <% } %>
                        </td>

                        <td><%= entry.username %></td>
                        <td class="xp"><%= entry.xp %></td>
                        <td><%= entry.level %></td>
                    </tr>
                <% } %>

            </table>

        <% } %>
    </div>

</div>
</body>
</html>
