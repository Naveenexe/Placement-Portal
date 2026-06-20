<%@ page import="com.placement.model.*" %>
<%@ page import="com.placement.dao.*" %>
<%@ page import="com.placement.dao.impl.*" %>
<%@ page import="java.util.*" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    JobDAO jobDao = new JobDAOImpl();
    List<Job> myJobs = jobDao.getJobsByCompany(company.getId());
    ApplicationDAO appDao = new ApplicationDAOImpl();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Dashboard · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<nav class="navbar">
    <a href="dashboard.jsp" class="nav-brand company"><i class="ri-building-4-fill"></i> Ignite Recruiter</a>
    <div class="nav-links">
        <span class="nav-link">
            <% if(company.getLogoUrl() != null && !company.getLogoUrl().isEmpty()) { %>
                <img src="<%= company.getLogoUrl() %>" style="width: 24px; height: 24px; border-radius: 4px; object-fit: cover;">
            <% } else { %>
                <i class="ri-building-line"></i>
            <% } %>
            <span><%= company.getName() %></span>
        </span>
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> <span>Logout</span></a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>Company Dashboard</h2>
            <p>Manage your job postings and review student applications.</p>
        </div>
        <button class="btn-add company" onclick="document.getElementById('addJobModal').classList.add('active')">
            <i class="ri-add-line"></i> Post New Job
        </button>
    </div>

    <div class="grid">
        <%
            if (myJobs != null && !myJobs.isEmpty()) {
                for (Job j : myJobs) {
                    List<Application> apps = appDao.getApplicationsByJob(j.getId());
                    int applicantCount = (apps != null) ? apps.size() : 0;
        %>
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><%= j.getRole() %></h3>
                <span class="card-company"><i class="ri-group-line"></i> <%= applicantCount %> Applicants</span>
            </div>
            <div class="card-body">
                <p><i class="ri-bar-chart-line"></i> Min CGPA: <%= j.getEligibility() %></p>
                <p><i class="ri-calendar-event-line"></i> Deadline: <%= j.getDeadline() %></p>
            </div>
            <div class="card-footer">
                <a href="/placement-portal/view-applicants?jobId=<%= j.getId() %>" class="btn-view">View Applications</a>
            </div>
        </div>
        <%      }
            } else {
        %>
        <div class="empty-state">
            <i class="ri-briefcase-4-line"></i>
            <h3>No jobs posted yet.</h3>
            <p>Create your first job posting to start receiving applications.</p>
        </div>
        <% } %>
    </div>
</div>

<div id="addJobModal" class="modal-overlay">
    <div class="modal">
        <h3>Post a New Job</h3>
        <form action="/placement-portal/add-job" method="post">
            <input type="hidden" name="companyId" value="<%= company.getId() %>">
            <div class="form-group">
                <label>Job Role</label>
                <input type="text" name="role" class="form-control" placeholder="e.g. Software Engineer" required>
            </div>
            <div class="form-group">
                <label>Eligibility (Min CGPA)</label>
                <input type="number" step="0.1" name="eligibility" class="form-control" placeholder="e.g. 7.5" required>
            </div>
            <div class="form-group">
                <label>Deadline</label>
                <input type="date" name="deadline" class="form-control" required>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="document.getElementById('addJobModal').classList.remove('active')">Cancel</button>
                <button type="submit" class="btn-submit company">Post Job</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('addJobModal').addEventListener('click', function(e) {
        if (e.target === this) this.classList.remove('active');
    });
</script>

</body>
</html>
