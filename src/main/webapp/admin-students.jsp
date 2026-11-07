<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.codequest.servlet.AdminStudentsServlet.Student" %>
<%
    String context = request.getContextPath();

    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(context + "/admin-login.jsp");
        return;
    }

    List<Student> students =
        (List<Student>) request.getAttribute("students");

    if (students == null) {
        response.sendRedirect(context + "/admin-students");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Students | CodeQuest</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background: #f4f7fb;
    color: #172033;
}

.header {
    background: #111827;
    color: white;
    padding: 22px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
}

.logo {
    font-size: 25px;
    font-weight: bold;
}

.logo span {
    color: #60a5fa;
}

.header a {
    color: white;
    text-decoration: none;
    margin-left: 18px;
    font-size: 14px;
}

.container {
    max-width: 1200px;
    margin: 35px auto;
    padding: 0 22px;
}

.page-title {
    margin-bottom: 8px;
    font-size: 28px;
}

.subtitle {
    color: #64748b;
    margin-bottom: 25px;
    line-height: 1.6;
}

.summary {
    background: white;
    padding: 22px;
    border-radius: 12px;
    border: 1px solid #e5e7eb;
    margin-bottom: 25px;
}

.summary span {
    color: #64748b;
    font-size: 14px;
}

.summary h2 {
    margin-top: 10px;
    font-size: 30px;
    color: #2563eb;
}

.table-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    overflow: hidden;
}

.table-heading {
    padding: 20px;
    border-bottom: 1px solid #e5e7eb;
    font-size: 18px;
    font-weight: bold;
}

.table-wrap {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 650px;
}

th, td {
    padding: 16px 20px;
    text-align: left;
    border-bottom: 1px solid #edf0f5;
    font-size: 14px;
}

th {
    background: #f8fafc;
    color: #475569;
}

tr:last-child td {
    border-bottom: none;
}

tr:hover td {
    background: #f8fbff;
}

.badge {
    display: inline-block;
    padding: 6px 12px;
    border-radius: 20px;
    background: #dbeafe;
    color: #1d4ed8;
    font-weight: bold;
    font-size: 12px;
}

.xp {
    font-weight: bold;
    color: #15803d;
}

.empty {
    text-align: center;
    padding: 35px;
    color: #64748b;
}

.back-btn {
    display: inline-block;
    margin-top: 24px;
    padding: 12px 18px;
    background: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 7px;
    font-size: 14px;
}

.back-btn:hover {
    background: #1d4ed8;
}

.footer {
    text-align: center;
    padding: 25px;
    color: #94a3b8;
    font-size: 12px;
}

@media (max-width: 600px) {
    .container {
        margin-top: 24px;
        padding: 0 14px;
    }

    .page-title {
        font-size: 23px;
    }
}
</style>
</head>

<body>

<header class="header">
    <div class="logo">Code<span>Quest</span></div>

    <nav>
        <a href="<%= context %>/admin-dashboard">Dashboard</a>
        <a href="<%= context %>/admin-missions">Missions</a>
        <a href="<%= context %>/admin-logout">Logout</a>
    </nav>
</header>

<main class="container">

    <h1 class="page-title">Registered Students</h1>

    <p class="subtitle">
        View student accounts and monitor their coding progress.
    </p>

    <div class="summary">
        <span>Total Registered Students</span>
        <h2><%= students.size() %></h2>
    </div>

    <section class="table-card">

        <div class="table-heading">Student Details</div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Username</th>
                        <th>Email Address</th>
                        <th>Total XP</th>
                        <th>Level</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    if (students.isEmpty()) {
                %>
                    <tr>
                        <td colspan="5" class="empty">
                            No students registered yet.
                        </td>
                    </tr>
                <%
                    } else {
                        for (Student student : students) {
                %>
                    <tr>
                        <td><%= student.getUserId() %></td>
                        <td><%= student.getUsername() %></td>
                        <td><%= student.getEmail() %></td>
                        <td class="xp"><%= student.getXp() %> XP</td>
                        <td>
                            <span class="badge">
                                Level <%= student.getLevel() %>
                            </span>
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

<footer class="footer">
    © 2026 CodeQuest | Student Management
</footer>

</body>
</html>
    