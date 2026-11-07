
package com.codequest.servlet;

import com.codequest.model.Mission;
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

@WebServlet("/missions")
public class MissionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether the student is logged in.
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String sql =
                "SELECT m.mission_id, m.title, m.description, " +
                "m.category, m.difficulty, m.option_a, m.option_b, " +
                "m.option_c, m.option_d, m.xp_reward " +
                "FROM missions m " +
                "WHERE NOT EXISTS (" +
                "SELECT 1 FROM mission_submissions s " +
                "WHERE s.mission_id = m.mission_id " +
                "AND s.user_id = ?) " +
                "ORDER BY m.mission_id";

        List<Mission> missionList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Mission mission = new Mission();

                    mission.id = rs.getInt("mission_id");
                    mission.title = rs.getString("title");
                    mission.description =
                            rs.getString("description");
                    mission.category = rs.getString("category");
                    mission.difficulty =
                            rs.getString("difficulty");
                    mission.optionA = rs.getString("option_a");
                    mission.optionB = rs.getString("option_b");
                    mission.optionC = rs.getString("option_c");
                    mission.optionD = rs.getString("option_d");
                    mission.xpReward = rs.getInt("xp_reward");

                    missionList.add(mission);
                }
            }

            request.setAttribute("missions", missionList);

            request.getRequestDispatcher("/missions.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load missions from the database.", e);
        }
    }
}
