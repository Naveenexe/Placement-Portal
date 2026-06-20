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
    StudentDAO studentDao = new StudentDAOImpl();
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard · Ignite</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<nav class="navbar admin">
    <a href="dashboard.jsp" class="nav-brand admin"><i class="ri-shield-user-fill"></i> Ignite Admin</a>
    <div class="nav-links">
        <a href="../student/top-students.jsp" class="nav-link"><i class="ri-medal-fill"></i> <span>Top Students</span></a>
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> <span>Logout</span></a>
    </div>
</nav>

<div class="container">
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon blue"><i class="ri-briefcase-4-line"></i></div>
            <div><div class="stat-value"><%= jobs.size() %></div><div class="stat-label">Active Drives</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="ri-building-4-line"></i></div>
            <div><div class="stat-value"><%= allCompanies.size() %></div><div class="stat-label">Companies</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber"><i class="ri-time-line"></i></div>
            <div><div class="stat-value"><%= pendingCompanies.size() %></div><div class="stat-label">Pending Approvals</div></div>
        </div>
    </div>

    <% if (!pendingCompanies.isEmpty()) { %>
    <div class="page-header" style="margin-top: 1rem;">
        <div>
            <h2>Pending Approvals</h2>
            <p>New company accounts waiting for your review.</p>
        </div>
    </div>
    <div class="grid" style="margin-bottom: 2rem;">
        <% for(Company pc : pendingCompanies) { %>
        <div class="card" style="border-left: 4px solid var(--warning);">
            <div class="card-header">
                <h3 class="card-title"><%= pc.getName() %></h3>
            </div>
            <div class="card-body">
                <p><i class="ri-mail-line"></i> <%= pc.getEmail() %></p>
                <p><i class="ri-file-text-line"></i> <%= pc.getDescription() %></p>
            </div>
            <div class="card-footer" style="gap: 0.6rem;">
                <form action="/placement-portal/update-company-status" method="post" style="flex: 1; margin: 0;">
                    <input type="hidden" name="companyId" value="<%= pc.getId() %>">
                    <input type="hidden" name="status" value="Approved">
                    <button type="submit" class="btn btn-approve" style="width: 100%; justify-content: center;"><i class="ri-check-line"></i> Approve</button>
                </form>
                <form action="/placement-portal/update-company-status" method="post" style="flex: 1; margin: 0;">
                    <input type="hidden" name="companyId" value="<%= pc.getId() %>">
                    <input type="hidden" name="status" value="Rejected">
                    <button type="submit" class="btn btn-reject-admin" style="width: 100%; justify-content: center;"><i class="ri-close-line"></i> Reject</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <div class="page-header">
        <div>
            <h2>Placement Drives</h2>
            <p>Manage active job openings and review applications.</p>
        </div>
        <a href="add-job.jsp" class="btn-add"><i class="ri-add-line"></i> Post New Job</a>
    </div>

    <div class="analytics-panel">
        <div style="flex: 1;">
            <h3><i class="ri-pie-chart-2-fill" style="color: var(--primary);"></i> Application Statistics</h3>
            <p>Overview of all submitted applications across active job listings.</p>
        </div>
        <div class="chart-wrap">
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
                    c.setName("Unknown Company");
                    c.setLogoUrl("");
                }
                List<Application> apps = appDao.getApplicationsByJob(j.getId());
                if (apps != null) {
                    for (Application a : apps) {
                        if ("Pending".equals(a.getStatus()) || "Applied".equals(a.getStatus())) totalPending++;
                        else if ("Selected".equals(a.getStatus())) totalSelected++;
                        else if ("Rejected".equals(a.getStatus())) totalRejected++;
                    }
                }
        %>
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><%= j.getRole() %></h3>
                <span class="card-company">
                    <% if (c.getLogoUrl() != null && !c.getLogoUrl().isEmpty()) { %>
                        <img src="<%= c.getLogoUrl() %>" alt="Logo" style="width: 18px; height: 18px; object-fit: contain; border-radius: 3px;">
                    <% } else { %>
                        <i class="ri-building-4-line"></i>
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
                    <i class="ri-group-line" style="color: var(--text-muted);"></i> Applicants <span class="badge"><%= apps != null ? apps.size() : 0 %></span>
                </div>
                <a class="view-link" href="/placement-portal/view-applicants?jobId=<%= j.getId() %>">Review <i class="ri-arrow-right-s-line"></i></a>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
    const ctx = document.getElementById('applicationChart').getContext('2d');
    let sel = <%= totalSelected %>;
    let pen = <%= totalPending %>;
    let rej = <%= totalRejected %>;

    let chartData = [sel, pen, rej];
    let chartColors = ['#10b981', '#3b82f6', '#ef4444'];
    let chartLabels = ['Selected', 'Pending', 'Rejected'];

    if (sel === 0 && pen === 0 && rej === 0) {
        chartData = [1];
        chartColors = ['#e2e8f0'];
        chartLabels = ['No Applications Yet'];
    }

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: chartLabels,
            datasets: [{
                data: chartData,
                backgroundColor: chartColors,
                borderWidth: 0,
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { padding: 14, font: { size: 11, family: 'Inter' } } } },
            cutout: '68%'
        }
    });
</script>

</body>
</html>
