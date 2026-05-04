package com.placement.dao.impl;

import com.placement.dao.StudentDAO;
import com.placement.model.Student;
import com.placement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAOImpl implements StudentDAO {

    Connection conn;

    public StudentDAOImpl() {
        conn = DBConnection.getConnection();
    }

    @Override
    public boolean registerStudent(Student s) {
        boolean status = false;
        try {
            String sql = "INSERT INTO students(name,email,password,cgpa,skills,branch,resume_path,profile_pic,contact_number,enrollment_no,linkedin_url) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPassword());
            ps.setDouble(4, s.getCgpa());
            ps.setString(5, s.getSkills());
            ps.setString(6, s.getBranch());
            ps.setString(7, null);
            ps.setString(8, null);
            ps.setString(9, s.getContactNumber());
            ps.setString(10, s.getEnrollmentNo());
            ps.setString(11, s.getLinkedinUrl());

            int i = ps.executeUpdate();
            if (i == 1) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    private void extractStudentData(Student s, ResultSet rs) throws SQLException {
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setSkills(rs.getString("skills"));
        s.setBranch(rs.getString("branch"));
        s.setResumePath(rs.getString("resume_path"));
        s.setProfilePic(rs.getString("profile_pic"));
        s.setContactNumber(rs.getString("contact_number"));
        s.setEnrollmentNo(rs.getString("enrollment_no"));
        s.setLinkedinUrl(rs.getString("linkedin_url"));
    }

    @Override
    public Student login(String email, String password) {
        Student s = null;
        try {
            String sql = "SELECT * FROM students WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Student();
                extractStudentData(s, rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    @Override
    public Student getStudentById(int id) {
        Student s = null;
        try {
            String sql = "SELECT * FROM students WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Student();
                extractStudentData(s, rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    @Override
    public boolean updateFiles(int studentId, String resumePath, String profilePic) {
        boolean status = false;
        try {
            String sql = "UPDATE students SET resume_path=?, profile_pic=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, resumePath);
            ps.setString(2, profilePic);
            ps.setInt(3, studentId);

            int i = ps.executeUpdate();
            if (i == 1) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    @Override
    public boolean updateProfileDetails(Student s) {
        boolean status = false;
        try {
            String sql = "UPDATE students SET contact_number=?, enrollment_no=?, linkedin_url=?, branch=?, skills=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, s.getContactNumber());
            ps.setString(2, s.getEnrollmentNo());
            ps.setString(3, s.getLinkedinUrl());
            ps.setString(4, s.getBranch());
            ps.setString(5, s.getSkills());
            ps.setInt(6, s.getId());

            int i = ps.executeUpdate();
            if (i == 1) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    @Override
    public List<Student> getTopStudents() {
        List<Student> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM students ORDER BY cgpa DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Student s = new Student();
                extractStudentData(s, rs);
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}