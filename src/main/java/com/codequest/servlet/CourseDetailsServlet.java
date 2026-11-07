
package com.codequest.servlet;

import com.codequest.model.CourseLesson;
import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/course-details")
public class CourseDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String idParameter = request.getParameter("id");

        if (idParameter == null || idParameter.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }

        int courseId;

        try {
            courseId = Integer.parseInt(idParameter);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courses");
            return;
        }

        String courseSql =
            "SELECT course_id, title, description, category, difficulty, duration " +
            "FROM courses WHERE course_id = ? AND is_active = 1";

        String lessonSql =
            "SELECT l.lesson_id, l.title, l.content, l.code_example, " +
            "l.output_example, l.lesson_order, " +
            "CASE WHEN lp.completed = 1 THEN 1 ELSE 0 END AS completed " +
            "FROM lessons l " +
            "LEFT JOIN lesson_progress lp " +
            "ON l.lesson_id = lp.lesson_id AND lp.user_id = ? " +
            "WHERE l.course_id = ? " +
            "ORDER BY l.lesson_order";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(courseSql)) {

                ps.setInt(1, courseId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        response.sendRedirect(
                            request.getContextPath() + "/courses"
                        );
                        return;
                    }

                    request.setAttribute("courseId", rs.getInt("course_id"));
                    request.setAttribute("courseTitle", rs.getString("title"));
                    request.setAttribute("courseDescription", rs.getString("description"));
                    request.setAttribute("courseCategory", rs.getString("category"));
                    request.setAttribute("courseDifficulty", rs.getString("difficulty"));
                    request.setAttribute("courseDuration", rs.getString("duration"));
                }
            }

            List<CourseLesson> lessons = new ArrayList<>();

            try (PreparedStatement ps = con.prepareStatement(lessonSql)) {

                ps.setInt(1, userId);
                ps.setInt(2, courseId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        CourseLesson lesson = new CourseLesson(
                            rs.getInt("lesson_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("code_example"),
                            rs.getString("output_example"),
                            rs.getInt("lesson_order"),
                            rs.getInt("completed") == 1
                        );

                        lessons.add(lesson);
                    }
                }
            }

            // Find the selected lesson
            int currentIndex = 0;

            String selectedLessonParameter =
                request.getParameter("lessonId");

            if (selectedLessonParameter != null) {

                try {
                    int selectedLessonId =
                        Integer.parseInt(selectedLessonParameter);

                    for (int i = 0; i < lessons.size(); i++) {

                        if (lessons.get(i).getLessonId() == selectedLessonId) {
                            currentIndex = i;
                            break;
                        }
                    }

                } catch (NumberFormatException e) {
                    currentIndex = 0;
                }
            }

            request.setAttribute("lessons", lessons);
            request.setAttribute("currentIndex", currentIndex);

            request.getRequestDispatcher("/course-details.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load course details and lessons.", e
            );
        }
    }
}
