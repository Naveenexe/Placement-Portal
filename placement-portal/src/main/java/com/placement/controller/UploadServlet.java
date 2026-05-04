package com.placement.controller;

import com.placement.dao.StudentDAO;
import com.placement.dao.impl.StudentDAOImpl;
import com.placement.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/upload-profile")
@MultipartConfig
public class UploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("student");

        if (student == null) {
            response.sendRedirect("jsp/student/login.jsp");
            return;
        }

        // 🔹 Get file parts
        Part resumePart = request.getPart("resume");
        Part picPart = request.getPart("profilePic");

        // 🔹 Get file names
        String resumeFileName = resumePart.getSubmittedFileName();
        String picFileName = picPart.getSubmittedFileName();

        // 🔹 Create upload directory if not exists
        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // 🔹 Save files only if they exist
        String resumePath = student.getResumePath();
        String picPath = student.getProfilePic();

        if (resumeFileName != null && !resumeFileName.trim().isEmpty()) {
            resumePath = UPLOAD_DIR + "/" + student.getId() + "_" + resumeFileName;
            resumePart.write(uploadPath + File.separator + student.getId() + "_" + resumeFileName);
        }

        if (picFileName != null && !picFileName.trim().isEmpty()) {
            picPath = UPLOAD_DIR + "/" + student.getId() + "_" + picFileName;
            picPart.write(uploadPath + File.separator + student.getId() + "_" + picFileName);
        }

        // 🔹 Update DB
        StudentDAO dao = new StudentDAOImpl();
        dao.updateFiles(student.getId(), resumePath, picPath);

        // 🔹 Update session object
        student.setResumePath(resumePath);
        student.setProfilePic(picPath);
        session.setAttribute("student", student);

        response.sendRedirect("jsp/student/dashboard.jsp");
    }
}