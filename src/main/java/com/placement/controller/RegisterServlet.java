package com.placement.controller;

import com.placement.dao.StudentDAO;
import com.placement.dao.impl.StudentDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            double cgpa = Double.parseDouble(request.getParameter("cgpa"));
            String skills = request.getParameter("skills");
            String branch = request.getParameter("branch");

            Student s = new Student();
            s.setName(name);
            s.setEmail(email);
            s.setPassword(password);
            s.setCgpa(cgpa);
            s.setSkills(skills);
            s.setBranch(branch);

            StudentDAO dao = new StudentDAOImpl();
            boolean result = dao.registerStudent(s);

            if (result) {
                session.setAttribute("succMsg", "Registration successful! Please sign in.");
                response.sendRedirect("jsp/student/login.jsp?success=registered");
            } else {
                session.setAttribute("errorMsg", "Registration failed. Email may already be in use.");
                response.sendRedirect("jsp/student/register.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred during registration: " + e.getMessage());
            response.sendRedirect("jsp/student/register.jsp");
        }
    }
}
