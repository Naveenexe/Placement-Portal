<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="auth-body">

    <div class="auth-container">
        <div class="auth-left admin">
            <div class="auth-left-content">
                <div class="brand-logo">
                    <div class="brand-logo-circle" style="color: #0f172a;">
                        <i class="ri-shield-check-fill"></i>
                    </div>
                    Ignite Admin
                </div>
                <h1>System<br>administration</h1>
                <p>Manage students, approve company registrations, post placement drives, and monitor application analytics.</p>
                <a href="../../index.jsp" class="auth-back-link"><i class="ri-arrow-left-line"></i> Back to home</a>
            </div>
        </div>

        <div class="auth-right">
            <h2>Admin Sign In</h2>

            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error"><i class="ri-error-warning-fill"></i> Invalid credentials. Please try again.</div>
            <% } %>
            <%
               String succMsg = (String) session.getAttribute("succMsg");
               if (succMsg != null) {
            %>
                <div class="alert alert-success"><i class="ri-checkbox-circle-fill"></i> <%= succMsg %></div>
            <%     session.removeAttribute("succMsg"); } %>

            <form action="/placement-portal/admin-login" method="post">
                <div class="input-group">
                    <label class="input-label">Username</label>
                    <div class="input-field admin">
                        <i class="ri-user-settings-line input-icon"></i>
                        <input type="text" name="username" placeholder="admin" required>
                    </div>
                </div>

                <div class="input-group">
                    <label class="input-label">Password</label>
                    <div class="input-field admin">
                        <i class="ri-lock-line input-icon"></i>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                </div>

                <div class="auth-options">
                    <label class="checkbox-group"><input type="checkbox" name="remember"> Remember me</label>
                </div>

                <button type="submit" class="btn-primary admin">Login to Dashboard <i class="ri-arrow-right-line"></i></button>
            </form>

            <div class="auth-footer">
                New admin? <a href="register.jsp" style="color: var(--admin);">Register</a>
            </div>
        </div>
    </div>

</body>
</html>
