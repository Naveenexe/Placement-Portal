package com.placement.controller;

import com.placement.dao.StudentDAO;
import com.placement.dao.impl.StudentDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-profile-details")
public class UpdateProfileDetailsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("student");

        if (student == null) {
            response.sendRedirect("jsp/student/login.jsp");
            return;
        }

        String contactNumber = request.getParameter("contactNumber");
        String enrollmentNo = request.getParameter("enrollmentNo");
        String linkedinUrl = request.getParameter("linkedinUrl");
        String branch = request.getParameter("branch");
        String skills = request.getParameter("skills");

        student.setContactNumber(contactNumber);
        student.setEnrollmentNo(enrollmentNo);
        student.setLinkedinUrl(linkedinUrl);
        student.setBranch(branch);
        student.setSkills(skills);

        StudentDAO dao = new StudentDAOImpl();
        boolean success = dao.updateProfileDetails(student);

        if (success) {
            session.setAttribute("student", student);
            response.sendRedirect("jsp/student/profile.jsp?msg=updated");
        } else {
            response.sendRedirect("jsp/student/profile.jsp?error=failed");
        }
    }
}
