
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.isBlank() || password.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=1");
            return;
        }

        String sql = "SELECT user_id, username, password_hash "
                   + "FROM users WHERE username = ? OR email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(2, username.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next() && PasswordUtil.verifyPassword(
                        password, rs.getString("password_hash"))) {

                    // Create student session
                    HttpSession session = request.getSession(true);

                    session.setAttribute("userId", rs.getInt("user_id"));

                    String loggedInUsername = rs.getString("username");

                    session.setAttribute("username", loggedInUsername);

                    // Create username cookie
                    Cookie usernameCookie =
                            new Cookie("savedUsername", loggedInUsername);

                    usernameCookie.setMaxAge(7 * 24 * 60 * 60);

                    usernameCookie.setHttpOnly(true);

                    usernameCookie.setPath(request.getContextPath().isEmpty()
                            ? "/" : request.getContextPath());

                    response.addCookie(usernameCookie);

                    // Redirect to student dashboard
                    response.sendRedirect(
                            request.getContextPath() + "/dashboard");

                } else {

                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp?error=1");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Login failed.", e);
        }
    }
}
