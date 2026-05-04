package com.placement.dao;

import com.placement.model.Job;
import java.util.List;

public interface JobDAO {

    // Add job
    boolean addJob(Job job);

    // Get all jobs
    List<Job> getAllJobs();

    // Get jobs by company
    List<Job> getJobsByCompany(int companyId);

    // Get job by ID
    Job getJobById(int id);
}