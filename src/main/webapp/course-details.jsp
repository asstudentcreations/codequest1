
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.CourseLesson" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Integer courseId = (Integer) request.getAttribute("courseId");
    String courseTitle = (String) request.getAttribute("courseTitle");
    String courseDescription = (String) request.getAttribute("courseDescription");
    String courseCategory = (String) request.getAttribute("courseCategory");
    String courseDifficulty = (String) request.getAttribute("courseDifficulty");
    String courseDuration = (String) request.getAttribute("courseDuration");

    List<CourseLesson> lessons =
        (List<CourseLesson>) request.getAttribute("lessons");

    Integer currentIndexValue =
        (Integer) request.getAttribute("currentIndex");

    int currentIndex =
        currentIndexValue == null ? 0 : currentIndexValue;

    int completedCount = 0;

    if (lessons != null) {
        for (CourseLesson lesson : lessons) {
            if (lesson.isCompleted()) {
                completedCount++;
            }
        }
    }

    int totalLessons = (lessons == null) ? 0 : lessons.size();

    int progress = totalLessons == 0 ? 0 :
                   (completedCount * 100 / totalLessons);

    String message = request.getParameter("completed");

    CourseLesson currentLesson = null;

    if (lessons != null && !lessons.isEmpty()) {
        if (currentIndex < 0 || currentIndex >= lessons.size()) {
            currentIndex = 0;
        }

        currentLesson = lessons.get(currentIndex);
    }

    String baseUrl = request.getContextPath() + "/course-details?id=" + courseId;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Course Details - CodeQuest</title>

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

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 16px;
        }

        .logo {
            font-size: 23px;
            font-weight: bold;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 30px auto;
        }

        .course-header {
            background: linear-gradient(120deg, #1e3a8a, #6d28d9);
            color: white;
            padding: 32px;
            border-radius: 16px;
            margin-bottom: 25px;
        }

        .course-header h1 {
            margin-top: 0;
        }

        .tag {
            display: inline-block;
            background: rgba(255,255,255,0.18);
            padding: 7px 12px;
            border-radius: 20px;
            margin: 5px 5px 5px 0;
        }

        .progress-card, .lesson-card {
            background: white;
            padding: 23px;
            margin-bottom: 18px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.06);
        }

        .progress-track {
            height: 12px;
            background: #e5e7eb;
            border-radius: 20px;
            overflow: hidden;
            margin-top: 12px;
        }

        .progress-fill {
            height: 100%;
            background: #16a34a;
            width: <%= progress %>%;
        }

        .lesson-card h2 {
            margin-top: 0;
            color: #1e3a8a;
        }

        pre {
            background: #111827;
            color: #d1fae5;
            padding: 16px;
            border-radius: 8px;
            overflow-x: auto;
            white-space: pre-wrap;
        }

        .output {
            background: #ecfdf5;
            padding: 12px;
            border-radius: 7px;
            white-space: pre-wrap;
        }

        .button {
            display: inline-block;
            border: none;
            border-radius: 7px;
            padding: 11px 17px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        .button:hover {
            background: #1d4ed8;
        }

        .button:disabled {
            background: #9ca3af;
            cursor: not-allowed;
        }

        .completed {
            color: #15803d;
            font-weight: bold;
        }

        .notice {
            padding: 14px;
            border-radius: 8px;
            background: #dcfce7;
            color: #166534;
            margin-bottom: 20px;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #1d4ed8;
            text-decoration: none;
        }

        .navigation {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 25px;
        }

        .lesson-number {
            color: #64748b;
            font-weight: bold;
            margin-bottom: 20px;
        }

        @media (max-width: 600px) {
            nav {
                align-items: flex-start;
            }

            nav a {
                margin: 5px 10px 5px 0;
            }

            .course-header {
                padding: 22px;
            }

            .navigation {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<nav>
    <span class="logo">CodeQuest</span>

    <div>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/courses">Courses</a>
        <a href="<%= request.getContextPath() %>/profile">Profile</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <a class="back-link"
       href="<%= request.getContextPath() %>/courses">
        &larr; Back to Courses
    </a>

    <% if ("1".equals(message)) { %>
        <div class="notice">
            Lesson progress saved successfully!
        </div>
    <% } %>

    <section class="course-header">

        <h1><%= courseTitle == null ? "Course Details" : courseTitle %></h1>

        <p><%= courseDescription == null ? "" : courseDescription %></p>

        <span class="tag">
            <%= courseCategory == null ? "" : courseCategory %>
        </span>

        <span class="tag">
            <%= courseDifficulty == null ? "" : courseDifficulty %>
        </span>

        <span class="tag">
            <%= courseDuration == null ? "" : courseDuration %>
        </span>

    </section>

    <section class="progress-card">

        <h2>Your Learning Progress</h2>

        <p>
            Completed: <strong><%= completedCount %></strong>
            out of <strong><%= totalLessons %></strong> lessons
        </p>

        <div class="progress-track">
            <div class="progress-fill"></div>
        </div>

        <p><strong><%= progress %>% completed</strong></p>

    </section>

    <h2>Course Lessons</h2>

    <% if (currentLesson == null) { %>

        <div class="lesson-card">
            <p>Lessons are coming soon!</p>
        </div>

    <% } else { %>

        <article class="lesson-card">

            <div class="lesson-number">
                Lesson <%= currentIndex + 1 %> of <%= totalLessons %>
            </div>

            <h2>
                <%= currentLesson.getTitle() %>
            </h2>

            <p>
                <%= currentLesson.getContent() == null
                    ? "" : currentLesson.getContent() %>
            </p>

            <% if (currentLesson.getCodeExample() != null
                   && !currentLesson.getCodeExample().isEmpty()) { %>

                <h3>Code Example</h3>

                <pre><%= currentLesson.getCodeExample() %></pre>

            <% } %>

            <% if (currentLesson.getOutputExample() != null
                   && !currentLesson.getOutputExample().isEmpty()) { %>

                <h3>Expected Output</h3>

                <div class="output">
                    <%= currentLesson.getOutputExample() %>
                </div>

            <% } %>

            <br>

            <% if (currentLesson.isCompleted()) { %>

                <p class="completed">
                    &#10003; Lesson Completed
                </p>

            <% } else { %>

                <form method="post"
                      action="<%= request.getContextPath() %>/complete-lesson">

                    <input type="hidden"
                           name="lessonId"
                           value="<%= currentLesson.getLessonId() %>">

                    <input type="hidden"
                           name="courseId"
                           value="<%= courseId %>">

                    <button class="button" type="submit">
                        Mark as Completed
                    </button>

                </form>

            <% } %>

            <div class="navigation">

                <% if (currentIndex > 0) { %>

                    <a class="button"
                       href="<%= baseUrl %>&lessonId=<%= lessons.get(currentIndex - 1).getLessonId() %>">
                        &larr; Previous Lesson
                    </a>

                <% } else { %>

                    <button class="button" disabled>
                        &larr; Previous Lesson
                    </button>

                <% } %>

                <% if (currentIndex < totalLessons - 1) { %>

                    <a class="button"
                       href="<%= baseUrl %>&lessonId=<%= lessons.get(currentIndex + 1).getLessonId() %>">
                        Next Lesson &rarr;
                    </a>

                <% } else { %>

                    <button class="button" disabled>
                        Next Lesson &rarr;
                    </button>

                <% } %>

            </div>

        </article>

    <% } %>

</div>

</body>
</html>
