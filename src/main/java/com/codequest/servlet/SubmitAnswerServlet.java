
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

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Check student login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {
            session.invalidate();
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        int userId = (Integer) userIdObject;

        // 2. Read form values
        String missionIdText = request.getParameter("missionId");
        String answer = request.getParameter("answer");

        // 3. Validate mission ID
        int missionId;

        try {
            missionId = Integer.parseInt(missionIdText);

            if (missionId <= 0) {
                response.sendRedirect(contextPath + "/missions");
                return;
            }
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(contextPath + "/missions");
            return;
        }

        // 4. Validate answer
        if (answer == null) {
            response.sendRedirect(contextPath + "/missions");
            return;
        }

        answer = answer.trim().toUpperCase();

        if (!answer.matches("[A-D]")) {
            response.sendRedirect(contextPath + "/missions");
            return;
        }

        // 5. Process submission in a transaction
        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                // Get mission details
                String missionSql =
                    "SELECT correct_answer, xp_reward " +
                    "FROM missions WHERE mission_id = ?";

                String correctAnswer;
                int xpReward;

                try (PreparedStatement ps =
                         con.prepareStatement(missionSql)) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();
                            response.sendRedirect(
                                contextPath + "/missions"
                            );
                            return;
                        }

                        correctAnswer =
                            rs.getString("correct_answer");

                        xpReward = rs.getInt("xp_reward");
                    }
                }

                // Validate stored mission data
                if (correctAnswer == null ||
                    !correctAnswer.trim().matches("(?i)[A-D]") ||
                    xpReward < 0) {

                    throw new SQLException(
                        "Invalid answer or XP configuration for mission."
                    );
                }

                boolean isCorrect =
                    answer.equalsIgnoreCase(correctAnswer.trim());

                // Insert attempt first.
                // uq_user_mission prevents duplicate attempts.
                String insertSql =
                    "INSERT INTO mission_submissions " +
                    "(user_id, mission_id, selected_answer, is_correct) " +
                    "VALUES (?, ?, ?, ?)";

                try (PreparedStatement ps =
                         con.prepareStatement(insertSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);
                    ps.setString(3, answer);
                    ps.setBoolean(4, isCorrect);

                    ps.executeUpdate();
                }

                // Award XP only if the answer is correct.
                if (isCorrect) {

                    String updateSql =
                        "UPDATE users SET " +
                        "xp = xp + ?, " +
                        "level = FLOOR((xp + ?) / 100) + 1 " +
                        "WHERE user_id = ?";

                    try (PreparedStatement ps =
                             con.prepareStatement(updateSql)) {

                        ps.setInt(1, xpReward);
                        ps.setInt(2, xpReward);
                        ps.setInt(3, userId);

                        int updatedRows = ps.executeUpdate();

                        if (updatedRows != 1) {
                            throw new SQLException(
                                "Student record was not updated."
                            );
                        }
                    }
                }

                // Save both operations together
                con.commit();

                if (isCorrect) {
                    response.sendRedirect(
                        contextPath + "/missions?result=correct"
                    );
                } else {
                    response.sendRedirect(
                        contextPath + "/missions?result=wrong"
                    );
                }

            } catch (SQLException e) {

                con.rollback();

                // MySQL duplicate key error
                if (e.getErrorCode() == 1062 &&
                    "23000".equals(e.getSQLState())) {

                    response.sendRedirect(
                        contextPath + "/missions?alreadyAttempted=1"
                    );
                    return;
                }

                throw e;

            } catch (RuntimeException e) {

                con.rollback();
                throw e;
            }

        } catch (SQLException e) {

            throw new ServletException(
                "Unable to process mission submission.", e
            );
        }
    }
}
