
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-mission")
public class AddMissionServlet extends HttpServlet {

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
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");

        try {
            int xpReward = Integer.parseInt(
                request.getParameter("xpReward")
            );

            if (title == null || title.isBlank()
                    || description == null || description.isBlank()
                    || optionA == null || optionA.isBlank()
                    || optionB == null || optionB.isBlank()
                    || optionC == null || optionC.isBlank()
                    || optionD == null || optionD.isBlank()
                    || !("A".equals(correctAnswer)
                    || "B".equals(correctAnswer)
                    || "C".equals(correctAnswer)
                    || "D".equals(correctAnswer))
                    || xpReward < 1 || xpReward > 1000) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/add-mission.jsp?error=invalid"
                );
                return;
            }

            String sql =
                "INSERT INTO missions " +
                "(title, description, category, difficulty, " +
                "option_a, option_b, option_c, option_d, " +
                "correct_answer, xp_reward) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, title.trim());
                ps.setString(2, description.trim());
                ps.setString(3, category);
                ps.setString(4, difficulty);
                ps.setString(5, optionA.trim());
                ps.setString(6, optionB.trim());
                ps.setString(7, optionC.trim());
                ps.setString(8, optionD.trim());
                ps.setString(9, correctAnswer);
                ps.setInt(10, xpReward);

                ps.executeUpdate();
            }

            response.sendRedirect(
                request.getContextPath()
                + "/add-mission.jsp?success=1"
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath()
                + "/add-mission.jsp?error=invalid"
            );
        } catch (Exception e) {
            throw new ServletException("Unable to add mission.", e);
        }
    }
}
