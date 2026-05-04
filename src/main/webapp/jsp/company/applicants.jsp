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
    <title>Review Applicants | Ignite Recruiter</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #8b5cf6; --primary-dark: #7c3aed;
            --text-main: #1f2937; --text-muted: #64748b; --bg: #f8fafc; 
            --success: #10b981; --danger: #ef4444; 
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); }
        .navbar {
            background: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { font-size: 1.5rem; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 0.5rem; text-decoration: none;}
        .container { max-width: 900px; margin: 2rem auto; padding: 0 1rem; }
        .page-header { margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center; }
        .page-header h2 { font-size: 2rem; font-weight: 800; color: var(--text-main); }
        .list-container { display: flex; flex-direction: column; gap: 1rem; }
        .card { background: white; border-radius: 12px; padding: 1.5rem; box-shadow: 0 2px 5px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; transition: all 0.2s; }
        .card:hover { border-color: #cbd5e1; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transform: translateY(-2px);}
        .student-info h3 { font-size: 1.25rem; font-weight: 700; margin-bottom: 0.25rem; }
        .student-meta { display: flex; gap: 1rem; font-size: 0.875rem; color: var(--text-muted); }
        .student-meta span { display: flex; align-items: center; gap: 0.25rem; }
        .status-badge { padding: 0.25rem 0.75rem; border-radius: 999px; font-weight: 600; font-size: 0.8rem; display: inline-flex; align-items: center; gap: 0.25rem; margin-top: 0.5rem; }
        .status-Pending { background: #f1f5f9; color: #475569; }
        .status-Selected { background: #d1fae5; color: #047857; }
        .status-Rejected { background: #fee2e2; color: #b91c1c; }
        .action-form { display: flex; gap: 0.5rem; }
        .btn { padding: 0.5rem 1rem; border-radius: 6px; border: none; font-weight: 600; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 0.3rem; margin: 0; }
        .btn-select { background: #d1fae5; color: #047857; }
        .btn-select:hover { background: #10b981; color: white; }
        .btn-reject { background: #fee2e2; color: #b91c1c; }
        .btn-reject:hover { background: #ef4444; color: white; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="/placement-portal/jsp/company/dashboard.jsp" class="nav-brand"><i class="ri-arrow-left-line"></i> Back to Dashboard</a>
</nav>

<div class="container">
    <div class="page-header">
        <h2>Review Applicants</h2>
    </div>

    <div class="list-container">
        <% if (list != null && !list.isEmpty()) { 
            for (Application a : list) {
                Student st = studentDao.getStudentById(a.getStudentId());
        %>
        <div class="card">
            <div class="student-info">
                <h3><%= st.getName() %></h3>
                <div class="student-meta">
                    <span><i class="ri-mail-line"></i> <%= st.getEmail() %></span>
                    <span><i class="ri-phone-line"></i> <%= st.getContactNumber() %></span>
                    <span><i class="ri-bar-chart-box-line"></i> CGPA: <%= st.getCgpa() %></span>
                    <% if(st.getResumePath() != null && !st.getResumePath().isEmpty()) { %>
                        <a href="<%= request.getContextPath() + "/" + st.getResumePath() %>" target="_blank" style="color: var(--primary); text-decoration: none; font-weight: 500; display: flex; align-items: center; gap: 0.25rem;"><i class="ri-file-text-line"></i> View Resume</a>
                    <% } %>
                </div>
                <div class="status-badge status-<%= a.getStatus() %>">
                    Current Status: <%= a.getStatus() %>
                </div>
            </div>
            
            <% if ("Pending".equals(a.getStatus())) { %>
            <form action="/placement-portal/update-status" method="post" class="action-form">
                <input type="hidden" name="appId" value="<%= a.getId() %>">
                <button type="submit" class="btn btn-select" name="status" value="Selected"><i class="ri-check-double-line"></i> Select</button>
                <button type="submit" class="btn btn-reject" name="status" value="Rejected"><i class="ri-close-line"></i> Reject</button>
            </form>
            <% } else if ("Selected".equals(a.getStatus())) { %>
                <div style="font-weight: 700; color: #10b981; display:flex; align-items:center; gap:0.5rem; font-size: 1.1rem; padding: 0.5rem 1rem;"><i class="ri-checkbox-circle-fill" style="font-size: 1.5rem;"></i> Accepted</div>
            <% } else if ("Rejected".equals(a.getStatus())) { %>
                <div style="font-weight: 700; color: #ef4444; display:flex; align-items:center; gap:0.5rem; font-size: 1.1rem; padding: 0.5rem 1rem;"><i class="ri-close-circle-fill" style="font-size: 1.5rem;"></i> Rejected</div>
            <% } %>
        </div>
        <%  } } else { %>
            <div style="text-align: center; padding: 4rem; background: white; border-radius: 12px; border: 1px dashed #cbd5e1;">
                <i class="ri-inbox-2-line" style="font-size: 3rem; color: #94a3b8; margin-bottom: 1rem;"></i>
                <h3 style="color: var(--text-main); font-size: 1.25rem;">No applicants yet.</h3>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>
