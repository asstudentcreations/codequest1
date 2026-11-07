
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Dashboard | CodeQuest</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background: #f4f7fb;
    color: #1e293b;
}

/* Navigation */
.navbar {
    background: #ffffff;
    padding: 18px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}

.logo {
    font-size: 25px;
    font-weight: bold;
    color: #4f46e5;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}

.nav-links a {
    text-decoration: none;
    color: #475569;
    font-size: 14px;
    font-weight: bold;
}

.nav-links a:hover {
    color: #4f46e5;
}

.logout {
    background: #fee2e2;
    color: #b91c1c !important;
    padding: 10px 15px;
    border-radius: 8px;
}

/* Main content */
.container {
    max-width: 1200px;
    margin: auto;
    padding: 40px 22px;
}

/* Welcome banner */
.welcome {
    background: linear-gradient(120deg, #4338ca, #7c3aed);
    color: white;
    padding: 42px;
    border-radius: 20px;
    margin-bottom: 32px;
}

.welcome h1 {
    font-size: 34px;
    margin-bottom: 15px;
}

.welcome p {
    color: #e0e7ff;
    font-size: 16px;
    line-height: 1.7;
    max-width: 700px;
}

.welcome-btn {
    display: inline-block;
    margin-top: 22px;
    padding: 12px 22px;
    background: white;
    color: #4338ca;
    border-radius: 9px;
    text-decoration: none;
    font-weight: bold;
}

.welcome-btn:hover {
    background: #eef2ff;
}

/* Section heading */
.section-title {
    font-size: 26px;
    margin-bottom: 22px;
}

/* Cards */
.card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 22px;
}

.card {
    background: white;
    border: 1px solid #e2e8f0;
    padding: 27px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(15,23,42,0.04);
    display: flex;
    flex-direction: column;
    min-height: 250px;
    transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 25px rgba(15,23,42,0.09);
}

.card-icon {
    font-size: 36px;
    margin-bottom: 18px;
}

.card h3 {
    font-size: 20px;
    margin-bottom: 13px;
}

.card p {
    font-size: 14px;
    color: #64748b;
    line-height: 1.7;
    margin-bottom: 22px;
}

.card-link {
    display: block;
    margin-top: auto;
    text-align: center;
    background: #4f46e5;
    color: white;
    padding: 12px;
    border-radius: 9px;
    text-decoration: none;
    font-weight: bold;
}

.card-link:hover {
    background: #3730a3;
}

/* Footer */
.footer {
    text-align: center;
    padding: 25px;
    margin-top: 25px;
    color: #64748b;
    font-size: 13px;
}

@media (max-width: 650px) {
    .navbar {
        padding: 18px 5%;
    }

    .nav-links {
        gap: 14px;
    }

    .welcome {
        padding: 28px;
    }

    .welcome h1 {
        font-size: 27px;
    }

    .container {
        padding: 28px 16px;
    }
}
</style>
</head>

<body>

<!-- Navigation -->
<nav class="navbar">

    <div class="logo">⚡ CodeQuest</div>

    <div class="nav-links">
        <a href="<%= ctx %>/dashboard">Home</a>
        <a href="<%= ctx %>/profile">My Profile</a>
        <a href="<%= ctx %>/courses">Courses</a>
        <a href="<%= ctx %>/missions">Missions</a>
        <a href="<%= ctx %>/leaderboard">Leaderboard</a>
        <a class="logout" href="<%= ctx %>/logout">Logout</a>
    </div>

</nav>

<!-- Dashboard content -->
<main class="container">

    <!-- Welcome banner -->
    <section class="welcome">

        <h1>
            Welcome, <%= username == null ? "Learner" : username %>! 👋
        </h1>

        <p>
            Welcome to CodeQuest, your programming learning platform.
            Explore courses, learn coding step by step, complete
            programming missions, earn XP, and improve your level.
        </p>

        <a class="welcome-btn" href="<%= ctx %>/courses">
            Explore Courses →
        </a>

    </section>

    <!-- Dashboard cards -->
    <h2 class="section-title">Your Learning Dashboard</h2>

    <div class="card-grid">

        <!-- Profile -->
        <div class="card">
            <div class="card-icon">👤</div>

            <h3>My Profile</h3>

            <p>
                View your username, email, total XP,
                and current learning level.
            </p>

            <a class="card-link" href="<%= ctx %>/profile">
                View Profile →
            </a>
        </div>

        <!-- Courses -->
        <div class="card">
            <div class="card-icon">📚</div>

            <h3>Programming Courses</h3>

            <p>
                Learn DSA, Java, Python, C and C++,
                Full Stack Web Development, SQL, AI/ML,
                Git and GitHub.
            </p>

            <a class="card-link" href="<%= ctx %>/courses">
                Explore Courses →
            </a>
        </div>

        <!-- Missions -->
        <div class="card">
            <div class="card-icon">🎯</div>

            <h3>Programming Missions</h3>

            <p>
                Test your programming knowledge by solving
                coding questions and earning experience points.
            </p>

            <a class="card-link" href="<%= ctx %>/missions">
                Start Missions →
            </a>
        </div>

        <!-- Leaderboard -->
        <div class="card">
            <div class="card-icon">🏆</div>

            <h3>Leaderboard</h3>

            <p>
                Check student rankings and compare your
                earned XP with other learners.
            </p>

            <a class="card-link" href="<%= ctx %>/leaderboard">
                View Rankings →
            </a>
        </div>

    </div>

</main>

<!-- Footer -->
<footer class="footer">
    © 2026 CodeQuest | Learn • Practise • Improve
</footer>

</body>
</html>
