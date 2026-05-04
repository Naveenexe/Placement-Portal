<%@ page import="java.util.*" %>
<%@ page import="com.placement.dao.*" %>
<%@ page import="com.placement.dao.impl.*" %>
<%@ page import="com.placement.model.*" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    JobDAO jobDao = new JobDAOImpl();
    List<Job> jobs = jobDao.getAllJobs();
    CompanyDAO companyDao = new CompanyDAOImpl();
    ApplicationDAO appDao = new ApplicationDAOImpl();
    List<Company> allCompanies = companyDao.getAllCompanies();
    List<Company> pendingCompanies = new ArrayList<>();
    for(Company c : allCompanies) {
        if("Pending".equalsIgnoreCase(c.getStatus())) {
            pendingCompanies.add(c);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Ignite</title>
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0f172a; --primary-light: #334155; --accent: #3b82f6;
            --text-main: #1e293b; --text-muted: #64748b; --bg: #f8fafc;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); }
        .navbar {
            background: var(--primary); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; color: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; }
        .nav-links { display: flex; align-items: center; gap: 1.5rem; }
        .nav-link { color: #cbd5e1; text-decoration: none; font-weight: 500; display: flex; align-items: center; gap: 0.5rem; transition: color 0.2s; }
        .nav-link:hover { color: white; }
        .btn-logout { background: rgba(239, 68, 68, 0.2); color: #fca5a5; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.2s; }
        .btn-logout:hover { background: rgba(239, 68, 68, 0.3); color: white; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .page-header { margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center; }
        .page-header h2 { font-size: 2.25rem; font-weight: 800; color: var(--primary); }
        .page-header p { color: var(--text-muted); margin-top: 0.25rem; }
        .btn-add { background: var(--accent); color: white; padding: 0.75rem 1.5rem; border-radius: 8px; text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; transition: all 0.2s; box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3); }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 8px -1px rgba(59, 130, 246, 0.4); }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 1.5rem; }
        .card { background: white; border-radius: 16px; padding: 1.5rem; box-shadow: 0 2px 4px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; transition: all 0.2s; }
        .card:hover { border-color: #cbd5e1; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); }
        .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem; }
        .card-title { font-size: 1.25rem; font-weight: 700; color: var(--text-main); }
        .card-company { display: inline-flex; align-items: center; gap: 0.4rem; color: var(--primary-light); font-weight: 600; font-size: 0.875rem; background: #f1f5f9; padding: 0.3rem 0.8rem; border-radius: 999px; }
        .card-body { border-bottom: 1px solid #f1f5f9; padding-bottom: 1rem; margin-bottom: 1rem; }
        .card-body p { margin-bottom: 0.5rem; font-size: 0.95rem; color: var(--text-muted); display: flex; align-items: center; gap: 0.5rem; }
        .card-footer { display: flex; justify-content: space-between; align-items: center; }
        .applicant-count { display: flex; align-items: center; gap: 0.4rem; font-weight: 600; color: var(--text-main); }
        .badge { background: #dbeafe; color: #1e40af; padding: 0.2rem 0.6rem; border-radius: 999px; font-size: 0.8rem; }
        .view-link { color: var(--accent); text-decoration: none; font-weight: 600; font-size: 0.9rem; display: flex; align-items: center; gap: 0.3rem; transition: opacity 0.2s; }
        .view-link:hover { opacity: 0.8; }
        .btn-approve { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; border: none; padding: 0.5rem 1.25rem; border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.2s; box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.3); }
        .btn-approve:hover { transform: translateY(-2px); box-shadow: 0 6px 8px -1px rgba(16, 185, 129, 0.4); }
        .btn-reject-admin { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); color: white; border: none; padding: 0.5rem 1.25rem; border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.2s; box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3); }
        .btn-reject-admin:hover { transform: translateY(-2px); box-shadow: 0 6px 8px -1px rgba(239, 68, 68, 0.4); }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-brand">
        <i class="ri-shield-user-fill"></i> Ignite Admin
    </div>
    <div class="nav-links">
        <a href="../student/top-students.jsp" class="nav-link"><i class="ri-medal-fill"></i> Top Students</a>
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> Logout</a>
    </div>
</nav>

<div class="container">
    <% if (!pendingCompanies.isEmpty()) { %>
    <div class="page-header" style="margin-top: 2rem; border-top: 1px solid #e2e8f0; padding-top: 2rem;">
        <div>
            <h2>Pending Approvals</h2>
            <p>New company accounts waiting for your review.</p>
        </div>
    </div>
    <div class="grid" style="margin-bottom: 2rem;">
        <% for(Company pc : pendingCompanies) { %>
        <div class="card" style="border-left: 4px solid var(--accent);">
            <div class="card-header">
                <h3 class="card-title"><%= pc.getName() %></h3>
            </div>
            <div class="card-body">
                <p><i class="ri-mail-line"></i> <%= pc.getEmail() %></p>
                <p style="font-size: 0.85rem;"><%= pc.getDescription() %></p>
            </div>
            <div class="card-footer" style="justify-content: flex-end; gap: 0.75rem;">
                <form action="/placement-portal/update-company-status" method="post" style="display:inline; margin: 0;">
                    <input type="hidden" name="companyId" value="<%= pc.getId() %>">
                    <input type="hidden" name="status" value="Approved">
                    <button type="submit" class="btn-approve"><i class="ri-check-line"></i> Approve</button>
                </form>
                <form action="/placement-portal/update-company-status" method="post" style="display:inline; margin: 0;">
                    <input type="hidden" name="companyId" value="<%= pc.getId() %>">
                    <input type="hidden" name="status" value="Rejected">
                    <button type="submit" class="btn-reject-admin"><i class="ri-close-line"></i> Reject</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <div class="page-header" style="<%= !pendingCompanies.isEmpty() ? "border-top: 1px solid #e2e8f0; padding-top: 2rem;" : "" %>">
        <div>
            <h2>Placement Drives</h2>
            <p>Manage all active job openings and track student applications.</p>
        </div>
        <a href="add-job.jsp" class="btn-add"><i class="ri-add-line"></i> Post New Job</a>
    </div>

    <!-- Analytics Dashboard Section -->
    <div style="background: white; border-radius: 16px; padding: 1.5rem; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 2rem; display: flex; gap: 2rem; align-items: center;">
        <div style="flex: 1;">
            <h3 style="margin-bottom: 1rem; color: var(--text-main);"><i class="ri-pie-chart-2-fill" style="color: var(--accent);"></i> Application Statistics</h3>
            <p style="color: var(--text-muted); line-height: 1.6;">Overview of all submitted applications across active job listings.</p>
        </div>
        <div style="width: 250px; height: 250px;">
            <canvas id="applicationChart"></canvas>
        </div>
    </div>

    <div class="grid">
        <% 
            int totalPending = 0;
            int totalSelected = 0;
            int totalRejected = 0;

            for (Job j : jobs) {
                Company c = companyDao.getCompanyById(j.getCompanyId());
                if (c == null) {
                    c = new Company();
                    c.setName("Unknown Company (Deleted)");
                    c.setLogoUrl("");
                }
                List<Application> apps = appDao.getApplicationsByJob(j.getId());

                if (apps != null) {
                    for (Application a : apps) {
                        if ("Pending".equals(a.getStatus())) totalPending++;
                        else if ("Selected".equals(a.getStatus())) totalSelected++;
                        else if ("Rejected".equals(a.getStatus())) totalRejected++;
                    }
                }
        %>
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><%= j.getRole() %></h3>
                <span class="card-company" style="display: flex; align-items: center;">
                    <% if (c.getLogoUrl() != null && !c.getLogoUrl().isEmpty()) { %>
                        <img src="<%= c.getLogoUrl() %>" alt="Logo" style="width: 20px; height: 20px; object-fit: contain; margin-right: 0.5rem; border-radius: 4px;">
                    <% } else { %>
                        <i class="ri-building-4-line" style="margin-right: 0.5rem;"></i>
                    <% } %>
                    <%= c.getName() %>
                </span>
            </div>
            <div class="card-body">
                <p><i class="ri-bar-chart-line"></i> Eligibility: &ge; <%= j.getEligibility() %> CGPA</p>
                <p><i class="ri-calendar-event-line"></i> Deadline: <%= j.getDeadline() %></p>
            </div>
            <div class="card-footer">
                <div class="applicant-count">
                    <i class="ri-group-line" style="color: var(--text-muted);"></i> Applicants
                    <span class="badge"><%= apps.size() %></span>
                </div>
                <a class="view-link" href="/placement-portal/view-applicants?jobId=<%= j.getId() %>">
                    Review <i class="ri-arrow-right-s-line"></i>
                </a>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
    // Initialize Chart.js Donut Chart
    const ctx = document.getElementById('applicationChart').getContext('2d');
    let sel = <%= totalSelected %>;
    let pen = <%= totalPending %>;
    let rej = <%= totalRejected %>;
    
    let chartData = [sel, pen, rej];
    let chartColors = ['#10b981', '#3b82f6', '#ef4444'];
    let chartLabels = ['Selected', 'Pending', 'Rejected'];

    if (sel === 0 && pen === 0 && rej === 0) {
        chartData = [1];
        chartColors = ['#e2e8f0']; // Gray empty state
        chartLabels = ['No Applications Yet'];
    }

    const appChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: chartLabels,
            datasets: [{
                data: chartData,
                backgroundColor: chartColors,
                borderWidth: 0,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            },
            cutout: '70%'
        }
    });
</script>

</body>
</html>