<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Login · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="auth-body">

    <div class="auth-container">
        <div class="auth-left company">
            <div class="auth-left-content">
                <div class="brand-logo">
                    <div class="brand-logo-circle" style="color: #0f766e;">
                        <i class="ri-building-4-fill"></i>
                    </div>
                    Ignite Recruiter
                </div>
                <h1>Hire top<br>talent today.</h1>
                <p>Access a diverse pool of brilliant students ready to make an impact at your company.</p>
                <a href="../../index.jsp" class="auth-back-link"><i class="ri-arrow-left-line"></i> Back to home</a>
            </div>
        </div>

        <div class="auth-right">
            <h2>Recruiter Sign In</h2>
            <%
                String errorMsg = (String) session.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
                <div class="alert alert-error"><i class="ri-error-warning-fill"></i> <%= errorMsg %></div>
            <%     session.removeAttribute("errorMsg"); }
                String succMsg = (String) session.getAttribute("succMsg");
                if (succMsg != null) {
            %>
                <div class="alert alert-success"><i class="ri-checkbox-circle-fill"></i> <%= succMsg %></div>
            <%     session.removeAttribute("succMsg"); } %>

            <form action="/placement-portal/company-login" method="post">
                <div class="input-group">
                    <label class="input-label">Company Email</label>
                    <div class="input-field company">
                        <i class="ri-mail-line input-icon"></i>
                        <input type="email" name="email" placeholder="hr@company.com" required>
                    </div>
                </div>
                <div class="input-group">
                    <label class="input-label">Password</label>
                    <div class="input-field company">
                        <i class="ri-lock-line input-icon"></i>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary company">Sign In <i class="ri-arrow-right-line"></i></button>
            </form>

            <div class="auth-footer">
                New company? <a href="register.jsp" style="color: var(--company);">Register here</a>
            </div>
        </div>
    </div>

</body>
</html>
