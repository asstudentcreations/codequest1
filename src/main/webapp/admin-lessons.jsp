
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.AdminLessonsServlet.AdminLesson" %>

<%
    String context = request.getContextPath();

    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(context + "/admin-login.jsp");
        return;
    }

    List<AdminLesson> lessons =
        (List<AdminLesson>) request.getAttribute("lessons");

    if (lessons == null) {
        response.sendRedirect(context + "/admin-lessons");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Lessons | CodeQuest</title>

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
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

.logo {
    font-size: 25px;
    font-weight: bold;
}

.logo span {
    color: #60a5fa;
}

header a {
    color: white;
    text-decoration: none;
    margin-left: 16px;
    font-size: 14px;
}

.container {
    max-width: 1150px;
    margin: 35px auto;
    padding: 0 20px;
}

h1 {
    margin-bottom: 8px;
}

.subtitle {
    color: #64748b;
    margin-bottom: 25px;
    line-height: 1.6;
}

.summary {
    background: white;
    padding: 22px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 25px;
}

.summary p {
    color: #64748b;
    margin: 0 0 8px;
}

.summary h2 {
    margin: 0;
    color: #2563eb;
    font-size: 30px;
}

.table-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    overflow: hidden;
}

.table-title {
    padding: 20px;
    font-size: 18px;
    font-weight: bold;
    border-bottom: 1px solid #e5e7eb;
}

.table-wrap {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 950px;
    border-collapse: collapse;
}

th, td {
    text-align: left;
    padding: 15px;
    border-bottom: 1px solid #e5e7eb;
    font-size: 14px;
}

th {
    background: #f8fafc;
    color: #475569;
}

tr:last-child td {
    border-bottom: none;
}

.badge {
    display: inline-block;
    background: #dbeafe;
    color: #1d4ed8;
    padding: 6px 10px;
    border-radius: 15px;
    font-size: 12px;
}

.empty {
    padding: 25px;
    text-align: center;
    color: #64748b;
}

.add-btn {
    display: inline-block;
    padding: 10px 16px;
    background: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}

.edit-btn {
    display: inline-block;
    padding: 8px 13px;
    background: #16a34a;
    color: white;
    text-decoration: none;
    border-radius: 5px;
}

.delete-btn {
    background: #dc2626;
    color: white;
    padding: 8px 13px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.back-btn {
    display: inline-block;
    margin-top: 22px;
    padding: 11px 17px;
    background: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}

.action-form {
    display: inline;
}

footer {
    text-align: center;
    padding: 25px;
    color: #94a3b8;
    font-size: 12px;
}

@media (max-width: 600px) {
    .container {
        margin-top: 22px;
        padding: 0 12px;
    }
}

</style>

</head>

<body>

<header>

    <div class="logo">
        Code<span>Quest</span>
    </div>

    <nav>
        <a href="<%= context %>/admin-dashboard">Dashboard</a>
        <a href="<%= context %>/admin-students">Students</a>
        <a href="<%= context %>/admin-courses">Courses</a>
        <a href="<%= context %>/admin-missions">Missions</a>
        <a href="<%= context %>/admin-logout">Logout</a>
    </nav>

</header>

<main class="container">

    <h1>Manage Lessons</h1>

    <p>
        <a class="add-btn" href="<%= context %>/add-lesson">
            + Add New Lesson
        </a>
    </p>

    <p class="subtitle">
        View and manage all lessons available in different courses on CodeQuest.
    </p>

    <div class="summary">

        <p>Total Lessons</p>

        <h2><%= lessons.size() %></h2>

    </div>

    <section class="table-card">

        <div class="table-title">
            Lesson Details
        </div>

        <div class="table-wrap">

            <table>

                <thead>

                    <tr>
                        <th>Lesson ID</th>
                        <th>Course ID</th>
                        <th>Course Name</th>
                        <th>Lesson Title</th>
                        <th>Lesson Order</th>
                        <th>Action</th>
                    </tr>

                </thead>

                <tbody>

                <%
                    if (lessons.isEmpty()) {
                %>

                    <tr>
                        <td colspan="6" class="empty">
                            No lessons found.
                        </td>
                    </tr>

                <%
                    } else {
                        for (AdminLesson lesson : lessons) {
                %>

                    <tr>

                        <td>
                            <%= lesson.getLessonId() %>
                        </td>

                        <td>
                            <%= lesson.getCourseId() %>
                        </td>

                        <td>
                            <%= lesson.getCourseTitle() %>
                        </td>

                        <td>
                            <%= lesson.getTitle() %>
                        </td>

                        <td>
                            <span class="badge">
                                <%= lesson.getLessonOrder() %>
                            </span>
                        </td>

                        <td>

                            <a class="edit-btn"
                               href="<%= context %>/edit-lesson?lessonId=<%= lesson.getLessonId() %>">
                                Edit
                            </a>

                            <form class="action-form"
                                  action="<%= context %>/delete-lesson"
                                  method="post"
                                  onsubmit="return confirm('Are you sure you want to delete this lesson?');">

                                <input type="hidden"
                                       name="lessonId"
                                       value="<%= lesson.getLessonId() %>">

                                <button type="submit" class="delete-btn">
                                    Delete
                                </button>

                            </form>

                        </td>

                    </tr>

                <%
                        }
                    }
                %>

                </tbody>

            </table>

        </div>

    </section>

    <a class="back-btn"
       href="<%= context %>/admin-dashboard">
        ← Back to Dashboard
    </a>

</main>

<footer>
    © 2026 CodeQuest | Lesson Management
</footer>

</body>
</html>
