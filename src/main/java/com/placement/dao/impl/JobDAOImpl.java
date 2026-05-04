package com.placement.dao.impl;

import com.placement.dao.JobDAO;
import com.placement.model.Job;
import com.placement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAOImpl implements JobDAO {

    Connection conn;

    public JobDAOImpl() {
        conn = DBConnection.getConnection();
    }

    // ✅ ADD JOB
    @Override
    public boolean addJob(Job job) {

        boolean status = false;

        try {
            String sql = "INSERT INTO jobs(company_id, role, eligibility, deadline) VALUES(?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, job.getCompanyId());
            ps.setString(2, job.getRole());
            ps.setDouble(3, job.getEligibility());
            ps.setString(4, job.getDeadline()); // ✅ FIXED

            int i = ps.executeUpdate();

            if (i == 1) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // ✅ GET ALL JOBS
    @Override
    public List<Job> getAllJobs() {

        List<Job> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM jobs";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Job j = new Job();

                j.setId(rs.getInt("id"));
                j.setCompanyId(rs.getInt("company_id"));
                j.setRole(rs.getString("role"));
                j.setEligibility(rs.getDouble("eligibility"));
                j.setDeadline(rs.getString("deadline"));

                list.add(j);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ GET JOBS BY COMPANY
    @Override
    public List<Job> getJobsByCompany(int companyId) {

        List<Job> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM jobs WHERE company_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, companyId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Job j = new Job();

                j.setId(rs.getInt("id"));
                j.setCompanyId(rs.getInt("company_id"));
                j.setRole(rs.getString("role"));
                j.setEligibility(rs.getDouble("eligibility"));
                j.setDeadline(rs.getString("deadline"));

                list.add(j);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ GET JOB BY ID
    @Override
    public Job getJobById(int id) {

        Job j = null;

        try {
            String sql = "SELECT * FROM jobs WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                j = new Job();

                j.setId(rs.getInt("id"));
                j.setCompanyId(rs.getInt("company_id"));
                j.setRole(rs.getString("role"));
                j.setEligibility(rs.getDouble("eligibility"));
                j.setDeadline(rs.getString("deadline"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return j;
    }
}