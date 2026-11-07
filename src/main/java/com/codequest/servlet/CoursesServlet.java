
package com.codequest.servlet;

import com.codequest.model.Course;
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

@WebServlet("/courses")
public class CoursesServlet extends HttpServlet {

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

        String sql =
            "SELECT c.course_id, c.title, c.description, c.category, " +
            "c.difficulty, c.duration, " +
            "COUNT(DISTINCT l.lesson_id) AS total_lessons, " +
            "COUNT(DISTINCT CASE WHEN lp.completed = 1 " +
            "THEN l.lesson_id END) AS completed_lessons " +
            "FROM courses c " +
            "LEFT JOIN lessons l ON c.course_id = l.course_id " +
            "LEFT JOIN lesson_progress lp " +
            "ON l.lesson_id = lp.lesson_id AND lp.user_id = ? " +
            "WHERE c.is_active = 1 " +
            "GROUP BY c.course_id, c.title, c.description, c.category, " +
            "c.difficulty, c.duration " +
            "ORDER BY c.course_id";

        List<Course> courses = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Course course = new Course(
                        rs.getInt("course_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("difficulty"),
                        rs.getString("duration"),
                        rs.getInt("total_lessons"),
                        rs.getInt("completed_lessons")
                    );

                    courses.add(course);
                }
            }

            request.setAttribute("courses", courses);

            request.getRequestDispatcher("/courses.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load courses and learning progress.", e
            );
        }
    }
}
