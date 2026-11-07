
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.Course" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Programming Courses | CodeQuest</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #172033;
        }

        nav {
            background: #172554;
            padding: 18px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: white;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 16px;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 35px auto;
        }

        .hero {
            background: linear-gradient(120deg, #1e3a8a, #6d28d9);
            color: white;
            padding: 35px;
            border-radius: 16px;
            margin-bottom: 30px;
        }

        .hero h1 {
            margin-top: 0;
            font-size: 32px;
        }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
            gap: 22px;
        }

        .course-card {
            background: white;
            padding: 24px;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            display: flex;
            flex-direction: column;
        }

        .course-icon {
            font-size: 35px;
            margin-bottom: 12px;
        }

        .course-card h2 {
            color: #1e3a8a;
            font-size: 21px;
            margin: 0 0 12px;
        }

        .description {
            color: #64748b;
            line-height: 1.6;
            flex-grow: 1;
        }

        .tag {
            display: inline-block;
            background: #e0e7ff;
            color: #3730a3;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            margin: 4px 4px 8px 0;
        }

        .progress-heading {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            font-size: 13px;
            margin-top: 18px;
        }

        .progress-track {
            height: 9px;
            background: #e5e7eb;
            border-radius: 20px;
            overflow: hidden;
            margin: 10px 0 18px;
        }

        .progress-fill {
            height: 100%;
            background: #16a34a;
            border-radius: 20px;
        }

        .button {
            display: block;
            text-align: center;
            background: #2563eb;
            color: white;
            padding: 12px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            margin-top: auto;
        }

        .button:hover {
            background: #1d4ed8;
        }

        .empty {
            background: white;
            padding: 25px;
            border-radius: 12px;
        }

        footer {
            text-align: center;
            padding: 25px;
            color: #64748b;
        }

        @media (max-width: 600px) {
            nav a {
                margin: 5px 10px 5px 0;
            }

            .hero {
                padding: 24px;
            }

            .hero h1 {
                font-size: 26px;
            }
        }
    </style>
</head>

<body>

<nav>
    <span class="logo">CodeQuest</span>

    <div>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/profile">My Profile</a>
        <a href="<%= request.getContextPath() %>/courses">Courses</a>
        <a href="<%= request.getContextPath() %>/missions">Missions</a>
        <a href="<%= request.getContextPath() %>/leaderboard">Leaderboard</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <section class="hero">
        <h1>Explore Programming Courses</h1>
        <p>Learn step by step, complete lessons, track your progress, and improve your coding skills.</p>
    </section>

    <div class="course-grid">

        <% if (courses == null || courses.isEmpty()) { %>

            <div class="empty">
                <h2>No courses available</h2>
                <p>Please check again later.</p>
            </div>

        <% } else { %>

            <% for (Course course : courses) {

                String icon = "📘";

                if ("DSA".equalsIgnoreCase(course.getCategory())
                        || course.getTitle().toLowerCase().contains("data structures")) {
                    icon = "🧠";
                } else if (course.getTitle().toLowerCase().contains("java")) {
                    icon = "☕";
                } else if (course.getTitle().toLowerCase().contains("python")) {
                    icon = "🐍";
                } else if (course.getCategory().toLowerCase().contains("web")) {
                    icon = "🌐";
                } else if (course.getCategory().toLowerCase().contains("database")) {
                    icon = "🗄️";
                } else if (course.getCategory().toLowerCase().contains("ai")) {
                    icon = "🤖";
                } else if (course.getTitle().toLowerCase().contains("git")) {
                    icon = "🔧";
                }

                int total = course.getTotalLessons();
                int completed = course.getCompletedLessons();
                int percentage = course.getProgressPercentage();
            %>

                <article class="course-card">

                    <div class="course-icon"><%= icon %></div>

                    <h2><%= course.getTitle() %></h2>

                    <p class="description">
                        <%= course.getDescription() == null
                            ? "Start learning this course with CodeQuest."
                            : course.getDescription() %>
                    </p>

                    <div>
                        <span class="tag"><%= course.getCategory() %></span>
                        <span class="tag"><%= course.getDifficulty() %></span>
                        <span class="tag"><%= course.getDuration() %></span>
                    </div>

                    <div class="progress-heading">
                        <span>
                            <%= completed %> / <%= total %> lessons completed
                        </span>

                        <strong><%= percentage %>%</strong>
                    </div>

                    <div class="progress-track">
                        <div class="progress-fill"
                             style="width: <%= percentage %>%;">
                        </div>
                    </div>

                    <a class="button"
                       href="<%= request.getContextPath() %>/course-details?id=<%= course.getCourseId() %>">
                        <%= percentage == 100 && total > 0
                            ? "Review Course"
                            : "Continue Learning" %>
                    </a>

                </article>

            <% } %>

        <% } %>

    </div>
</div>

<footer>
    CodeQuest — Learn Coding. Play. Grow. Win.
</footer>

</body>
</html>
