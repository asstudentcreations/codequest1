
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-courses")
public class AdminCoursesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static class AdminCourse {
        private int courseId;
        private String title;
        private String category;
        private String difficulty;
        private String duration;
        private int totalLessons;

        public AdminCourse(int courseId, String title,
                           String category, String difficulty,
                           String duration, int totalLessons) {
            this.courseId = courseId;
            this.title = title;
            this.category = category;
            this.difficulty = difficulty;
            this.duration = duration;
            this.totalLessons = totalLessons;
        }

        public int getCourseId() {
            return courseId;
        }

        public String getTitle() {
            return title;
        }

        public String getCategory() {
            return category;
        }

        public String getDifficulty() {
            return difficulty;
        }

        public String getDuration() {
            return duration;
        }

        public int getTotalLessons() {
            return totalLessons;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        List<AdminCourse> courses = new ArrayList<>();

        String sql =
            "SELECT c.course_id, c.title, c.category, " +
            "c.difficulty, c.duration, COUNT(l.lesson_id) AS total_lessons " +
            "FROM courses c " +
            "LEFT JOIN lessons l ON c.course_id = l.course_id " +
            "GROUP BY c.course_id, c.title, c.category, " +
            "c.difficulty, c.duration " +
            "ORDER BY c.course_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                courses.add(new AdminCourse(
                    rs.getInt("course_id"),
                    rs.getString("title"),
                    rs.getString("category"),
                    rs.getString("difficulty"),
                    rs.getString("duration"),
                    rs.getInt("total_lessons")
                ));
            }

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load courses.", e
            );
        }

        request.setAttribute("courses", courses);

        request.getRequestDispatcher("/admin-courses.jsp")
               .forward(request, response);
    }
}
