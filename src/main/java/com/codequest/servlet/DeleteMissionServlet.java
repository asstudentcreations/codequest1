
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

@WebServlet("/delete-mission")
public class DeleteMissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String missionIdValue = request.getParameter("missionId");

        try {
            int missionId = Integer.parseInt(missionIdValue);

            if (missionId <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin-missions?error=invalid");
                return;
            }

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    // Delete related student submissions first
                    String deleteSubmissions =
                        "DELETE FROM mission_submissions WHERE mission_id = ?";

                    try (PreparedStatement ps =
                             con.prepareStatement(deleteSubmissions)) {

                        ps.setInt(1, missionId);
                        ps.executeUpdate();
                    }

                    // Delete the mission
                    String deleteMission =
                        "DELETE FROM missions WHERE mission_id = ?";

                    int deleted;

                    try (PreparedStatement ps =
                             con.prepareStatement(deleteMission)) {

                        ps.setInt(1, missionId);
                        deleted = ps.executeUpdate();
                    }

                    con.commit();

                    if (deleted > 0) {
                        response.sendRedirect(
                            request.getContextPath() + "/admin-missions?deleted=1"
                        );
                    } else {
                        response.sendRedirect(
                            request.getContextPath() + "/admin-missions?error=notfound"
                        );
                    }

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/admin-missions?error=invalid"
            );

        } catch (Exception e) {
            throw new ServletException("Unable to delete mission.", e);
        }
    }
}
