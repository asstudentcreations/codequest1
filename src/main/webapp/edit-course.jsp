
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String context = request.getContextPath();

    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(context + "/admin-login.jsp");
        return;
    }

    Integer courseId = (Integer) request.getAttribute("courseId");

    if (courseId == null) {
        response.sendRedirect(context + "/admin-courses");
        return;
    }

    String title = (String) request.getAttribute("title");
    String description = (String) request.getAttribute("description");
    String category = (String) request.getAttribute("category");
    String difficulty = (String) request.getAttribute("difficulty");
    String duration = (String) request.getAttribute("duration");
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Course | CodeQuest</title>

<style>

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f7fb;
    color: #172033;
}

header {
    background: #111827;
    color: white;
    padding: 20px 5%;
    font-size: 24px;
    font-weight: bold;
}

header span {
    color: #60a5fa;
}

.container {
    max-width: 650px;
    margin: 40px auto;
    padding: 30px;
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
}

h1 {
    margin-top: 0;
}

.subtitle {
    color: #64748b;
    margin-bottom: 25px;
}

label {
    display: block;
    font-weight: bold;
    margin-bottom: 7px;
}

input, textarea, select {
    width: 100%;
    box-sizing: border-box;
    padding: 12px;
    margin-bottom: 18px;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
    font-size: 15px;
}

textarea {
    resize: vertical;
    min-height: 100px;
}

button {
    background: #2563eb;
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 15px;
}

.back-btn {
    display: inline-block;
    margin-left: 10px;
    padding: 12px 18px;
    background: #e5e7eb;
    color: #172033;
    text-decoration: none;
    border-radius: 6px;
}

</style>
</head>

<body>

<header>
    Code<span>Quest</span>
</header>

<div class="container">

    <h1>Edit Course</h1>

    <p class="subtitle">
        Update the course information below.
    </p>

    <form action="<%= context %>/edit-course" method="post">

        <input type="hidden" name="courseId"
               value="<%= courseId %>">

        <label>Course Title</label>

        <input type="text"
               name="title"
               value="<%= title %>"
               required>

        <label>Description</label>

        <textarea name="description" required><%= description %></textarea>

        <label>Category</label>

        <input type="text"
               name="category"
               value="<%= category %>"
               required>

        <label>Difficulty</label>

        <select name="difficulty" required>

            <option value="Beginner"
                <%= "Beginner".equalsIgnoreCase(difficulty) ? "selected" : "" %>>
                Beginner
            </option>

            <option value="Intermediate"
                <%= "Intermediate".equalsIgnoreCase(difficulty) ? "selected" : "" %>>
                Intermediate
            </option>

            <option value="Advanced"
                <%= "Advanced".equalsIgnoreCase(difficulty) ? "selected" : "" %>>
                Advanced
            </option>

        </select>

        <label>Duration</label>

        <input type="text"
               name="duration"
               value="<%= duration %>"
               required>

        <button type="submit">Update Course</button>

        <a class="back-btn"
           href="<%= context %>/admin-courses">
            Cancel
        </a>

    </form>

</div>

</body>
</html>
