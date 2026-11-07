
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

@WebServlet("/admin-lessons")
public class AdminLessonsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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

        List<AdminLesson> lessons = new ArrayList<>();

        String sql =
            "SELECT l.lesson_id, l.course_id, l.title, "
          + "l.lesson_order, c.title AS course_title "
          + "FROM lessons l "
          + "INNER JOIN courses c ON l.course_id = c.course_id "
          + "ORDER BY c.course_id, l.lesson_order";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                AdminLesson lesson = new AdminLesson();

                lesson.setLessonId(rs.getInt("lesson_id"));
                lesson.setCourseId(rs.getInt("course_id"));
                lesson.setTitle(rs.getString("title"));
                lesson.setLessonOrder(rs.getInt("lesson_order"));
                lesson.setCourseTitle(rs.getString("course_title"));

                lessons.add(lesson);
            }

            request.setAttribute("lessons", lessons);

            request.getRequestDispatcher("/admin-lessons.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            throw new ServletException("Unable to load lessons.", e);
        }
    }

    public static class AdminLesson {

        private int lessonId;
        private int courseId;
        private String title;
        private int lessonOrder;
        private String courseTitle;

        public int getLessonId() {
            return lessonId;
        }

        public void setLessonId(int lessonId) {
            this.lessonId = lessonId;
        }

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

        public int getLessonOrder() {
            return lessonOrder;
        }

        public void setLessonOrder(int lessonOrder) {
            this.lessonOrder = lessonOrder;
        }

        public String getCourseTitle() {
            return courseTitle;
        }

        public void setCourseTitle(String courseTitle) {
            this.courseTitle = courseTitle;
        }
    }
}
