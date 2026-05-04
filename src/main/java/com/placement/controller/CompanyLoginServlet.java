package com.placement.controller;

import com.placement.dao.CompanyDAO;
import com.placement.dao.impl.CompanyDAOImpl;
import com.placement.model.Company;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/company-login")
public class CompanyLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        CompanyDAO dao = new CompanyDAOImpl();
        Company company = dao.loginCompany(email, password);

        HttpSession session = req.getSession();

        if (company != null) {
            if ("Rejected".equalsIgnoreCase(company.getStatus())) {
                session.setAttribute("errorMsg", "Your company registration was rejected.");
                resp.sendRedirect("jsp/company/login.jsp");
            } else if ("Pending".equalsIgnoreCase(company.getStatus())) {
                session.setAttribute("errorMsg", "Approval is pending from the Admin.");
                resp.sendRedirect("jsp/company/login.jsp");
            } else {
                session.setAttribute("company", company);
                resp.sendRedirect("jsp/company/dashboard.jsp");
            }
        } else {
            session.setAttribute("errorMsg", "Invalid email or password.");
            resp.sendRedirect("jsp/company/login.jsp");
        }
    }
}
