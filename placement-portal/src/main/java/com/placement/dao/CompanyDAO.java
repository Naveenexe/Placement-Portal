package com.placement.dao;

import com.placement.model.Company;
import java.util.List;

public interface CompanyDAO {

    // Add company
    boolean addCompany(Company company);

    // Get all companies
    List<Company> getAllCompanies();

    Company getCompanyById(int id);

    // Company Login
    Company loginCompany(String email, String password);

    // Update Company Status
    boolean updateCompanyStatus(int id, String status);
}