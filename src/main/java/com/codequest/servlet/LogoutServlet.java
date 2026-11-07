
package com.codequest.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing student session
        HttpSession session = request.getSession(false);

        // Destroy student session
        if (session != null) {
            session.invalidate();
        }

        // Delete saved username cookie
        Cookie usernameCookie = new Cookie("savedUsername", "");

        usernameCookie.setMaxAge(0);

        usernameCookie.setPath(
                request.getContextPath().isEmpty()
                ? "/"
                : request.getContextPath()
        );

        usernameCookie.setHttpOnly(true);

        response.addCookie(usernameCookie);

        // Redirect to login page
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
    }
}
