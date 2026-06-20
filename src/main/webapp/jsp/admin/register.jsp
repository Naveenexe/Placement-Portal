<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration · Ignite</title>
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
                <h1>System<br>onboarding</h1>
                <p>Register as an administrator to access system management, user control, and placement pipelines.</p>
                <a href="login.jsp" class="auth-back-link"><i class="ri-arrow-left-line"></i> Back to login</a>
            </div>
        </div>

        <div class="auth-right">
            <h2>Admin Registration</h2>
            <%
               String errorMsg = (String) session.getAttribute("errorMsg");
               if (errorMsg != null) {
            %>
                <div class="alert alert-error"><i class="ri-error-warning-fill"></i> <%= errorMsg %></div>
            <%     session.removeAttribute("errorMsg"); } %>

            <form action="/placement-portal/admin-register" method="post">
                <div class="input-group">
                    <label class="input-label">Username</label>
                    <div class="input-field admin">
                        <i class="ri-user-settings-line input-icon"></i>
                        <input type="text" name="username" placeholder="Choose a username" required>
                    </div>
                </div>

                <div class="input-group">
                    <label class="input-label">Password</label>
                    <div class="input-field admin">
                        <i class="ri-lock-line input-icon"></i>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary admin" style="margin-top: 0.5rem;">Register Account <i class="ri-check-line"></i></button>
            </form>

            <div class="auth-footer">
                Already have an account? <a href="login.jsp" style="color: var(--admin);">Sign in</a>
            </div>
        </div>
    </div>

</body>
</html>
