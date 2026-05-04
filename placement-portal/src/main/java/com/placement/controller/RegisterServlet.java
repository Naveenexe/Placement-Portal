package com.placement.controller;

import com.placement.dao.StudentDAO;
import com.placement.dao.impl.StudentDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            double cgpa = Double.parseDouble(request.getParameter("cgpa"));
            String skills = request.getParameter("skills");
            String branch = request.getParameter("branch");

            // Create Student object
            Student s = new Student();
            s.setName(name);
            s.setEmail(email);
            s.setPassword(password);
            s.setCgpa(cgpa);
            s.setSkills(skills);
            s.setBranch(branch);

            // DAO call
            StudentDAO dao = new StudentDAOImpl();
            boolean result = dao.registerStudent(s);

            // Response
            if (result) {
                response.getWriter().println("Registration Successful!");
            } else {
                response.getWriter().println("Registration Failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred!");
        }
    }
}