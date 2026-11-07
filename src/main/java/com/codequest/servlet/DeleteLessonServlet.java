
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

@WebServlet("/delete-lesson")
public class DeleteLessonServlet extends HttpServlet {

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

        try {
            int lessonId = Integer.parseInt(
                    request.getParameter("lessonId"));

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    // First delete student progress for this lesson
                    String progressSql =
                            "DELETE FROM lesson_progress WHERE lesson_id = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(progressSql)) {

                        ps.setInt(1, lessonId);
                        ps.executeUpdate();
                    }

                    // Then delete the lesson
                    String lessonSql =
                            "DELETE FROM lessons WHERE lesson_id = ?";

                    int deleted;

                    try (PreparedStatement ps =
                            con.prepareStatement(lessonSql)) {

                        ps.setInt(1, lessonId);
                        deleted = ps.executeUpdate();
                    }

                    con.commit();

                    if (deleted > 0) {
                        response.sendRedirect(
                                context + "/admin-lessons?deleted=1");
                    } else {
                        response.sendRedirect(
                                context + "/admin-lessons?error=notfound");
                    }

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(context + "/admin-lessons?error=invalid");
        } catch (Exception e) {
            throw new ServletException("Unable to delete lesson.", e);
        }
    }
}
