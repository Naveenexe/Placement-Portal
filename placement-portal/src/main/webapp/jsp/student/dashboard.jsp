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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | Ignite</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3b82f6; --primary-dark: #2563eb;
            --success: #10b981; --danger: #ef4444; --warning: #f59e0b;
            --text-main: #1f2937; --text-muted: #6b7280; --bg: #f8fafc;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); }
        .navbar {
            background: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { font-size: 1.5rem; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 0.5rem; }
        .nav-links { display: flex; align-items: center; gap: 1.5rem; }
        .nav-link { color: var(--text-muted); text-decoration: none; font-weight: 500; display: flex; align-items: center; gap: 0.5rem; transition: color 0.2s; }
        .nav-link:hover { color: var(--primary); }
        .btn-logout { background: #fee2e2; color: #dc2626; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.2s; }
        .btn-logout:hover { background: #fecaca; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .page-header { margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: flex-end; }
        .page-header h2 { font-size: 2rem; font-weight: 700; color: var(--text-main); }
        .page-header p { color: var(--text-muted); margin-top: 0.5rem; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 1.5rem; }
        .card { background: white; border-radius: 16px; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; transition: transform 0.2s, box-shadow 0.2s; }
        .card:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
        .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem; }
        .card-title { font-size: 1.25rem; font-weight: 600; color: var(--text-main); }
        .card-company { color: var(--primary); font-weight: 500; font-size: 0.875rem; background: #eff6ff; padding: 0.25rem 0.75rem; border-radius: 999px; }
        .card-body p { margin-bottom: 0.5rem; font-size: 0.95rem; color: var(--text-muted); display: flex; align-items: center; gap: 0.5rem; }
        .card-footer { margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end; align-items: center; }
        .btn { padding: 0.6rem 1.2rem; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 0.5rem; text-decoration: none; font-size: 0.9rem;}
        .btn-apply { background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%); color: white; box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3); }
        .btn-apply:hover { transform: translateY(-2px); box-shadow: 0 6px 8px -1px rgba(59, 130, 246, 0.4); }
        .status-badge { padding: 0.4rem 1rem; border-radius: 999px; font-weight: 600; font-size: 0.875rem; display: inline-flex; align-items: center; gap: 0.3rem;}
        .status-selected { background: #d1fae5; color: #059669; }
        .status-rejected { background: #fee2e2; color: #dc2626; }
        .status-pending { background: #f3f4f6; color: #4b5563; }
        .btn-icon { background: none; border: none; font-size: 1.25rem; cursor: pointer; color: #cbd5e1; transition: color 0.2s, transform 0.2s; }
        .btn-icon:hover { transform: scale(1.1); }
        .btn-icon.active { color: #ef4444; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-brand">
        <i class="ri-graduation-cap-fill"></i> Ignite
    </div>
    <div class="nav-links">
        <span style="font-weight: 500;">Hello, <%= s.getName() %></span>
        <a href="profile.jsp" class="nav-link"><i class="ri-user-settings-line"></i> Profile</a>
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> Logout</a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>Available Opportunities</h2>
            <p>Discover and apply for your dream jobs based on your eligibility.</p>
        </div>
        <div style="flex-grow: 1; max-width: 400px; margin-left: 2rem;">
            <input type="text" id="jobSearch" placeholder="Search by role or company..." 
                   style="width: 100%; padding: 0.75rem 1rem; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 1rem; outline: none; transition: border-color 0.2s;">
        </div>
    </div>

    <div class="grid">
        <% 
            boolean hasJobs = false;
            for (Job j : jobs) {
                if (s.getCgpa() >= j.getEligibility()) {
                    hasJobs = true;
                    Application app = appDao.getApplication(s.getId(), j.getId());
                    Company c = companyDao.getCompanyById(j.getCompanyId());
                    if (c == null) {
                        c = new Company();
                        c.setName("Unknown Company (Deleted)");
                        c.setLogoUrl("");
                    }
                    boolean inWishlist = wishlistDao.isJobInWishlist(s.getId(), j.getId());
        %>
        <div class="card">
            <div class="card-header">
                <div style="display: flex; justify-content: space-between; align-items: center; width: 100%; margin-bottom: 0.5rem;">
                    <h3 class="card-title"><%= j.getRole() %></h3>
                    <form action="/placement-portal/toggle-wishlist" method="post" style="margin: 0;">
                        <input type="hidden" name="jobId" value="<%= j.getId() %>">
                        <input type="hidden" name="action" value="<%= inWishlist ? "remove" : "add" %>">
                        <button type="submit" class="btn-icon <%= inWishlist ? "active" : "" %>" title="<%= inWishlist ? "Remove from Saved" : "Save for Later" %>">
                            <i class="<%= inWishlist ? "ri-heart-3-fill" : "ri-heart-3-line" %>"></i>
                        </button>
                    </form>
                </div>
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
                    <span style="font-size: 0.875rem; color: var(--text-muted); font-weight: 500;">Application Status</span>
                    <span class="status-badge <%= badgeClass %>"><i class="<%= icon %>"></i> <%= status %></span>
                </div>
                <% } %>
            </div>
        </div>
        <%      }
            } 
            if (!hasJobs) {
        %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 4rem; background: white; border-radius: 16px; border: 1px dashed #cbd5e1;">
                <i class="ri-file-search-line" style="font-size: 3rem; color: #94a3b8; margin-bottom: 1rem;"></i>
                <h3 style="color: var(--text-main); font-size: 1.25rem;">No jobs currently matching your profile.</h3>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Keep your profile updated and check back later.</p>
            </div>
        <%  } %>
    </div>
</div>

<script>
    // Live Search Filter functionality
    document.getElementById('jobSearch').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const jobCards = document.querySelectorAll('.card');
        
        jobCards.forEach(card => {
            const title = card.querySelector('.card-title') ? card.querySelector('.card-title').innerText.toLowerCase() : '';
            const company = card.querySelector('.card-company') ? card.querySelector('.card-company').innerText.toLowerCase() : '';
            
            if (title.includes(searchTerm) || company.includes(searchTerm)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    });
</script>

</body>
</html>