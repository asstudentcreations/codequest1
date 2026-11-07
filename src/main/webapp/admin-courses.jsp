
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.AdminCoursesServlet.AdminCourse" %>

<%
    String context = request.getContextPath();

    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(context + "/admin-login.jsp");
        return;
    }

    List<AdminCourse> courses =
        (List<AdminCourse>) request.getAttribute("courses");

    if (courses == null) {
        response.sendRedirect(context + "/admin-courses");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Courses | CodeQuest</title>

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

.add-btn {
    display: inline-block;
    padding: 11px 17px;
    background: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 6px;
    margin-bottom: 20px;
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
    min-width: 850px;
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

.edit-btn {
    display: inline-block;
    background: #2563eb;
    color: white;
    padding: 7px 12px;
    text-decoration: none;
    border-radius: 5px;
}

.delete-btn {
    background: #dc2626;
    color: white;
    padding: 7px 12px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.empty {
    padding: 25px;
    text-align: center;
    color: #64748b;
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
        <a href="<%= context %>/admin-missions">Missions</a>
        <a href="<%= context %>/admin-logout">Logout</a>
    </nav>

</header>

<main class="container">

    <h1>Manage Courses</h1>

    <a class="add-btn" href="<%= context %>/add-course.jsp">
        + Add New Course
    </a>

    <p class="subtitle">
        View and manage all courses available on the CodeQuest learning platform.
    </p>

    <div class="summary">

        <p>Total Courses</p>

        <h2><%= courses.size() %></h2>

    </div>

    <section class="table-card">

        <div class="table-title">
            Course Details
        </div>

        <div class="table-wrap">

            <table>

                <thead>

                    <tr>
                        <th>Course ID</th>
                        <th>Course Name</th>
                        <th>Category</th>
                        <th>Difficulty</th>
                        <th>Duration</th>
                        <th>Total Lessons</th>
                        <th>Actions</th>
                    </tr>

                </thead>

                <tbody>

                <%
                    if (courses.isEmpty()) {
                %>

                    <tr>
                        <td colspan="7" class="empty">
                            No courses found.
                        </td>
                    </tr>

                <%
                    } else {

                        for (AdminCourse course : courses) {
                %>

                    <tr>

                        <td>
                            <%= course.getCourseId() %>
                        </td>

                        <td>
                            <%= course.getTitle() %>
                        </td>

                        <td>
                            <%= course.getCategory() %>
                        </td>

                        <td>
                            <span class="badge">
                                <%= course.getDifficulty() %>
                            </span>
                        </td>

                        <td>
                            <%= course.getDuration() %>
                        </td>

                        <td>
                            <%= course.getTotalLessons() %>
                        </td>

                        <td>

                            <a class="edit-btn"
                               href="<%= context %>/edit-course?id=<%= course.getCourseId() %>">
                                Edit
                            </a>

                            <form action="<%= context %>/delete-course"
                                  method="post"
                                  style="display:inline;"
                                  onsubmit="return confirm('Are you sure you want to delete this course?');">

                                <input type="hidden"
                                       name="courseId"
                                       value="<%= course.getCourseId() %>">

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

    <a class="back-btn" href="<%= context %>/admin-dashboard">
        ← Back to Dashboard
    </a>

</main>

<footer>
    © 2026 CodeQuest | Course Management
</footer>

</body>
</html>
