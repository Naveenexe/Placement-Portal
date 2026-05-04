package com.placement.dao;

import com.placement.model.Student;

import java.util.List;

public interface StudentDAO {

    // Register student
    boolean registerStudent(Student student);

    // Login student
    Student login(String email, String password);
    List<Student> getTopStudents();
    // Get student by ID
    Student getStudentById(int id);

    boolean updateFiles(int studentId, String resumePath, String profilePic);
    boolean updateProfileDetails(Student student);
}