<%@ page import="java.util.*" %>
<%@ page import="com.placement.dao.*" %>
<%@ page import="com.placement.dao.impl.*" %>
<%@ page import="com.placement.model.*" %>
<%
    CompanyDAO companyDao = new CompanyDAOImpl();
    List<Company> companies = companyDao.getAllCompanies();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post New Job · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<div class="form-card">
    <a href="dashboard.jsp" class="back-link" style="margin-bottom: 1.5rem;"><i class="ri-arrow-left-line"></i> Back to Dashboard</a>

    <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--text); margin-bottom: 0.4rem; letter-spacing: -0.02em;">Post New Job</h2>
    <p style="color: var(--text-muted); margin-bottom: 1.75rem; font-size: 0.9rem;">Create a new placement drive for students to apply.</p>

    <form action="/placement-portal/add-job" method="post">
        <div class="input-group">
            <label class="input-label">Select Company</label>
            <div class="input-field">
                <i class="ri-building-4-line input-icon"></i>
                <select name="companyId" required>
                    <% for (Company c : companies) { %>
                        <option value="<%= c.getId() %>"><%= c.getName() %></option>
                    <% } %>
                </select>
            </div>
        </div>

        <div class="input-group">
            <label class="input-label">Job Role</label>
            <div class="input-field">
                <i class="ri-briefcase-line input-icon"></i>
                <input type="text" name="role" placeholder="e.g. Software Engineer" required>
            </div>
        </div>

        <div class="input-group">
            <label class="input-label">Eligibility Cut-off (CGPA)</label>
            <div class="input-field">
                <i class="ri-bar-chart-line input-icon"></i>
                <input type="number" step="0.01" name="eligibility" placeholder="e.g. 7.5" required>
            </div>
        </div>

        <div class="input-group">
            <label class="input-label">Application Deadline</label>
            <div class="input-field">
                <i class="ri-calendar-event-line input-icon"></i>
                <input type="date" name="deadline" required>
            </div>
        </div>

        <button type="submit" class="btn-primary" style="margin-top: 0.5rem;"><i class="ri-check-line"></i> Create Drive</button>
    </form>
</div>

</body>
</html>
