
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

@WebServlet("/admin-missions")
public class AdminMissionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static class AdminMission {
        public int id;
        public String title;
        public String category;
        public String difficulty;
        public String correctAnswer;
        public int xpReward;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        List<AdminMission> missions = new ArrayList<>();

        String sql =
            "SELECT mission_id, title, category, difficulty, " +
            "correct_answer, xp_reward FROM missions " +
            "ORDER BY mission_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdminMission mission = new AdminMission();

                mission.id = rs.getInt("mission_id");
                mission.title = rs.getString("title");
                mission.category = rs.getString("category");
                mission.difficulty = rs.getString("difficulty");
                mission.correctAnswer = rs.getString("correct_answer");
                mission.xpReward = rs.getInt("xp_reward");

                missions.add(mission);
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load missions.", e);
        }

        request.setAttribute("missions", missions);

        request.getRequestDispatcher("/admin-missions.jsp")
               .forward(request, response);
    }
}
