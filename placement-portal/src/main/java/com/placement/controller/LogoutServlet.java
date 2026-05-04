package com.placement.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 Get session (if exists)
        HttpSession session = request.getSession(false);

        // 🔹 Destroy session
        if (session != null) {
            session.invalidate();
        }

        // 🔹 Redirect to home page
        response.sendRedirect("index.jsp");
    }
}