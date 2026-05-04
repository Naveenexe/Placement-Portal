package com.placement.controller;

import com.placement.dao.JobDAO;
import com.placement.dao.impl.JobDAOImpl;
import com.placement.model.Job;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/add-job")
public class AddJobServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("admin") == null && session.getAttribute("company") == null)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            // 🔹 Get form data
            int companyId = Integer.parseInt(request.getParameter("companyId"));
            String role = request.getParameter("role");
            double eligibility = Double.parseDouble(request.getParameter("eligibility"));
            String deadline = request.getParameter("deadline");

            // 🔹 Create Job object
            Job job = new Job();
            job.setCompanyId(companyId);
            job.setRole(role);
            job.setEligibility(eligibility);
            job.setDeadline(deadline);

            // 🔹 Save to DB
            JobDAO dao = new JobDAOImpl();
            boolean result = dao.addJob(job);

            // 🔹 Redirect based on role
            if (result) {
                if (session.getAttribute("company") != null) {
                    response.sendRedirect("jsp/company/dashboard.jsp");
                } else {
                    response.sendRedirect("jsp/admin/dashboard.jsp");
                }
            } else {
                response.getWriter().println("Failed to add job");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred while adding job");
        }
    }
}