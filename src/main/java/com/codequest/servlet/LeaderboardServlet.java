package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Only logged-in students can view the leaderboard.
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        List<LeaderboardEntry> entries = new ArrayList<>();

        String sql =
                "SELECT username, xp, level " +
                "FROM users " +
                "ORDER BY xp DESC, username ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int rank = 1;

            while (rs.next()) {
                LeaderboardEntry entry = new LeaderboardEntry();

                entry.rank = rank++;
                entry.username = rs.getString("username");
                entry.xp = rs.getInt("xp");
                entry.level = rs.getInt("level");

                entries.add(entry);
            }

            request.setAttribute("leaderboard", entries);

            request.getRequestDispatcher("/leaderboard.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load leaderboard.", e);
        }
    }

    // Holds one student's leaderboard details.
    public static class LeaderboardEntry {
        public int rank;
        public String username;
        public int xp;
        public int level;
    }
}
