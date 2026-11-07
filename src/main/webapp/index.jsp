
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String context = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuest | Learn Coding. Play. Grow. Win.</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f8fafc;
            color: #172033;
            line-height: 1.6;
        }

        /* Navigation */

        .navbar {
            background: #ffffff;
            min-height: 76px;
            padding: 15px 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .logo {
            color: #2563eb;
            font-size: 27px;
            font-weight: bold;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: #334155;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s;
        }

        .nav-links a:hover {
            color: #2563eb;
        }

        .nav-links .student-btn {
            background: #2563eb;
            color: white;
            padding: 10px 17px;
            border-radius: 7px;
        }

        .nav-links .student-btn:hover {
            background: #1d4ed8;
            color: white;
        }

        .nav-links .admin-btn {
            background: #172554;
            color: white;
            padding: 10px 17px;
            border-radius: 7px;
        }

        .nav-links .admin-btn:hover {
            background: #312e81;
            color: white;
        }

        /* Hero Section */

        .hero {
            background: linear-gradient(120deg, #172554, #3730a3, #6d28d9);
            color: white;
            padding: 90px 7%;
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            align-items: center;
            gap: 45px;
            min-height: 500px;
        }

        .hero-content {
            max-width: 700px;
        }

        .hero-label {
            display: inline-block;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 7px 15px;
            border-radius: 30px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .hero h1 {
            font-size: clamp(36px, 5vw, 58px);
            line-height: 1.15;
            margin-bottom: 22px;
        }

        .hero h1 span {
            color: #facc15;
        }

        .hero p {
            color: #e0e7ff;
            font-size: 17px;
            margin-bottom: 30px;
            max-width: 600px;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            padding: 13px 23px;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.2s;
        }

        .btn-primary {
            background: #facc15;
            color: #172033;
        }

        .btn-primary:hover {
            background: #fde047;
            transform: translateY(-2px);
        }

        .btn-outline {
            border: 1px solid white;
            color: white;
        }

        .btn-outline:hover {
            background: white;
            color: #172554;
        }

        .hero-visual {
            background: rgba(255, 255, 255, 0.10);
            border: 1px solid rgba(255, 255, 255, 0.20);
            border-radius: 22px;
            padding: 30px;
            text-align: center;
        }

        .hero-emoji {
            font-size: 85px;
            margin-bottom: 10px;
        }

        .hero-visual h2 {
            font-size: 25px;
            margin-bottom: 10px;
        }

        .hero-visual p {
            font-size: 14px;
            margin-bottom: 20px;
        }

        .stat-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
        }

        .stat {
            background: rgba(255, 255, 255, 0.12);
            padding: 14px 7px;
            border-radius: 10px;
        }

        .stat strong {
            display: block;
            color: #facc15;
            font-size: 20px;
        }

        .stat span {
            font-size: 11px;
            color: #e0e7ff;
        }

        /* General Sections */

        .section {
            padding: 75px 7%;
        }

        .section-heading {
            text-align: center;
            max-width: 700px;
            margin: 0 auto 42px;
        }

        .section-heading h2 {
            font-size: 34px;
            margin-bottom: 12px;
            color: #172554;
        }

        .section-heading p {
            color: #64748b;
        }

        /* Features */

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .feature-card {
            background: white;
            padding: 28px;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            transition: 0.2s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.07);
        }

        .feature-icon {
            font-size: 36px;
            margin-bottom: 15px;
        }

        .feature-card h3 {
            margin-bottom: 10px;
            color: #1e3a8a;
            font-size: 20px;
        }

        .feature-card p {
            color: #64748b;
            font-size: 14px;
        }

        /* Courses */

        .courses-section {
            background: #eef2ff;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .course-card {
            background: white;
            padding: 27px;
            border-radius: 14px;
            border: 1px solid #e0e7ff;
        }

        .course-icon {
            font-size: 40px;
            margin-bottom: 14px;
        }

        .course-card h3 {
            color: #1e3a8a;
            margin-bottom: 10px;
            font-size: 20px;
        }

        .course-card p {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .course-tag {
            display: inline-block;
            background: #dbeafe;
            color: #1d4ed8;
            padding: 5px 11px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        /* How It Works */

        .steps-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
        }

        .step-card {
            text-align: center;
            padding: 25px;
        }

        .step-number {
            width: 55px;
            height: 55px;
            background: #dbeafe;
            color: #1d4ed8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            font-weight: bold;
            margin: 0 auto 18px;
        }

        .step-card h3 {
            margin-bottom: 10px;
            color: #172554;
        }

        .step-card p {
            color: #64748b;
            font-size: 14px;
        }

        /* Call to Action */

        .cta {
            margin: 20px 7% 75px;
            padding: 55px 25px;
            text-align: center;
            background: linear-gradient(120deg, #1e3a8a, #6d28d9);
            border-radius: 18px;
            color: white;
        }

        .cta h2 {
            font-size: 32px;
            margin-bottom: 12px;
        }

        .cta p {
            color: #e0e7ff;
            margin-bottom: 25px;
        }

        /* Footer */

        footer {
            background: #111827;
            color: #cbd5e1;
            padding: 35px 7%;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        footer .logo {
            color: white;
        }

        footer p {
            font-size: 13px;
        }

        .footer-links {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: #cbd5e1;
            text-decoration: none;
            font-size: 13px;
        }

        .footer-links a:hover {
            color: white;
        }

        /* Responsive Design */

        @media (max-width: 900px) {
            .hero {
                grid-template-columns: 1fr;
                padding: 65px 6%;
            }

            .hero-visual {
                max-width: 500px;
            }

            .features-grid,
            .courses-grid,
            .steps-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .navbar {
                justify-content: center;
                padding: 15px 5%;
            }

            .nav-links {
                gap: 12px;
            }

            .nav-links a {
                font-size: 12px;
            }

            .hero {
                padding: 50px 6%;
            }

            .hero h1 {
                font-size: 37px;
            }

            .hero p {
                font-size: 15px;
            }

            .section {
                padding: 50px 6%;
            }

            .section-heading h2 {
                font-size: 27px;
            }

            .features-grid,
            .courses-grid,
            .steps-grid {
                grid-template-columns: 1fr;
            }

            .cta {
                margin: 10px 5% 50px;
            }

            .cta h2 {
                font-size: 26px;
            }

            .footer-content {
                flex-direction: column;
                text-align: center;
            }

            .footer-links {
                justify-content: center;
            }
        }
    </style>
</head>

<body>

    <!-- Navigation Bar -->

    <nav class="navbar">

        <a href="<%= context %>/index.jsp" class="logo">
            CodeQuest
        </a>

        <div class="nav-links">

            <a href="<%= context %>/index.jsp">Home</a>

            <a href="#features">Features</a>

            <a href="#courses">Courses</a>

            <a href="<%= context %>/login.jsp" class="student-btn">
                Student Login
            </a>

            <a href="<%= context %>/register.jsp">
                Register
            </a>

            <a href="<%= context %>/admin-login.jsp" class="admin-btn">
                Admin Login
            </a>

        </div>

    </nav>

    <!-- Hero Section -->

    <section class="hero">

        <div class="hero-content">

            <span class="hero-label">
                Your Coding Journey Starts Here
            </span>

            <h1>
                Learn Coding.<br>
                <span>Play. Grow. Win.</span>
            </h1>

            <p>
                Welcome to CodeQuest, a programming learning platform
                where you can learn coding, complete interactive missions,
                earn XP, improve your level, and compete with other students.
            </p>

            <div class="hero-buttons">

                <a href="<%= context %>/register.jsp" class="btn btn-primary">
                    Get Started Free
                </a>

                <a href="#courses" class="btn btn-outline">
                    Explore Courses
                </a>

            </div>

        </div>

        <div class="hero-visual">

            <div class="hero-emoji">🎮</div>

            <h2>Make Coding Fun!</h2>

            <p>
                Learn new concepts, solve coding missions,
                collect experience points, and level up.
            </p>

            <div class="stat-row">

                <div class="stat">
                    <strong>Learn</strong>
                    <span>New Skills</span>
                </div>

                <div class="stat">
                    <strong>Play</strong>
                    <span>Missions</span>
                </div>

                <div class="stat">
                    <strong>Grow</strong>
                    <span>Your Level</span>
                </div>

            </div>

        </div>

    </section>

    <!-- Features Section -->

    <section class="section" id="features">

        <div class="section-heading">

            <h2>Why Choose CodeQuest?</h2>

            <p>
                Learn programming through lessons, practical challenges,
                and progress tracking.
            </p>

        </div>

        <div class="features-grid">

            <div class="feature-card">

                <div class="feature-icon">📚</div>

                <h3>Learn Programming</h3>

                <p>
                    Study programming concepts through simple lessons,
                    examples, and expected outputs.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">🎯</div>

                <h3>Complete Missions</h3>

                <p>
                    Answer programming questions, test your knowledge,
                    and earn XP for correct answers.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">🏆</div>

                <h3>Track Your Progress</h3>

                <p>
                    Complete lessons, monitor your course progress,
                    increase your level, and view the leaderboard.
                </p>

            </div>

        </div>

    </section>

    <!-- Courses Section -->

    <section class="section courses-section" id="courses">

        <div class="section-heading">

            <h2>Explore Our Courses</h2>

            <p>
                Build your programming skills from the basics
                to more advanced concepts.
            </p>

        </div>

        <div class="courses-grid">

            <div class="course-card">

                <div class="course-icon">🧠</div>

                <h3>Data Structures and Algorithms</h3>

                <p>
                    Learn arrays, strings, searching, sorting,
                    linked lists, stacks, queues, and trees.
                </p>

                <span class="course-tag">DSA</span>

            </div>

            <div class="course-card">

                <div class="course-icon">☕</div>

                <h3>Java Programming</h3>

                <p>
                    Learn Java syntax, variables, loops, classes,
                    objects, inheritance, and exception handling.
                </p>

                <span class="course-tag">Programming</span>

            </div>

            <div class="course-card">

                <div class="course-icon">🐍</div>

                <h3>Python Programming</h3>

                <p>
                    Start with Python basics, conditions, loops,
                    functions, lists, dictionaries, and more.
                </p>

                <span class="course-tag">Programming</span>

            </div>

            <div class="course-card">

                <div class="course-icon">🌐</div>

                <h3>Full Stack Web Development</h3>

                <p>
                    Explore HTML, CSS, JavaScript, server-side
                    programming, and database connectivity.
                </p>

                <span class="course-tag">Web Development</span>

            </div>

            <div class="course-card">

                <div class="course-icon">🗄️</div>

                <h3>SQL and Database Management</h3>

                <p>
                    Learn database tables, SQL queries, joins,
                    constraints, and database operations.
                </p>

                <span class="course-tag">Database</span>

            </div>

            <div class="course-card">

                <div class="course-icon">🤖</div>

                <h3>Artificial Intelligence and Machine Learning</h3>

                <p>
                    Discover AI and ML basics, datasets, model
                    training, predictions, and real-world applications.
                </p>

                <span class="course-tag">AI / ML</span>

            </div>

        </div>

    </section>

    <!-- How It Works Section -->

    <section class="section">

        <div class="section-heading">

            <h2>How CodeQuest Works</h2>

            <p>
                Follow three simple steps to start your learning journey.
            </p>

        </div>

        <div class="steps-grid">

            <div class="step-card">

                <div class="step-number">1</div>

                <h3>Create Your Account</h3>

                <p>
                    Register as a student and log in to your personal
                    CodeQuest dashboard.
                </p>

            </div>

            <div class="step-card">

                <div class="step-number">2</div>

                <h3>Learn and Practice</h3>

                <p>
                    Explore courses, study lessons, and answer
                    programming mission questions.
                </p>

            </div>

            <div class="step-card">

                <div class="step-number">3</div>

                <h3>Earn XP and Improve</h3>

                <p>
                    Earn XP from correct mission answers, improve
                    your level, and track your achievements.
                </p>

            </div>

        </div>

    </section>

    <!-- Call to Action -->

    <section class="cta">

        <h2>Ready to Start Your Coding Journey?</h2>

        <p>
            Create your account and begin learning with CodeQuest today.
        </p>

        <a href="<%= context %>/register.jsp" class="btn btn-primary">
            Create Student Account
        </a>

        <a href="<%= context %>/admin-login.jsp"
           class="btn btn-outline">
            Admin Login
        </a>

    </section>

    <!-- Footer -->

    <footer>

        <div class="footer-content">

            <div>
                <a href="<%= context %>/index.jsp" class="logo">
                    CodeQuest
                </a>

                <p>Learn Coding. Play. Grow. Win.</p>

                <p>
                    © 2026 CodeQuest. All rights reserved.
                </p>
            </div>

            <div class="footer-links">

                <a href="<%= context %>/index.jsp">Home</a>

                <a href="#features">Features</a>

                <a href="#courses">Courses</a>

                <a href="<%= context %>/login.jsp">Student Login</a>

                <a href="<%= context %>/admin-login.jsp">Admin Login</a>

            </div>

        </div>

    </footer>

</body>
</html>
