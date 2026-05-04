package com.placement.controller;

import com.placement.dao.CompanyDAO;
import com.placement.dao.impl.CompanyDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-company-status")
public class UpdateCompanyStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("jsp/admin/login.jsp");
            return;
        }

        int companyId = Integer.parseInt(request.getParameter("companyId"));
        String status = request.getParameter("status"); // "Approved" or "Rejected"

        CompanyDAO dao = new CompanyDAOImpl();
        dao.updateCompanyStatus(companyId, status);

        response.sendRedirect("jsp/admin/dashboard.jsp");
    }
}
