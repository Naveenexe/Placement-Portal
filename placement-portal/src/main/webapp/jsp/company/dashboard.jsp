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
    <title>Company Dashboard | Ignite Placement</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #8b5cf6; --primary-dark: #7c3aed; 
            --bg: #f8fafc; --text-main: #1f2937; --text-muted: #6b7280;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); }
        .navbar {
            background: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { font-size: 1.5rem; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 0.5rem; }
        .nav-links { display: flex; align-items: center; gap: 1.5rem; }
        .btn-logout { background: #fee2e2; color: #dc2626; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.2s; }
        .btn-logout:hover { background: #fecaca; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .welcome-text h2 { font-size: 2rem; color: var(--text-main); }
        .welcome-text p { color: var(--text-muted); }
        .btn-post-job { background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%); color: white; padding: 0.75rem 1.5rem; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 0.5rem; box-shadow: 0 4px 6px -1px rgba(139, 92, 246, 0.3); transition: transform 0.2s; }
        .btn-post-job:hover { transform: translateY(-2px); }

        .job-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 1.5rem; margin-top: 2rem; }
        .job-card { background: white; border-radius: 16px; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
        .job-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem; }
        .job-title { font-size: 1.25rem; font-weight: 600; color: var(--text-main); }
        .stat-row { display: flex; justify-content: space-between; margin-bottom: 1rem; color: var(--text-muted); font-size: 0.95rem; }
        
        .btn-view { display: block; width: 100%; text-align: center; padding: 0.75rem; background: #f3f4f6; color: var(--text-main); font-weight: 600; text-decoration: none; border-radius: 8px; transition: background 0.2s; }
        .btn-view:hover { background: #e5e7eb; }

        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; z-index: 1000;}
        .modal { background: white; padding: 2rem; border-radius: 16px; width: 100%; max-width: 500px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); }
        .modal h3 { margin-bottom: 1.5rem; font-size: 1.5rem; color: var(--text-main); }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.9rem; color: var(--text-muted);}
        .form-control { width: 100%; padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 8px; font-family: inherit; font-size: 1rem;}
        .modal-actions { display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1.5rem; }
        .btn-cancel { padding: 0.75rem 1.5rem; border-radius: 8px; border: none; background: #f3f4f6; cursor: pointer; font-weight: 600; }
        .btn-submit { padding: 0.75rem 1.5rem; border-radius: 8px; border: none; background: var(--primary); color: white; cursor: pointer; font-weight: 600; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-brand">
        <i class="ri-building-4-fill"></i> Ignite Recruiter
    </div>
    <div class="nav-links">
        <span style="font-weight: 500; display: flex; align-items: center; gap: 0.5rem;">
            <% if(company.getLogoUrl() != null && !company.getLogoUrl().isEmpty()) { %>
                <img src="<%= company.getLogoUrl() %>" style="width: 24px; height: 24px; border-radius: 4px; object-fit: cover;">
            <% } %>
            <%= company.getName() %>
        </span>
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> Logout</a>
    </div>
</nav>

<div class="container">
    <div class="header-section">
        <div class="welcome-text">
            <h2>Company Dashboard</h2>
            <p>Manage your job postings and review student applications.</p>
        </div>
        <button class="btn-post-job" onclick="document.getElementById('addJobModal').style.display='flex'">
            <i class="ri-add-line"></i> Post New Job
        </button>
    </div>

    <div class="job-grid">
        <% 
            if (myJobs != null && !myJobs.isEmpty()) {
                for (Job j : myJobs) {
                    List<Application> apps = appDao.getApplicationsByJob(j.getId());
                    int applicantCount = (apps != null) ? apps.size() : 0;
        %>
        <div class="job-card">
            <div class="job-header">
                <div class="job-title"><%= j.getRole() %></div>
                <div style="background: #eff6ff; color: var(--primary); padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.875rem; font-weight: 600;">
                    <%= applicantCount %> Applicants
                </div>
            </div>
            <div class="stat-row">
                <span><i class="ri-bar-chart-line"></i> Min CGPA: <%= j.getEligibility() %></span>
                <span><i class="ri-calendar-event-line"></i> <%= j.getDeadline() %></span>
            </div>
            <a href="/placement-portal/view-applicants?jobId=<%= j.getId() %>" class="btn-view">View Applications</a>
        </div>
        <%      } 
            } else { 
        %>
        <div style="grid-column: 1 / -1; text-align: center; padding: 4rem; background: white; border-radius: 16px; border: 1px dashed #cbd5e1;">
            <i class="ri-briefcase-4-line" style="font-size: 3rem; color: #94a3b8; margin-bottom: 1rem;"></i>
            <h3 style="color: var(--text-main); font-size: 1.25rem;">No jobs posted yet.</h3>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Create your first job posting to start receiving applications.</p>
        </div>
        <% } %>
    </div>
</div>

<!-- Add Job Modal -->
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
                <button type="button" class="btn-cancel" onclick="document.getElementById('addJobModal').style.display='none'">Cancel</button>
                <button type="submit" class="btn-submit">Post Job</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
