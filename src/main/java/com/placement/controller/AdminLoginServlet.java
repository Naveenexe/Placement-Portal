package com.placement.controller;

import com.placement.dao.AdminDAO;
import com.placement.dao.impl.AdminDAOImpl;
import com.placement.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AdminDAO dao = new AdminDAOImpl();
        Admin admin = dao.login(username, password);

        if (admin != null) {

            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);

            response.sendRedirect("jsp/admin/dashboard.jsp");

        } else {
            response.sendRedirect("jsp/admin/login.jsp?error=invalid");
        }
    }
}