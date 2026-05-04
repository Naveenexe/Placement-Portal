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

@WebServlet("/company-register")
public class CompanyRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String description = req.getParameter("description");
        String logoUrl = req.getParameter("logoUrl");

        Company company = new Company();
        company.setName(name);
        company.setEmail(email);
        company.setPassword(password);
        company.setDescription(description);
        company.setLogoUrl(logoUrl);

        CompanyDAO dao = new CompanyDAOImpl();
        boolean success = dao.addCompany(company);

        HttpSession session = req.getSession();

        if (success) {
            session.setAttribute("succMsg", "Registration successful! Please wait for Admin approval.");
            resp.sendRedirect("jsp/company/login.jsp");
        } else {
            session.setAttribute("errorMsg", "Registration failed. Try again.");
            resp.sendRedirect("jsp/company/register.jsp");
        }
    }
}
