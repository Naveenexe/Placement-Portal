package com.placement.controller;

import com.placement.dao.WishlistDAO;
import com.placement.dao.impl.WishlistDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/toggle-wishlist")
public class ToggleWishlistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            response.sendRedirect("jsp/student/login.jsp");
            return;
        }

        Student student = (Student) session.getAttribute("student");
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        String action = request.getParameter("action"); // "add" or "remove"

        WishlistDAO wishlistDao = new WishlistDAOImpl();

        if ("add".equals(action)) {
            wishlistDao.addToWishlist(student.getId(), jobId);
        } else if ("remove".equals(action)) {
            wishlistDao.removeFromWishlist(student.getId(), jobId);
        }

        // Redirect back to dashboard
        response.sendRedirect("jsp/student/dashboard.jsp");
    }
}
