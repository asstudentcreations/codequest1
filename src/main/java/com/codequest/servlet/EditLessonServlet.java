
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-lesson")
public class EditLessonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static class CourseOption {
        private int courseId;
        private String title;

        public CourseOption(int courseId, String title) {
            this.courseId = courseId;
            this.title = title;
        }

        public int getCourseId() {
            return courseId;
        }

        public String getTitle() {
            return title;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        int lessonId;

        try {
            lessonId = Integer.parseInt(request.getParameter("lessonId"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin-lessons");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT lesson_id, course_id, title, content, " +
                         "code_example, output_example, lesson_order " +
                         "FROM lessons WHERE lesson_id = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, lessonId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        response.sendRedirect(request.getContextPath()
                                + "/admin-lessons");
                        return;
                    }

                    request.setAttribute("lessonId", rs.getInt("lesson_id"));
                    request.setAttribute("courseId", rs.getInt("course_id"));
                    request.setAttribute("title", rs.getString("title"));
                    request.setAttribute("content", rs.getString("content"));
                    request.setAttribute("codeExample", rs.getString("code_example"));
                    request.setAttribute("outputExample", rs.getString("output_example"));
                    request.setAttribute("lessonOrder", rs.getInt("lesson_order"));
                }
            }

            List<CourseOption> courses = new ArrayList<>();

            String courseSql = "SELECT course_id, title FROM courses " +
                               "WHERE is_active = 1 ORDER BY title";

            try (PreparedStatement coursePs =
                    con.prepareStatement(courseSql);
                 ResultSet courseRs = coursePs.executeQuery()) {

                while (courseRs.next()) {
                    courses.add(new CourseOption(
                        courseRs.getInt("course_id"),
                        courseRs.getString("title")
                    ));
                }
            }

            request.setAttribute("courses", courses);

            request.getRequestDispatcher("/edit-lesson.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load lesson details.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        int lessonId;

        try {
            lessonId = Integer.parseInt(request.getParameter("lessonId"));

            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int lessonOrder = Integer.parseInt(request.getParameter("lessonOrder"));

            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String codeExample = request.getParameter("codeExample");
            String outputExample = request.getParameter("outputExample");

            if (title == null || title.trim().isEmpty()
                    || content == null || content.trim().isEmpty()
                    || lessonOrder < 1) {

                response.sendRedirect(request.getContextPath()
                        + "/edit-lesson?lessonId=" + lessonId + "&error=invalid");
                return;
            }

            String sql = "UPDATE lessons SET course_id=?, title=?, content=?, " +
                         "code_example=?, output_example=?, lesson_order=? " +
                         "WHERE lesson_id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, courseId);
                ps.setString(2, title.trim());
                ps.setString(3, content.trim());
                ps.setString(4, codeExample == null ? "" : codeExample.trim());
                ps.setString(5, outputExample == null ? "" : outputExample.trim());
                ps.setInt(6, lessonOrder);
                ps.setInt(7, lessonId);

                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath()
                    + "/admin-lessons?updated=1");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin-lessons");
        } catch (Exception e) {
            throw new ServletException("Unable to update lesson.", e);
        }
    }
}
	