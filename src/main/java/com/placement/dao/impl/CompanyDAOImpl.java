package com.placement.dao.impl;

import com.placement.dao.CompanyDAO;
import com.placement.model.Company;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAOImpl implements CompanyDAO {

    private Connection conn;

    public CompanyDAOImpl() {
        conn = DBConnection.getConnection();
    }

    // Add company
    @Override
    public boolean addCompany(Company company) {

        boolean status = false;

        try {
            String sql = "INSERT INTO companies(name, description, logo_url, email, password, status) VALUES(?,?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, company.getName());
            ps.setString(2, company.getDescription());
            ps.setString(3, company.getLogoUrl());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPassword());
            ps.setString(6, "Pending");

            int i = ps.executeUpdate();

            if (i == 1) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Get all companies
    @Override
    public List<Company> getAllCompanies() {

        List<Company> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM companies";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Company c = new Company();

                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setLogoUrl(rs.getString("logo_url"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                c.setStatus(rs.getString("status"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get company by ID
    @Override
    public Company getCompanyById(int id) {

        Company c = null;

        try {
            String sql = "SELECT * FROM companies WHERE id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                c = new Company();

                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setLogoUrl(rs.getString("logo_url"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                c.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    @Override
    public Company loginCompany(String email, String password) {
        Company c = null;
        try {
            String sql = "SELECT * FROM companies WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                c = new Company();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setLogoUrl(rs.getString("logo_url"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                c.setStatus(rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    @Override
    public boolean updateCompanyStatus(int id, String status) {
        boolean isSuccess = false;
        try {
            String sql = "UPDATE companies SET status=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);

            int i = ps.executeUpdate();
            if (i == 1) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}