package com.placement.controller;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.impl.ApplicationDAOImpl;
import com.placement.model.Application;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/view-applicants")
public class ViewApplicantsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int jobId = Integer.parseInt(request.getParameter("jobId"));

        ApplicationDAO dao = new ApplicationDAOImpl();
        List<Application> list = dao.getApplicationsByJob(jobId);

        request.setAttribute("applications", list);
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("company") != null) {
            request.getRequestDispatcher("jsp/company/applicants.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("jsp/admin/applicants.jsp").forward(request, response);
        }
    }
}