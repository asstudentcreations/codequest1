
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-course")
public class AddCourseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String duration = request.getParameter("duration");

        if (title == null || title.trim().isEmpty()
                || description == null || description.trim().isEmpty()
                || category == null || category.trim().isEmpty()
                || difficulty == null || difficulty.trim().isEmpty()
                || duration == null || duration.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath() + "/add-course.jsp?error=empty"
            );
            return;
        }

        String sql = "INSERT INTO courses "
                   + "(title, description, category, difficulty, duration) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category.trim());
            ps.setString(4, difficulty.trim());
            ps.setString(5, duration.trim());

            ps.executeUpdate();

            response.sendRedirect(
                request.getContextPath() + "/admin-courses?added=1"
            );

        } catch (SQLException e) {
            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath() + "/add-course.jsp?error=database"
            );
        }
    }
}
