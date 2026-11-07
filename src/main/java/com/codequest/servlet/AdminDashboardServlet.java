
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin login
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        // Get the logged-in admin's username
        request.setAttribute(
            "adminUsername",
            session.getAttribute("adminUsername")
        );

        try (Connection con = DBConnection.getConnection()) {

            // Count registered students
            request.setAttribute(
                "totalStudents",
                getCount(con, "SELECT COUNT(*) FROM users")
            );

            // Count courses
            request.setAttribute(
                "totalCourses",
                getCount(con, "SELECT COUNT(*) FROM courses")
            );

            // Count lessons
            request.setAttribute(
                "totalLessons",
                getCount(con, "SELECT COUNT(*) FROM lessons")
            );

            // Count missions
            request.setAttribute(
                "totalMissions",
                getCount(con, "SELECT COUNT(*) FROM missions")
            );

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load admin dashboard statistics.", e
            );
        }

        // Open the admin dashboard page
        request.getRequestDispatcher("/admin-dashboard.jsp")
               .forward(request, response);
    }

    private int getCount(Connection con, String sql)
            throws SQLException {

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

            return 0;
        }
    }
}
