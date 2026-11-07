<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Mission - CodeQuest</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
            padding: 25px;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
        }
        h2 { text-align: center; color: #243b64; }
        label { display: block; margin-top: 12px; }
        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background: #3157a4;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        a { display: inline-block; margin-top: 15px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Add Programming Mission</h2>
    <%
    if ("1".equals(request.getParameter("success"))) {
%>
    <p style="color:green;">Mission added successfully!</p>
<%
    } else if ("invalid".equals(request.getParameter("error"))) {
%>
    <p style="color:red;">Please enter valid mission details.</p>
<%
    }
%>

    <form action="<%= request.getContextPath() %>/add-mission"
          method="post">

        <label>Mission Title</label>
        <input type="text" name="title" required maxlength="150">

        <label>Description / Question</label>
        <textarea name="description" rows="4" required></textarea>

        <label>Category</label>
        <select name="category" required>
            <option value="Java">Java</option>
            <option value="Python">Python</option>
            <option value="Web Development">Web Development</option>
            <option value="Database">Database</option>
            <option value="Other">Other</option>
        </select>

        <label>Difficulty</label>
        <select name="difficulty" required>
            <option value="Easy">Easy</option>
            <option value="Medium">Medium</option>
            <option value="Hard">Hard</option>
        </select>

        <label>Option A</label>
        <input type="text" name="optionA" required>

        <label>Option B</label>
        <input type="text" name="optionB" required>

        <label>Option C</label>
        <input type="text" name="optionC" required>

        <label>Option D</label>
        <input type="text" name="optionD" required>

        <label>Correct Answer</label>
        <select name="correctAnswer" required>
            <option value="A">Option A</option>
            <option value="B">Option B</option>
            <option value="C">Option C</option>
            <option value="D">Option D</option>
        </select>

        <label>XP Reward</label>
        <input type="number" name="xpReward"
               min="1" max="1000" value="10" required>

        <button type="submit">Add Mission</button>
    </form>

    <a href="<%= request.getContextPath() %>/admin-dashboard">
        ← Back to Dashboard
    </a>
</div>
</body>
</html>
