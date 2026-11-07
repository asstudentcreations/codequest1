
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-students")
public class AdminStudentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static class Student {
        private int userId;
        private String username;
        private String email;
        private int xp;
        private int level;

        public Student(int userId, String username, String email,
                       int xp, int level) {
            this.userId = userId;
            this.username = username;
            this.email = email;
            this.xp = xp;
            this.level = level;
        }

        public int getUserId() {
            return userId;
        }

        public String getUsername() {
            return username;
        }

        public String getEmail() {
            return email;
        }

        public int getXp() {
            return xp;
        }

        public int getLevel() {
            return level;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Only logged-in admins can view student details
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        List<Student> students = new ArrayList<>();

        String sql = "SELECT user_id, username, email, xp, level "
                   + "FROM users ORDER BY user_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student student = new Student(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getInt("xp"),
                    rs.getInt("level")
                );

                students.add(student);
            }

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load student details.", e
            );
        }

        request.setAttribute("students", students);

        request.getRequestDispatcher("/admin-students.jsp")
               .forward(request, response);
    }
}
