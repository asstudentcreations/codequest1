
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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String sql = "SELECT username, email, xp, level "
                   + "FROM users WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    int xp = rs.getInt("xp");
                    int level = rs.getInt("level");

                    request.setAttribute("username",
                                         rs.getString("username"));
                    request.setAttribute("email",
                                         rs.getString("email"));
                    request.setAttribute("xp", xp);
                    request.setAttribute("level", level);

                    // Progress within the current 100-XP level
                    int progress = xp % 100;
                    request.setAttribute("progress", progress);

                    request.getRequestDispatcher("/profile.jsp")
                           .forward(request, response);
                } else {
                    session.invalidate();
                    response.sendRedirect(
                        request.getContextPath() + "/login.jsp"
                    );
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load student profile.", e
            );
        }
    }
}
