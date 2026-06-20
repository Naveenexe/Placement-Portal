<%@ page import="com.placement.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.placement.dao.*" %>
<%@ page import="com.placement.dao.impl.*" %>
<%
    Student s = (Student) session.getAttribute("student");
    if (s == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    JobDAO jobDao = new JobDAOImpl();
    List<Job> jobs = jobDao.getAllJobs();
    ApplicationDAO appDao = new ApplicationDAOImpl();
    CompanyDAO companyDao = new CompanyDAOImpl();
    WishlistDAO wishlistDao = new WishlistDAOImpl();

    int appliedCount = 0;
    int selectedCount = 0;
    int wishlistCount = 0;
    for (Job jx : jobs) {
        if (s.getCgpa() >= jx.getEligibility()) {
            Application ax = appDao.getApplication(s.getId(), jx.getId());
            if (ax != null) {
                appliedCount++;
                if ("Selected".equals(ax.getStatus())) selectedCount++;
            }
            if (wishlistDao.isJobInWishlist(s.getId(), jx.getId())) wishlistCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<nav class="navbar">
    <a href="dashboard.jsp" class="nav-brand student"><i class="ri-graduation-cap-fill"></i> Ignite</a>
    <div class="nav-links">
        <span class="nav-link"><i class="ri-user-line"></i> <span>Hello, <%= s.getName() %></span></span>
        <a href="profile.jsp" class="nav-link"><i class="ri-user-settings-line"></i> <span>Profile</span></a>
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> <span>Logout</span></a>
    </div>
</nav>

<div class="container">
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon blue"><i class="ri-bar-chart-2-line"></i></div>
            <div>
                <div class="stat-value"><%= s.getCgpa() %></div>
                <div class="stat-label">Your CGPA</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber"><i class="ri-send-plane-line"></i></div>
            <div>
                <div class="stat-value"><%= appliedCount %></div>
                <div class="stat-label">Applications</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="ri-checkbox-circle-line"></i></div>
            <div>
                <div class="stat-value"><%= selectedCount %></div>
                <div class="stat-label">Selected</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon violet"><i class="ri-heart-3-line"></i></div>
            <div>
                <div class="stat-value"><%= wishlistCount %></div>
                <div class="stat-label">Saved Jobs</div>
            </div>
        </div>
    </div>

    <div class="page-header">
        <div>
            <h2>Available Opportunities</h2>
            <p>Discover and apply for placement drives matching your eligibility.</p>
        </div>
        <div style="flex-grow: 1; max-width: 380px; margin-left: 2rem;">
            <div class="input-field">
                <i class="ri-search-line input-icon"></i>
                <input type="text" id="jobSearch" placeholder="Search by role or company...">
            </div>
        </div>
    </div>

    <div class="grid">
        <%
            boolean hasJobs = false;
            for (Job j : jobs) {
                if (s.getCgpa() >= j.getEligibility()) {
                    hasJobs = true;
                    Application app = appDao.getApplication(s.getId(), j.getId());
                    boolean inWishlist = wishlistDao.isJobInWishlist(s.getId(), j.getId());
                    Company c = companyDao.getCompanyById(j.getCompanyId());
                    if (c == null) {
                        c = new Company();
                        c.setName("Unknown Company (Deleted)");
                        c.setLogoUrl("");
                    }
        %>
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><%= j.getRole() %></h3>
                <form action="/placement-portal/toggle-wishlist" method="post" style="margin: 0;">
                    <input type="hidden" name="jobId" value="<%= j.getId() %>">
                    <input type="hidden" name="action" value="<%= inWishlist ? "remove" : "add" %>">
                    <button type="submit" class="btn-icon <%= inWishlist ? "active" : "" %>" title="<%= inWishlist ? "Remove from Saved" : "Save for Later" %>">
                        <i class="<%= inWishlist ? "ri-heart-3-fill" : "ri-heart-3-line" %>"></i>
                    </button>
                </form>
            </div>
            <span class="card-company">
                <% if (c.getLogoUrl() != null && !c.getLogoUrl().isEmpty()) { %>
                    <img src="<%= c.getLogoUrl() %>" alt="Logo" style="width: 18px; height: 18px; object-fit: contain; border-radius: 3px;">
                <% } else { %>
                    <i class="ri-building-4-line"></i>
                <% } %>
                <%= c.getName() %>
            </span>
            <div class="card-body">
                <p><i class="ri-bar-chart-line"></i> Eligibility: &ge; <%= j.getEligibility() %> CGPA</p>
                <p><i class="ri-calendar-event-line"></i> Deadline: <%= j.getDeadline() %></p>
            </div>
            <div class="card-footer">
                <% if (app == null) { %>
                    <form action="/placement-portal/apply" method="post" style="margin: 0; width: 100%;">
                        <input type="hidden" name="jobId" value="<%= j.getId() %>">
                        <button class="btn btn-apply" style="width: 100%; justify-content: center;"><i class="ri-send-plane-fill"></i> Apply Now</button>
                    </form>
                <% } else {
                    String status = app.getStatus();
                    String badgeClass = "status-pending";
                    String icon = "ri-time-line";
                    if ("Selected".equals(status)) { badgeClass = "status-selected"; icon = "ri-checkbox-circle-fill"; }
                    else if ("Rejected".equals(status)) { badgeClass = "status-rejected"; icon = "ri-close-circle-fill"; }
                %>
                    <div style="width: 100%; display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 500;">Application Status</span>
                        <span class="status-badge <%= badgeClass %>"><i class="<%= icon %>"></i> <%= status %></span>
                    </div>
                <% } %>
            </div>
        </div>
        <%      }
            }
            if (!hasJobs) {
        %>
            <div class="empty-state">
                <i class="ri-file-search-line"></i>
                <h3>No jobs currently matching your profile.</h3>
                <p>Keep your profile updated and check back later.</p>
            </div>
        <%  } %>
    </div>
</div>

<script>
    document.getElementById('jobSearch').addEventListener('input', function(e) {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('.card').forEach(card => {
            const title = card.querySelector('.card-title') ? card.querySelector('.card-title').innerText.toLowerCase() : '';
            const company = card.querySelector('.card-company') ? card.querySelector('.card-company').innerText.toLowerCase() : '';
            card.style.display = (title.includes(term) || company.includes(term)) ? 'flex' : 'none';
        });
    });
</script>

</body>
</html>
