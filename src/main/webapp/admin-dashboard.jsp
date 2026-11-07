<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String context = request.getContextPath();

    // Admin session validation
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(context + "/admin-login.jsp");
        return;
    }

    // Get admin username from session
    String adminName = (String) session.getAttribute("adminUsername");

    if (adminName == null || adminName.trim().isEmpty()) {
        adminName = "Administrator";
    }

    // ServletContext: Read application name from web.xml
    String applicationName =
            getServletContext().getInitParameter("applicationName");

    if (applicationName == null || applicationName.trim().isEmpty()) {
        applicationName = "CodeQuest";
    }

    // Get dashboard statistics
    Integer students = (Integer) request.getAttribute("totalStudents");
    Integer courses = (Integer) request.getAttribute("totalCourses");
    Integer lessons = (Integer) request.getAttribute("totalLessons");
    Integer missions = (Integer) request.getAttribute("totalMissions");

    int totalStudents = students == null ? 0 : students;
    int totalCourses = courses == null ? 0 : courses;
    int totalLessons = lessons == null ? 0 : lessons;
    int totalMissions = missions == null ? 0 : missions;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard | CodeQuest</title>

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

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 245px;
            background: #111827;
            color: white;
            padding: 28px 18px;
            flex-shrink: 0;
        }

        .brand {
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .brand span {
            color: #60a5fa;
        }

        .tagline {
            font-size: 12px;
            color: #9ca3af;
            margin-bottom: 38px;
        }

        .menu-title {
            font-size: 11px;
            color: #9ca3af;
            margin: 22px 10px 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar a {
            display: block;
            padding: 13px 12px;
            margin: 7px 0;
            text-decoration: none;
            color: #d1d5db;
            border-radius: 8px;
            font-size: 14px;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #263449;
            color: white;
        }

        .sidebar a.active {
            border-left: 3px solid #60a5fa;
        }

        .main {
            flex: 1;
            min-width: 0;
        }

        .topbar {
            background: white;
            padding: 20px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid #e5e7eb;
        }

        .topbar h2 {
            font-size: 21px;
        }

        .admin-info {
            font-size: 14px;
            color: #475569;
        }

        .content {
            padding: 32px;
        }

        .welcome {
            background: linear-gradient(120deg, #1d4ed8, #6d5dfc);
            color: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 28px;
        }

        .welcome h1 {
            font-size: 27px;
            margin-bottom: 12px;
        }

        .welcome p {
            color: #e0e7ff;
            line-height: 1.7;
            max-width: 650px;
        }

        .section-title {
            font-size: 20px;
            margin-bottom: 18px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 34px;
        }

        .stat-card {
            background: white;
            padding: 23px;
            border: 1px solid #e5e7eb;
            border-radius: 13px;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.04);
        }

        .stat-icon {
            font-size: 25px;
            margin-bottom: 17px;
        }

        .stat-label {
            color: #64748b;
            font-size: 13px;
            margin-bottom: 9px;
        }

        .stat-number {
            font-size: 30px;
            font-weight: bold;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .action-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 13px;
            padding: 24px;
            transition: 0.2s;
        }

        .action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.07);
        }

        .action-card h3 {
            margin-bottom: 10px;
            font-size: 18px;
        }

        .action-card p {
            color: #64748b;
            font-size: 14px;
            line-height: 1.7;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 11px 16px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 7px;
            font-size: 13px;
            font-weight: bold;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .btn.secondary {
            background: #111827;
        }

        .btn.secondary:hover {
            background: #374151;
        }

        .footer {
            padding: 24px 32px;
            color: #94a3b8;
            font-size: 12px;
            text-align: center;
        }

        @media (max-width: 1050px) {
            .stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 700px) {
            .layout {
                display: block;
            }

            .sidebar {
                width: 100%;
            }

            .tagline {
                margin-bottom: 15px;
            }

            .topbar {
                padding: 18px;
                flex-wrap: wrap;
            }

            .content {
                padding: 18px;
            }

            .stats,
            .actions {
                grid-template-columns: 1fr;
            }
        }

    </style>

</head>

<body>

<div class="layout">

    <!-- SIDEBAR -->

    <aside class="sidebar">

        <div class="brand">
            Code<span>Quest</span>
        </div>

        <div class="tagline">
            ADMIN CONTROL PANEL
        </div>

        <div class="menu-title">
            Main Menu
        </div>

        <a class="active" href="<%= context %>/admin-dashboard">
            🏠 Dashboard
        </a>

        <a href="<%= context %>/admin-students">
            👨‍🎓 Manage Students
        </a>

        <a href="<%= context %>/admin-courses">
            📚 Manage Courses
        </a>

        <a href="<%= context %>/add-course.jsp">
            ➕ Add New Course
        </a>

        <a href="<%= context %>/admin-lessons">
            📖 Manage Lessons
        </a>

        <a href="<%= context %>/admin-missions">
            🎯 Manage Missions
        </a>

        <a href="<%= context %>/add-mission.jsp">
            ➕ Add New Mission
        </a>

        <div class="menu-title">
            Account
        </div>

        <a href="<%= context %>/admin-logout">
            🚪 Logout
        </a>

    </aside>


    <!-- MAIN CONTENT -->

    <main class="main">

        <header class="topbar">

            <h2>Admin Dashboard</h2>

            <div class="admin-info">
                Welcome, <strong><%= adminName %></strong>
            </div>

        </header>


        <section class="content">

            <div class="welcome">

                <!-- ServletContext application name -->

                <h1>Welcome to <%= applicationName %>! 👋</h1>

                <p>
                    Manage your programming learning platform from one place.
                    Monitor students, courses, lessons and coding missions.
                    Help students learn, practise and improve their skills.
                </p>

            </div>


            <!-- PLATFORM OVERVIEW -->

            <h2 class="section-title">
                Platform Overview
            </h2>


            <div class="stats">

                <div class="stat-card">

                    <div class="stat-icon">👨‍🎓</div>

                    <div class="stat-label">
                        Registered Students
                    </div>

                    <div class="stat-number">
                        <%= totalStudents %>
                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon">📚</div>

                    <div class="stat-label">
                        Total Courses
                    </div>

                    <div class="stat-number">
                        <%= totalCourses %>
                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon">📖</div>

                    <div class="stat-label">
                        Total Lessons
                    </div>

                    <div class="stat-number">
                        <%= totalLessons %>
                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon">🎯</div>

                    <div class="stat-label">
                        Total Missions
                    </div>

                    <div class="stat-number">
                        <%= totalMissions %>
                    </div>

                </div>

            </div>


            <!-- QUICK ACTIONS -->

            <h2 class="section-title">
                Quick Actions
            </h2>


            <div class="actions">


                <div class="action-card">

                    <h3>👨‍🎓 Manage Students</h3>

                    <p>
                        View registered students, email addresses,
                        XP points and levels.
                    </p>

                    <a class="btn"
                       href="<%= context %>/admin-students">
                        View Students
                    </a>

                </div>


                <div class="action-card">

                    <h3>📚 Manage Courses</h3>

                    <p>
                        View all courses, categories, difficulty levels
                        and lesson counts.
                    </p>

                    <a class="btn"
                       href="<%= context %>/admin-courses">
                        View Courses
                    </a>

                </div>


                <div class="action-card">

                    <h3>➕ Add New Course</h3>

                    <p>
                        Add a new programming course with its description,
                        category, difficulty and duration.
                    </p>

                    <a class="btn"
                       href="<%= context %>/add-course.jsp">
                        Add Course
                    </a>

                </div>


                <div class="action-card">

                    <h3>📖 Manage Lessons</h3>

                    <p>
                        View all lessons, course names and lesson order
                        available on the CodeQuest platform.
                    </p>

                    <a class="btn"
                       href="<%= context %>/admin-lessons">
                        View Lessons
                    </a>

                </div>


                <div class="action-card">

                    <h3>🎯 Manage Missions</h3>

                    <p>
                        View programming questions, correct answers
                        and XP rewards.
                    </p>

                    <a class="btn"
                       href="<%= context %>/admin-missions">
                        View Missions
                    </a>

                </div>


                <div class="action-card">

                    <h3>➕ Create a Mission</h3>

                    <p>
                        Add a programming question with four options
                        and an XP reward.
                    </p>

                    <a class="btn"
                       href="<%= context %>/add-mission.jsp">
                        Add Mission
                    </a>

                </div>


                <div class="action-card">

                    <h3>🔄 Refresh Statistics</h3>

                    <p>
                        Reload the latest student, course, lesson
                        and mission counts.
                    </p>

                    <a class="btn secondary"
                       href="<%= context %>/admin-dashboard">
                        Refresh Dashboard
                    </a>

                </div>


                <div class="action-card">

                    <h3>🔐 Admin Account</h3>

                    <p>
                        End your admin session after completing your work.
                    </p>

                    <a class="btn secondary"
                       href="<%= context %>/admin-logout">
                        Logout
                    </a>

                </div>


            </div>

        </section>


        <footer class="footer">

            © 2026 CodeQuest | Admin Control Panel

        </footer>

    </main>

</div>

</body>

</html>