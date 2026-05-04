package com.placement.controller;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.impl.ApplicationDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/apply")
public class ApplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int jobId = Integer.parseInt(request.getParameter("jobId"));

        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("student");
        
        if (student == null) {
            response.sendRedirect("jsp/student/login.jsp");
            return;
        }

        int studentId = student.getId();

        ApplicationDAO dao = new ApplicationDAOImpl();

        // prevent duplicate apply
        if (!dao.hasApplied(studentId, jobId)) {
            dao.applyJob(studentId, jobId);
        }

        response.sendRedirect("jsp/student/dashboard.jsp");
    }
}