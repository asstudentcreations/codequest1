
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest - Add Course</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: #f4f6fb;
    margin: 0;
    padding: 30px;
}
.container {
    max-width: 650px;
    margin: 20px auto;
    background: white;
    padding: 25px;
    border-radius: 10px;
}
h2 { color: #253858; }
label {
    display: block;
    margin-top: 15px;
    font-weight: bold;
}
input, textarea, select {
    width: 100%;
    padding: 10px;
    margin-top: 6px;
    box-sizing: border-box;
}
textarea {
    height: 100px;
    resize: vertical;
}
button, .back {
    display: inline-block;
    margin-top: 20px;
    padding: 11px 18px;
    border: none;
    border-radius: 5px;
    text-decoration: none;
    cursor: pointer;
}
button {
    background: #2563eb;
    color: white;
}
.back {
    background: #e5e7eb;
    color: #222;
}
.error { color: #dc2626; }
</style>
</head>
<body>

<div class="container">
    <h2>Add New Course</h2>
    <p>Enter the course details below.</p>

    <% if ("empty".equals(error)) { %>
        <p class="error">Please fill in all fields.</p>
    <% } else if ("database".equals(error)) { %>
        <p class="error">Unable to add course. Please check the server console.</p>
    <% } %>

    <form action="<%= request.getContextPath() %>/add-course"
          method="post">

        <label>Course Title</label>
        <input type="text" name="title"
               placeholder="Example: Java Programming" required>

        <label>Description</label>
        <textarea name="description"
                  placeholder="Enter course description"
                  required></textarea>

        <label>Category</label>
        <select name="category" required>
            <option value="">Select Category</option>
            <option value="Programming">Programming</option>
            <option value="Data Structures and Algorithms">Data Structures and Algorithms</option>
            <option value="Web Development">Web Development</option>
            <option value="Database">Database</option>
            <option value="Artificial Intelligence">Artificial Intelligence</option>
            <option value="Developer Tools">Developer Tools</option>
        </select>

        <label>Difficulty</label>
        <select name="difficulty" required>
            <option value="">Select Difficulty</option>
            <option value="Beginner">Beginner</option>
            <option value="Intermediate">Intermediate</option>
            <option value="Advanced">Advanced</option>
        </select>

        <label>Duration</label>
        <input type="text" name="duration"
               placeholder="Example: 6 Weeks" required>

        <button type="submit">Add Course</button>

        <a class="back"
           href="<%= request.getContextPath() %>/admin-courses">
            Back to Courses
        </a>
    </form>
</div>

</body>
</html>
