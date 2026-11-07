
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String context = request.getContextPath();

    Integer missionId = (Integer) request.getAttribute("missionId");

    if (missionId == null) {
        response.sendRedirect(context + "/admin-missions");
        return;
    }

    String title = (String) request.getAttribute("title");
    String description = (String) request.getAttribute("description");
    String category = (String) request.getAttribute("category");
    String difficulty = (String) request.getAttribute("difficulty");
    String optionA = (String) request.getAttribute("optionA");
    String optionB = (String) request.getAttribute("optionB");
    String optionC = (String) request.getAttribute("optionC");
    String optionD = (String) request.getAttribute("optionD");
    String correctAnswer = (String) request.getAttribute("correctAnswer");
    Integer xpReward = (Integer) request.getAttribute("xpReward");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Mission - CodeQuest</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
            padding: 25px;
        }

        .container {
            max-width: 650px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
        }

        h2 {
            text-align: center;
            color: #243b64;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        textarea {
            min-height: 90px;
        }

        button {
            margin-top: 20px;
            padding: 11px 18px;
            background: #3157a4;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .cancel {
            display: inline-block;
            margin-left: 10px;
            color: #3157a4;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Edit Mission</h2>

    <form action="<%= context %>/edit-mission" method="post">

        <input type="hidden" name="missionId" value="<%= missionId %>">

        <label>Mission Title</label>
        <input type="text" name="title"
               value="<%= title == null ? "" : title %>" required>

        <label>Description</label>
        <textarea name="description" required><%= description == null ? "" : description %></textarea>

        <label>Category</label>
        <input type="text" name="category"
               value="<%= category == null ? "" : category %>" required>

        <label>Difficulty</label>
        <select name="difficulty" required>
            <option value="Easy" <%= "Easy".equalsIgnoreCase(difficulty) ? "selected" : "" %>>Easy</option>
            <option value="Medium" <%= "Medium".equalsIgnoreCase(difficulty) ? "selected" : "" %>>Medium</option>
            <option value="Hard" <%= "Hard".equalsIgnoreCase(difficulty) ? "selected" : "" %>>Hard</option>
        </select>

        <label>Option A</label>
        <input type="text" name="optionA"
               value="<%= optionA == null ? "" : optionA %>" required>

        <label>Option B</label>
        <input type="text" name="optionB"
               value="<%= optionB == null ? "" : optionB %>" required>

        <label>Option C</label>
        <input type="text" name="optionC"
               value="<%= optionC == null ? "" : optionC %>" required>

        <label>Option D</label>
        <input type="text" name="optionD"
               value="<%= optionD == null ? "" : optionD %>" required>

        <label>Correct Answer</label>
        <select name="correctAnswer" required>
            <option value="A" <%= "A".equalsIgnoreCase(correctAnswer) ? "selected" : "" %>>A</option>
            <option value="B" <%= "B".equalsIgnoreCase(correctAnswer) ? "selected" : "" %>>B</option>
            <option value="C" <%= "C".equalsIgnoreCase(correctAnswer) ? "selected" : "" %>>C</option>
            <option value="D" <%= "D".equalsIgnoreCase(correctAnswer) ? "selected" : "" %>>D</option>
        </select>

        <label>XP Reward</label>
        <input type="number" name="xpReward" min="0"
               value="<%= xpReward == null ? 0 : xpReward %>" required>

        <button type="submit">Update Mission</button>

        <a class="cancel" href="<%= context %>/admin-missions">Cancel</a>

    </form>

</div>

</body>
</html>
