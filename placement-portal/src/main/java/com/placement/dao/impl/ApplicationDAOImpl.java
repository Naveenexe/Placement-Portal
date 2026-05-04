package com.placement.dao.impl;

import com.placement.dao.ApplicationDAO;
import com.placement.model.Application;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAOImpl implements ApplicationDAO {

    private Connection conn;

    public ApplicationDAOImpl() {
        conn = DBConnection.getConnection();
    }

    @Override
    public Application getApplication(int studentId, int jobId) {

        Application a = null;

        try {
            String sql = "SELECT * FROM applications WHERE student_id=? AND job_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a = new Application();

                a.setId(rs.getInt("id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setJobId(rs.getInt("job_id"));
                a.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return a;
    }
    @Override
    public int getStudentIdByApplication(int appId) {

        int studentId = 0;

        try {
            String sql = "SELECT student_id FROM applications WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, appId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                studentId = rs.getInt("student_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return studentId;
    }

    // Apply for Job
    @Override
    public boolean applyJob(int studentId, int jobId) {

        boolean status = false;

        try {
            String sql = "INSERT INTO applications(student_id, job_id) VALUES(?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);

            int i = ps.executeUpdate();

            if (i == 1) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Get applications by student
    @Override
    public List<Application> getApplicationsByStudent(int studentId) {

        List<Application> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM applications WHERE student_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Application a = new Application();

                a.setId(rs.getInt("id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setJobId(rs.getInt("job_id"));
                a.setStatus(rs.getString("status"));
                a.setAppliedDate(rs.getTimestamp("applied_date"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get applications by job (admin view)
    @Override
    public List<Application> getApplicationsByJob(int jobId) {

        List<Application> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM applications WHERE job_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, jobId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Application a = new Application();

                a.setId(rs.getInt("id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setJobId(rs.getInt("job_id"));
                a.setStatus(rs.getString("status"));
                a.setAppliedDate(rs.getTimestamp("applied_date"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean hasApplied(int studentId, int jobId) {

        boolean exists = false;

        try {
            String sql = "SELECT * FROM applications WHERE student_id=? AND job_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    // Update status (Shortlist / Reject / Select)
    @Override
    public boolean updateStatus(int applicationId, String status) {

        boolean result = false;

        try {
            String sql = "UPDATE applications SET status=? WHERE id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, applicationId);

            int i = ps.executeUpdate();

            if (i == 1) {
                result = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}