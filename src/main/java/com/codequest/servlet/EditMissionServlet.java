
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

@WebServlet("/edit-mission")
public class EditMissionServlet extends HttpServlet {

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

        String missionId = request.getParameter("missionId");

        if (missionId == null || missionId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-missions");
            return;
        }

        String sql = "SELECT * FROM missions WHERE mission_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(missionId));

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    request.setAttribute("missionId", rs.getInt("mission_id"));
                    request.setAttribute("title", rs.getString("title"));
                    request.setAttribute("description", rs.getString("description"));
                    request.setAttribute("category", rs.getString("category"));
                    request.setAttribute("difficulty", rs.getString("difficulty"));
                    request.setAttribute("optionA", rs.getString("option_a"));
                    request.setAttribute("optionB", rs.getString("option_b"));
                    request.setAttribute("optionC", rs.getString("option_c"));
                    request.setAttribute("optionD", rs.getString("option_d"));
                    request.setAttribute("correctAnswer", rs.getString("correct_answer"));
                    request.setAttribute("xpReward", rs.getInt("xp_reward"));

                } else {
                    response.sendRedirect(request.getContextPath() + "/admin-missions?error=notfound");
                    return;
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load mission.", e);
        }

        request.getRequestDispatcher("/edit-mission.jsp")
               .forward(request, response);
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

        try {
            int missionId = Integer.parseInt(request.getParameter("missionId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String difficulty = request.getParameter("difficulty");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            String correctAnswer = request.getParameter("correctAnswer");
            int xpReward = Integer.parseInt(request.getParameter("xpReward"));

            if (title == null || title.trim().isEmpty()
                    || description == null || description.trim().isEmpty()
                    || category == null || category.trim().isEmpty()
                    || difficulty == null || difficulty.trim().isEmpty()
                    || optionA == null || optionA.trim().isEmpty()
                    || optionB == null || optionB.trim().isEmpty()
                    || optionC == null || optionC.trim().isEmpty()
                    || optionD == null || optionD.trim().isEmpty()
                    || correctAnswer == null || correctAnswer.trim().isEmpty()
                    || xpReward < 0) {

                response.sendRedirect(request.getContextPath() + "/admin-missions?error=invalid");
                return;
            }

            String sql = "UPDATE missions SET title=?, description=?, category=?, " +
                         "difficulty=?, option_a=?, option_b=?, option_c=?, " +
                         "option_d=?, correct_answer=?, xp_reward=? " +
                         "WHERE mission_id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, title.trim());
                ps.setString(2, description.trim());
                ps.setString(3, category.trim());
                ps.setString(4, difficulty.trim());
                ps.setString(5, optionA.trim());
                ps.setString(6, optionB.trim());
                ps.setString(7, optionC.trim());
                ps.setString(8, optionD.trim());
                ps.setString(9, correctAnswer.trim());
                ps.setInt(10, xpReward);
                ps.setInt(11, missionId);

                int updated = ps.executeUpdate();

                if (updated > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin-missions?updated=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin-missions?error=notfound");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin-missions?error=invalid");
        } catch (Exception e) {
            throw new ServletException("Unable to update mission.", e);
        }
    }
}
