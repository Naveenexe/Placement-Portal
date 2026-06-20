<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Registration · Ignite</title>
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
                <h1>Join our<br>network.</h1>
                <p>Register your company to post opportunities and recruit the best upcoming graduates.</p>
                <a href="login.jsp" class="auth-back-link"><i class="ri-arrow-left-line"></i> Back to login</a>
            </div>
        </div>

        <div class="auth-right">
            <h2>Register Company</h2>
            <%
                String errorMsg = (String) session.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
                <div class="alert alert-error"><i class="ri-error-warning-fill"></i> <%= errorMsg %></div>
            <%     session.removeAttribute("errorMsg"); } %>

            <form action="/placement-portal/company-register" method="post">
                <div class="input-group">
                    <label class="input-label">Company Name</label>
                    <div class="input-field company">
                        <i class="ri-building-line input-icon"></i>
                        <input type="text" name="name" placeholder="Acme Corp" required>
                    </div>
                </div>
                <div class="input-group">
                    <label class="input-label">Recruitment Email</label>
                    <div class="input-field company">
                        <i class="ri-mail-line input-icon"></i>
                        <input type="email" name="email" placeholder="hr@acme.com" required>
                    </div>
                </div>
                <div class="input-group">
                    <label class="input-label">Password</label>
                    <div class="input-field company">
                        <i class="ri-lock-line input-icon"></i>
                        <input type="password" name="password" placeholder="Create a strong password" required>
                    </div>
                </div>
                <div class="input-group">
                    <label class="input-label">Company Description</label>
                    <div class="input-field company" style="align-items: flex-start;">
                        <i class="ri-file-text-line input-icon" style="margin-top: 0.15rem;"></i>
                        <textarea name="description" placeholder="A brief description of what your company does..." required></textarea>
                    </div>
                </div>
                <div class="input-group">
                    <label class="input-label">Logo URL</label>
                    <div class="input-field company">
                        <i class="ri-image-line input-icon"></i>
                        <input type="url" name="logoUrl" placeholder="https://example.com/logo.png">
                    </div>
                </div>

                <button type="submit" class="btn-primary company">Submit for Approval <i class="ri-send-plane-line"></i></button>
            </form>

            <div class="auth-footer">
                Already registered? <a href="login.jsp" style="color: var(--company);">Sign in</a>
            </div>
        </div>
    </div>

</body>
</html>
