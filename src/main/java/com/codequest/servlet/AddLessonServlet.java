
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

@WebServlet("/add-lesson")
public class AddLessonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Display Add Lesson Form
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String context = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(context + "/admin-login.jsp");
            return;
        }

        List<CourseOption> courses = new ArrayList<>();

        String sql = "SELECT course_id, title FROM courses "
                   + "WHERE is_active = 1 ORDER BY title";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                CourseOption course = new CourseOption();

                course.setCourseId(rs.getInt("course_id"));
                course.setTitle(rs.getString("title"));

                courses.add(course);
            }

            request.setAttribute("courses", courses);

            request.getRequestDispatcher("/add-lesson.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            throw new ServletException("Unable to load courses.", e);
        }
    }

    // Save New Lesson
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
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String codeExample = request.getParameter("codeExample");
        String outputExample = request.getParameter("outputExample");
        String lessonOrder = request.getParameter("lessonOrder");

        if (courseId == null || title == null || content == null
                || lessonOrder == null
                || courseId.trim().isEmpty()
                || title.trim().isEmpty()
                || content.trim().isEmpty()
                || lessonOrder.trim().isEmpty()) {

            response.sendRedirect(context + "/add-lesson?error=empty");
            return;
        }

        try {

            int selectedCourse = Integer.parseInt(courseId);
            int order = Integer.parseInt(lessonOrder);

            if (selectedCourse <= 0 || order <= 0) {
                response.sendRedirect(context + "/add-lesson?error=invalid");
                return;
            }

            String sql = "INSERT INTO lessons "
                       + "(course_id, title, content, code_example, "
                       + "output_example, lesson_order) "
                       + "VALUES (?, ?, ?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, selectedCourse);
                ps.setString(2, title.trim());
                ps.setString(3, content.trim());
                ps.setString(4, codeExample == null ? "" : codeExample.trim());
                ps.setString(5, outputExample == null ? "" : outputExample.trim());
                ps.setInt(6, order);

                int result = ps.executeUpdate();

                if (result > 0) {

                    response.sendRedirect(
                        context + "/admin-lessons?added=1"
                    );

                } else {

                    response.sendRedirect(
                        context + "/add-lesson?error=database"
                    );
                }
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(context + "/add-lesson?error=invalid");

        } catch (Exception e) {

            throw new ServletException("Unable to add lesson.", e);
        }
    }

    // Course details for dropdown
    public static class CourseOption {

        private int courseId;
        private String title;

        public int getCourseId() {
            return courseId;
        }

        public void setCourseId(int courseId) {
            this.courseId = courseId;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }
    }
}
