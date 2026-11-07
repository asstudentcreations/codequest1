
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.AdminMissionsServlet.AdminMission" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    List<AdminMission> missions =
        (List<AdminMission>) request.getAttribute("missions");

    String context = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Missions - CodeQuest</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
            padding: 25px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            overflow-x: auto;
        }

        h2 {
            color: #243b64;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #3157a4;
            color: white;
        }

        tr:nth-child(even) {
            background: #f5f7fa;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            margin-right: 12px;
        }

        .edit-btn, .delete-btn {
            display: inline-block;
            padding: 7px 12px;
            margin: 2px;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .edit-btn {
            background: #3157a4;
        }

        .delete-btn {
            background: #dc3545;
        }

        .action-form {
            display: inline;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>All Programming Missions</h2>

    <% if (missions == null || missions.isEmpty()) { %>

        <p>No missions available. Add your first mission.</p>

    <% } else { %>

        <table>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Category</th>
                <th>Difficulty</th>
                <th>Correct Answer</th>
                <th>XP Reward</th>
                <th>Actions</th>
            </tr>

            <% for (AdminMission m : missions) { %>

            <tr>
                <td><%= m.id %></td>
                <td><%= m.title %></td>
                <td><%= m.category %></td>
                <td><%= m.difficulty %></td>
                <td><%= m.correctAnswer %></td>
                <td><%= m.xpReward %></td>

                <td>
                    <a class="edit-btn"
                       href="<%= context %>/edit-mission?missionId=<%= m.id %>">
                        Edit
                    </a>

                    <form class="action-form"
                          action="<%= context %>/delete-mission"
                          method="post"
                          onsubmit="return confirm('Are you sure you want to delete this mission?');">

                        <input type="hidden"
                               name="missionId"
                               value="<%= m.id %>">

                        <button type="submit" class="delete-btn">
                            Delete
                        </button>
                    </form>
                </td>
            </tr>

            <% } %>

        </table>

    <% } %>

    <a href="<%= context %>/add-mission.jsp">+ Add Mission</a>

    <a href="<%= context %>/admin-dashboard">Back to Dashboard</a>

</div>

</body>
</html>
