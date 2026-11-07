
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.AddLessonServlet.CourseOption" %>

<%
    String context = request.getContextPath();

    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(context + "/admin-login.jsp");
        return;
    }

    List<CourseOption> courses =
        (List<CourseOption>) request.getAttribute("courses");

    if (courses == null) {
        response.sendRedirect(context + "/add-lesson");
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Add Lesson | CodeQuest</title>

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
    font-size: 25px;
    font-weight: bold;
}

header span {
    color: #60a5fa;
}

.container {
    max-width: 700px;
    margin: 35px auto;
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
    line-height: 1.6;
    margin-bottom: 25px;
}

label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
}

input, textarea, select {
    width: 100%;
    box-sizing: border-box;
    padding: 12px;
    margin-bottom: 20px;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
    font-size: 14px;
    font-family: Arial, sans-serif;
}

textarea {
    min-height: 110px;
    resize: vertical;
}

button {
    padding: 12px 20px;
    background: #2563eb;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    cursor: pointer;
}

button:hover {
    background: #1d4ed8;
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

.error {
    background: #fee2e2;
    color: #991b1b;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 20px;
}

</style>

</head>

<body>

<header>
    Code<span>Quest</span>
</header>

<div class="container">

    <h1>Add New Lesson</h1>

    <p class="subtitle">
        Select a course and enter the new lesson details.
    </p>

    <% if ("empty".equals(error)) { %>

        <div class="error">
            Please fill in all required fields.
        </div>

    <% } else if ("invalid".equals(error)) { %>

        <div class="error">
            Please enter valid course and lesson order values.
        </div>

    <% } else if ("database".equals(error)) { %>

        <div class="error">
            Unable to save lesson. Please try again.
        </div>

    <% } %>

    <form action="<%= context %>/add-lesson" method="post">

        <label>Select Course *</label>

        <select name="courseId" required>

            <option value="">-- Select Course --</option>

            <%
                for (CourseOption course : courses) {
            %>

                <option value="<%= course.getCourseId() %>">
                    <%= course.getTitle() %>
                </option>

            <%
                }
            %>

        </select>

        <label>Lesson Title *</label>

        <input type="text"
               name="title"
               placeholder="Enter lesson title"
               required>

        <label>Lesson Content *</label>

        <textarea name="content"
                  placeholder="Enter lesson explanation"
                  required></textarea>

        <label>Code Example</label>

        <textarea name="codeExample"
                  placeholder="Enter programming code example"></textarea>

        <label>Output Example</label>

        <textarea name="outputExample"
                  placeholder="Enter expected output"></textarea>

        <label>Lesson Order *</label>

        <input type="number"
               name="lessonOrder"
               min="1"
               placeholder="Example: 11"
               required>

        <button type="submit">
            Save Lesson
        </button>

        <a class="back-btn"
           href="<%= context %>/admin-lessons">
            Cancel
        </a>

    </form>

</div>

</body>
</html>
