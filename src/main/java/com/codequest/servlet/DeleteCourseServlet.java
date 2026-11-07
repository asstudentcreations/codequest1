
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-course")
public class DeleteCourseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String context = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(context + "/admin-login.jsp");
            return;
        }

        String courseId = request.getParameter("courseId");

        if (courseId == null || courseId.trim().isEmpty()) {
            response.sendRedirect(context + "/admin-courses?error=invalid");
            return;
        }

        try {
            int id = Integer.parseInt(courseId);

            if (id <= 0) {
                response.sendRedirect(context + "/admin-courses?error=invalid");
                return;
            }

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    // Delete lesson progress belonging to this course.
                    String progressSql =
                        "DELETE lp FROM lesson_progress lp "
                      + "INNER JOIN lessons l ON lp.lesson_id = l.lesson_id "
                      + "WHERE l.course_id = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(progressSql)) {

                        ps.setInt(1, id);
                        ps.executeUpdate();
                    }

                    // Delete lessons belonging to this course.
                    String lessonsSql =
                        "DELETE FROM lessons WHERE course_id = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(lessonsSql)) {

                        ps.setInt(1, id);
                        ps.executeUpdate();
                    }

                    // Delete the course.
                    String courseSql =
                        "DELETE FROM courses WHERE course_id = ?";

                    int result;

                    try (PreparedStatement ps =
                            con.prepareStatement(courseSql)) {

                        ps.setInt(1, id);
                        result = ps.executeUpdate();
                    }

                    if (result > 0) {
                        con.commit();

                        response.sendRedirect(
                            context + "/admin-courses?deleted=1"
                        );

                    } else {
                        con.rollback();

                        response.sendRedirect(
                            context + "/admin-courses?error=notfound"
                        );
                    }

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                }
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(context + "/admin-courses?error=invalid");

        } catch (Exception e) {

            throw new ServletException("Unable to delete course.", e);
        }
    }
}
