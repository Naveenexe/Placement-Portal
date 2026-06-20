<%@ page import="java.util.*" %>
<%@ page import="com.placement.model.*" %>
<%@ page import="com.placement.dao.*" %>
<%@ page import="com.placement.dao.impl.*" %>
<%
    Company company = (Company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect("login.jsp");
        return;
    }
  List<Application> list = (List<Application>) request.getAttribute("applications");
  StudentDAO studentDao = new StudentDAOImpl();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Applicants · Ignite Recruiter</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<nav class="navbar">
    <a href="/placement-portal/jsp/company/dashboard.jsp" class="nav-brand company"><i class="ri-arrow-left-line"></i> Back to Dashboard</a>
</nav>

<div class="container">
    <div class="page-header">
        <div><h2>Review Applicants</h2><p>Select or reject candidates who applied for your position.</p></div>
    </div>

    <div class="list-container">
        <% if (list != null && !list.isEmpty()) {
            for (Application a : list) {
                Student st = studentDao.getStudentById(a.getStudentId());
        %>
        <div class="applicant-card">
            <div class="applicant-info">
                <h3><%= st.getName() %></h3>
                <div class="applicant-meta">
                    <span><i class="ri-mail-line"></i> <%= st.getEmail() %></span>
                    <% if(st.getContactNumber() != null && !st.getContactNumber().isEmpty()) { %>
                        <span><i class="ri-phone-line"></i> <%= st.getContactNumber() %></span>
                    <% } %>
                    <span><i class="ri-bar-chart-box-line"></i> CGPA: <%= st.getCgpa() %></span>
                    <% if(st.getResumePath() != null && !st.getResumePath().isEmpty()) { %>
                        <a class="resume-link" href="<%= request.getContextPath() + "/" + st.getResumePath() %>" target="_blank"><i class="ri-file-text-line"></i> View Resume</a>
                    <% } %>
                </div>
                <div class="status-badge status-<%= a.getStatus() %>" style="margin-top: 0.6rem;">
                    Status: <%= a.getStatus() %>
                </div>
            </div>

            <% if ("Pending".equals(a.getStatus()) || "Applied".equals(a.getStatus())) { %>
            <form action="/placement-portal/update-status" method="post" class="action-form">
                <input type="hidden" name="appId" value="<%= a.getId() %>">
                <button type="submit" class="btn btn-select" name="status" value="Selected"><i class="ri-check-double-line"></i> Select</button>
                <button type="submit" class="btn btn-reject" name="status" value="Rejected"><i class="ri-close-line"></i> Reject</button>
            </form>
            <% } else if ("Selected".equals(a.getStatus())) { %>
                <div class="result-tag accepted"><i class="ri-checkbox-circle-fill"></i> Accepted</div>
            <% } else if ("Rejected".equals(a.getStatus())) { %>
                <div class="result-tag rejected"><i class="ri-close-circle-fill"></i> Rejected</div>
            <% } %>
        </div>
        <%  } } else { %>
            <div class="empty-state">
                <i class="ri-inbox-2-line"></i>
                <h3>No applicants yet.</h3>
                <p>When students apply to your job, they'll appear here.</p>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>
