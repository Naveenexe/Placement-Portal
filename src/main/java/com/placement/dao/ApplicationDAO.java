package com.placement.dao;

import com.placement.model.Application;
import java.util.List;

public interface ApplicationDAO {

    // Apply for a job
    boolean applyJob(int studentId, int jobId);

    // Get applications by student
    List<Application> getApplicationsByStudent(int studentId);

    // Get applications by job (for admin)
    List<Application> getApplicationsByJob(int jobId);
    Application getApplication(int studentId, int jobId);
    // Update application status
    boolean updateStatus(int applicationId, String status);

    boolean hasApplied(int studentId, int jobId);

    int getStudentIdByApplication(int appId);
}