package com.placement.controller;

import com.placement.dao.StudentDAO;
import com.placement.dao.impl.StudentDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        StudentDAO dao = new StudentDAOImpl();
        Student student = dao.login(email, password);

        if (student != null) {

            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("student", student);

            // Redirect to dashboard
            response.sendRedirect("jsp/student/dashboard.jsp");

        } else {
            response.sendRedirect("jsp/student/login.jsp?error=invalid");
        }
    }
}