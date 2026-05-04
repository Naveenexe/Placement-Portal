package com.placement.model;

public class Job {

    private int id;
    private int companyId;
    private String role;
    private double eligibility;
    private String deadline;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public double getEligibility() {
        return eligibility;
    }

    public void setEligibility(double eligibility) {
        this.eligibility = eligibility;
    }

    public String getDeadline() {
        return deadline;
    }

    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }
}