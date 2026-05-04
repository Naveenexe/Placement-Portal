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
    <title>Top Students | Ignite Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #0f172a; --accent: #f59e0b; --text-main: #1f2937; --text-muted: #64748b; --bg: #f8fafc; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); }
        .navbar { background: var(--primary); padding: 1rem 2rem; color: white; display: flex; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .nav-brand { font-size: 1.25rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; text-decoration: none; color: white; }
        .container { max-width: 900px; margin: 2rem auto; padding: 0 1rem; }
        .page-header { margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center; }
        .page-header h2 { font-size: 2rem; font-weight: 800; color: var(--primary); display: flex; align-items: center; gap: 0.5rem; }
        .list-container { display: flex; flex-direction: column; gap: 1rem; }
        .card { background: white; border-radius: 12px; padding: 1.5rem; box-shadow: 0 2px 5px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; display: flex; align-items: center; transition: all 0.2s; position: relative; overflow: hidden; }
        .card:hover { border-color: var(--accent); box-shadow: 0 5px 15px rgba(0,0,0,0.05); transform: translateX(4px); }
        .rank-indicator { position: absolute; left: 0; top: 0; bottom: 0; width: 6px; background: var(--accent); }
        .profile-img { width: 60px; height: 60px; border-radius: 50%; object-fit: cover; margin-right: 1.5rem; border: 2px solid #f1f5f9; background: #e2e8f0; }
        .student-info { flex: 1; }
        .student-info h3 { font-size: 1.25rem; font-weight: 700; margin-bottom: 0.25rem; }
        .student-meta { display: flex; gap: 1rem; font-size: 0.875rem; color: var(--text-muted); }
        .student-meta span { display: flex; align-items: center; gap: 0.25rem; }
        .cgpa-badge { background: #fef3c7; color: #b45309; padding: 0.3rem 0.8rem; border-radius: 999px; font-weight: 800; font-size: 1rem; display: flex; align-items: center; gap: 0.3rem; margin-right: 1.5rem; }
        .btn-resume { padding: 0.6rem 1.2rem; border-radius: 8px; border: 1px solid #cbd5e1; background: white; color: var(--text-main); font-weight: 600; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 0.4rem; text-decoration: none; }
        .btn-resume:hover { background: #f8fafc; border-color: var(--primary); color: var(--primary); }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="../admin/dashboard.jsp" class="nav-brand"><i class="ri-arrow-left-line"></i> Back to Admin Dashboard</a>
</nav>

<div class="container">
    <div class="page-header">
        <h2><i class="ri-medal-line" style="color: var(--accent);"></i> Top Students</h2>
    </div>

    <div class="list-container">
        <% 
            int rank = 1;
            for (Student s : students) { 
        %>
        <div class="card">
            <% if (rank <= 3) { %><div class="rank-indicator"></div><% } %>
            
            <% if (s.getProfilePic() != null) { %>
                <img src="/placement-portal/<%= s.getProfilePic() %>" class="profile-img" alt="Profile">
            <% } else { %>
                <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(s.getName(), "UTF-8") %>&background=e2e8f0&color=64748b" class="profile-img" alt="Avatar">
            <% } %>

            <div class="student-info">
                <h3><%= s.getName() %></h3>
                <div class="student-meta">
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
            <span style="font-size: 0.8rem; color: #94a3b8; font-style: italic;">No Resume Map</span>
            <% } %>
        </div>
        <% rank++; } %>
    </div>
</div>

</body>
</html>