
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-course")
public class EditCourseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String courseId = request.getParameter("id");

        if (courseId == null || courseId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-courses");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM courses WHERE course_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(courseId));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                request.setAttribute("courseId", rs.getInt("course_id"));
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("description", rs.getString("description"));
                request.setAttribute("category", rs.getString("category"));
                request.setAttribute("difficulty", rs.getString("difficulty"));
                request.setAttribute("duration", rs.getString("duration"));

                request.getRequestDispatcher("/edit-course.jsp")
                       .forward(request, response);

            } else {

                response.sendRedirect(request.getContextPath() + "/admin-courses");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(request.getContextPath() + "/admin-courses");

        } catch (Exception e) {

            throw new ServletException("Unable to load course details.", e);
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

        String courseId = request.getParameter("courseId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String duration = request.getParameter("duration");

        if (courseId == null || title == null || description == null
                || category == null || difficulty == null || duration == null
                || title.trim().isEmpty() || description.trim().isEmpty()
                || category.trim().isEmpty() || difficulty.trim().isEmpty()
                || duration.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/admin-courses");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE courses SET title=?, description=?, "
                       + "category=?, difficulty=?, duration=? "
                       + "WHERE course_id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category.trim());
            ps.setString(4, difficulty.trim());
            ps.setString(5, duration.trim());
            ps.setInt(6, Integer.parseInt(courseId));

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin-courses?updated=1");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin-courses?error=notfound");
            }

        } catch (Exception e) {

            throw new ServletException("Unable to update course.", e);
        }
    }
}
