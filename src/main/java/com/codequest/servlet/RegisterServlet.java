
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (username == null || email == null || password == null
                || username.isBlank() || email.isBlank()
                || password.length() < 6) {
            response.sendError(400, "Please enter valid registration details.");
            return;
        }

        String sql = "INSERT INTO users "
                + "(username, email, password_hash) VALUES (?, ?, ?)";

        try {
            String passwordHash = PasswordUtil.hashPassword(password);

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username.trim());
                ps.setString(2, email.trim());
                ps.setString(3, passwordHash);

                ps.executeUpdate();

                response.sendRedirect("login.jsp?registered=1");
            }

        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                response.sendError(400,
                        "That username or email may already be registered.");
            } else {
                throw new ServletException("Registration failed.", e);
            }
        } catch (Exception e) {
            throw new ServletException("Password processing failed.", e);
        }
    }
}
