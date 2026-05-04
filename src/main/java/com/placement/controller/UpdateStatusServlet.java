package com.placement.controller;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.impl.ApplicationDAOImpl;
import com.placement.dao.StudentDAO;
import com.placement.dao.impl.StudentDAOImpl;
import com.placement.model.Student;
import com.placement.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-status")
public class UpdateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("admin") == null && session.getAttribute("company") == null)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        int appId = Integer.parseInt(request.getParameter("appId"));
        String status = request.getParameter("status");

        ApplicationDAO appDao = new ApplicationDAOImpl();
        appDao.updateStatus(appId, status);

        // 🔹 Get student info (IMPORTANT)
        int studentId = appDao.getStudentIdByApplication(appId);

        StudentDAO studentDao = new StudentDAOImpl();
        Student student = studentDao.getStudentById(studentId);

        // 🔹 Prepare email
        String toEmail = student.getEmail();

        String subject = "Placement Application Update";

        String message;

        if ("Selected".equals(status)) {
            message = "Congratulations " + student.getName() +
                    ", you have been SELECTED! 🎉";
        } else {
            message = "Hello " + student.getName() +
                    ", unfortunately you were NOT selected.";
        }

        // 🔹 Send Email
        EmailUtil.sendEmail(toEmail, student.getName(), status);

        // 🔹 Redirect back
        response.sendRedirect(request.getHeader("referer"));
    }
}