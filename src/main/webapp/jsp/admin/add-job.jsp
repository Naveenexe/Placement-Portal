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
    <title>Post New Job | Ignite</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #0f172a; --accent: #3b82f6; --text-main: #1f2937; --bg: #f8fafc; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 2rem; }
        .card { background: white; width: 100%; max-width: 500px; border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); padding: 2.5rem; position: relative; border-top: 6px solid var(--primary); }
        .back-link { display: inline-flex; align-items: center; gap: 0.4rem; color: #64748b; text-decoration: none; font-weight: 500; margin-bottom: 2rem; transition: color 0.2s; }
        .back-link:hover { color: var(--primary); }
        .header { margin-bottom: 2rem; }
        .header h2 { font-size: 1.75rem; font-weight: 800; color: var(--primary); }
        .input-group { margin-bottom: 1.5rem; }
        .input-label { display: block; font-weight: 600; font-size: 0.875rem; margin-bottom: 0.5rem; color: var(--text-main); }
        .input-field { width: 100%; padding: 0.75rem 1rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 1rem; font-family: inherit; transition: all 0.2s; background: #f8fafc; }
        .input-field:focus { border-color: var(--accent); background: white; outline: none; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .btn-submit { width: 100%; padding: 0.875rem; background: var(--primary); color: white; border: none; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.2s; display: flex; justify-content: center; align-items: center; gap: 0.5rem; margin-top: 1rem; }
        .btn-submit:hover { background: #1e293b; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(15, 23, 42, 0.2); }
    </style>
</head>
<body>

<div class="card">
    <a href="dashboard.jsp" class="back-link"><i class="ri-arrow-left-line"></i> Back to Dashboard</a>
    
    <div class="header">
        <h2>Post New Job</h2>
        <p style="color: #64748b; margin-top: 0.25rem;">Create a new drive for students to apply.</p>
    </div>

    <form action="/placement-portal/add-job" method="post">
        <div class="input-group">
            <label class="input-label">Select Company</label>
            <select name="companyId" class="input-field" required>
                <% for (Company c : companies) { %>
                    <option value="<%= c.getId() %>"><%= c.getName() %></option>
                <% } %>
            </select>
        </div>

        <div class="input-group">
            <label class="input-label">Job Role</label>
            <input type="text" name="role" class="input-field" placeholder="e.g. Software Engineer" required>
        </div>

        <div class="input-group">
            <label class="input-label">Eligibility Cut-off (CGPA)</label>
            <input type="number" step="0.01" name="eligibility" class="input-field" placeholder="e.g. 7.5" required>
        </div>

        <div class="input-group">
            <label class="input-label">Application Deadline</label>
            <input type="date" name="deadline" class="input-field" required>
        </div>

        <button type="submit" class="btn-submit"><i class="ri-check-line"></i> Create Drive</button>
    </form>
</div>

</body>
</html>