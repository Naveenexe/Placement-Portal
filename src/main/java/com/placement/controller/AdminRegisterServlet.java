package com.placement.controller;

import com.placement.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin-register")
public class AdminRegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/jsp/admin/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO admins(username, password) VALUES(?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, password);

            int i = ps.executeUpdate();

            if (i == 1) {
                session.setAttribute("succMsg", "Admin registered successfully!");
                response.sendRedirect("jsp/admin/login.jsp");
            } else {
                session.setAttribute("errorMsg", "Registration Failed");
                response.sendRedirect("jsp/admin/register.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred: " + e.getMessage());
            response.sendRedirect("jsp/admin/register.jsp");
        }
    }
}