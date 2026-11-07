
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.EditLessonServlet.CourseOption" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String context = request.getContextPath();

    if (request.getAttribute("courses") == null) {
        response.sendRedirect(context + "/admin-lessons");
        return;
    }

    Integer lessonIdValue = (Integer) request.getAttribute("lessonId");
    Integer courseIdValue = (Integer) request.getAttribute("courseId");
    Integer lessonOrderValue = (Integer) request.getAttribute("lessonOrder");

    int lessonId = lessonIdValue;
    int selectedCourseId = courseIdValue;
    int lessonOrder = lessonOrderValue;

    String title = (String) request.getAttribute("title");
    String content = (String) request.getAttribute("content");
    String codeExample = (String) request.getAttribute("codeExample");
    String outputExample = (String) request.getAttribute("outputExample");

    List<CourseOption> courses =
        (List<CourseOption>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Lesson - CodeQuest</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }

        .container {
            max-width: 700px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            margin-bottom: 18px;
            box-sizing: border-box;
        }

        button, .back {
            padding: 10px 18px;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button {
            background: #2563eb;
            color: white;
        }

        .back {
            background: #ddd;
            color: black;
        }

        .error {
            color: red;
        }
    </style>
</head>

<body>

<div class="container">

    <h1>Edit Lesson</h1>

    <%
        if ("invalid".equals(request.getParameter("error"))) {
    %>
        <p class="error">Please enter valid lesson details.</p>
    <%
        }
    %>

    <form action="<%= context %>/edit-lesson" method="post">

        <input type="hidden" name="lessonId"
               value="<%= lessonId %>">

        <label>Select Course:</label>

        <select name="courseId" required>
            <%
                for (CourseOption course : courses) {
            %>
                <option value="<%= course.getCourseId() %>"
                    <%= course.getCourseId() == selectedCourseId
                        ? "selected" : "" %>>
                    <%= course.getTitle() %>
                </option>
            <%
                }
            %>
        </select>

        <label>Lesson Title:</label>

        <input type="text" name="title"
               value="<%= title == null ? "" : title %>" required>

        <label>Lesson Content:</label>

        <textarea name="content" rows="6" required><%= content == null ? "" : content %></textarea>

        <label>Code Example:</label>

        <textarea name="codeExample" rows="8"><%= codeExample == null ? "" : codeExample %></textarea>

        <label>Output Example:</label>

        <textarea name="outputExample" rows="4"><%= outputExample == null ? "" : outputExample %></textarea>

        <label>Lesson Order:</label>

        <input type="number" name="lessonOrder"
               value="<%= lessonOrder %>" min="1" required>

        <button type="submit">Update Lesson</button>

        <a class="back" href="<%= context %>/admin-lessons">
            Cancel
        </a>

    </form>

</div>

</body>
</html>
