package com.placement.dao.impl;

import com.placement.dao.AdminDAO;
import com.placement.model.Admin;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAOImpl implements AdminDAO {

    private Connection conn;

    public AdminDAOImpl() {
        conn = DBConnection.getConnection();
    }

    @Override
    public Admin login(String username, String password) {

        Admin admin = null;

        try {
            String sql = "SELECT * FROM admins WHERE username=? AND password=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                admin = new Admin();

                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }
}