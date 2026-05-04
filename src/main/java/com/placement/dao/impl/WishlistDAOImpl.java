package com.placement.dao.impl;

import com.placement.dao.WishlistDAO;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class WishlistDAOImpl implements WishlistDAO {

    private Connection conn;

    public WishlistDAOImpl() {
        conn = DBConnection.getConnection();
    }

    @Override
    public boolean addToWishlist(int studentId, int jobId) {
        boolean status = false;
        try {
            String sql = "INSERT INTO wishlist(student_id, job_id) VALUES(?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);

            int i = ps.executeUpdate();
            if (i == 1) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    @Override
    public boolean removeFromWishlist(int studentId, int jobId) {
        boolean status = false;
        try {
            String sql = "DELETE FROM wishlist WHERE student_id=? AND job_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);

            int i = ps.executeUpdate();
            if (i == 1) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    @Override
    public boolean isJobInWishlist(int studentId, int jobId) {
        boolean exists = false;
        try {
            String sql = "SELECT * FROM wishlist WHERE student_id=? AND job_id=?";
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
}
