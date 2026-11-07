
package com.codequest.servlet;

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

@WebServlet("/complete-lesson")
public class LessonProgressServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String lessonParameter = request.getParameter("lessonId");
        String courseParameter = request.getParameter("courseId");

        int lessonId;
        int courseId;

        try {
            lessonId = Integer.parseInt(lessonParameter);
            courseId = Integer.parseInt(courseParameter);

            if (lessonId <= 0 || courseId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(contextPath + "/courses");
            return;
        }

        String verifySql =
            "SELECT course_id FROM lessons WHERE lesson_id = ?";

        String saveSql =
            "INSERT INTO lesson_progress " +
            "(user_id, lesson_id, completed, completed_at) " +
            "VALUES (?, ?, 1, CURRENT_TIMESTAMP) " +
            "ON DUPLICATE KEY UPDATE " +
            "completed = 1, completed_at = CURRENT_TIMESTAMP";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(verifySql)) {

                ps.setInt(1, lessonId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next() || rs.getInt("course_id") != courseId) {
                        response.sendRedirect(contextPath + "/courses");
                        return;
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(saveSql)) {

                ps.setInt(1, userId);
                ps.setInt(2, lessonId);
                ps.executeUpdate();
            }

            response.sendRedirect(
                contextPath + "/course-details?id=" +
                courseId + "&completed=1&lessonId=" + lessonId
            );

        } catch (Exception e) {
            throw new ServletException(
                "Unable to save lesson progress.", e
            );
        }
    }
}
