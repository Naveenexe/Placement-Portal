<%@ page import="java.util.*" %>
<%@ page import="com.placement.dao.*" %>
<%@ page import="com.placement.dao.impl.*" %>
<%@ page import="com.placement.model.*" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../admin/login.jsp");
        return;
    }
    StudentDAO studentDao = new StudentDAOImpl();
    List<Student> students = studentDao.getTopStudents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Students · Ignite Admin</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<nav class="navbar admin">
    <a href="../admin/dashboard.jsp" class="nav-brand admin"><i class="ri-arrow-left-line"></i> Admin Panel</a>
    <div class="nav-links">
        <a href="/placement-portal/logout" class="btn-logout"><i class="ri-logout-box-r-line"></i> <span>Logout</span></a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2><i class="ri-medal-line" style="color: var(--warning);"></i> Top Students</h2>
            <p>Highest performing students ranked by CGPA.</p>
        </div>
    </div>

    <div class="list-container">
        <%
            int rank = 1;
            for (Student s : students) {
        %>
        <div class="applicant-card" style="position: relative; overflow: hidden;">
            <% if (rank == 1) { %><div class="rank-indicator top1"></div>
            <% } else if (rank == 2) { %><div class="rank-indicator top2"></div>
            <% } else if (rank == 3) { %><div class="rank-indicator top3"></div>
            <% } %>

            <% if (s.getProfilePic() != null) { %>
                <img src="/placement-portal/<%= s.getProfilePic() %>" class="profile-img-sm" alt="Profile">
            <% } else { %>
                <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(s.getName(), "UTF-8") %>&background=e2e8f0&color=64748b" class="profile-img-sm" alt="Avatar">
            <% } %>

            <div class="applicant-info" style="flex: 1;">
                <h3><%= s.getName() %></h3>
                <div class="applicant-meta">
                    <span><i class="ri-mail-line"></i> <%= s.getEmail() %></span>
                    <% if (s.getBranch() != null && !s.getBranch().isEmpty()) { %>
                        <span><i class="ri-book-read-line"></i> <%= s.getBranch() %></span>
                    <% } %>
                </div>
            </div>

            <div class="cgpa-badge">
                <i class="ri-star-fill"></i> <%= s.getCgpa() %>
            </div>

            <% if (s.getResumePath() != null && !s.getResumePath().trim().isEmpty()) { %>
            <a class="btn-resume" href="/placement-portal/<%= s.getResumePath() %>" target="_blank">
                <i class="ri-file-text-line"></i> Resume
            </a>
            <% } else { %>
            <span style="font-size: 0.78rem; color: var(--text-soft); font-style: italic;">No Resume</span>
            <% } %>
        </div>
        <% rank++; } %>
    </div>
</div>

</body>
</html>
