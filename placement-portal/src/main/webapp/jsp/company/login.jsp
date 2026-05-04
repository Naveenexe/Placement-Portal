<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Login | Ignite Placement</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .auth-left-company {
            flex: 1;
            background: linear-gradient(135deg, #4c1d95 0%, #8b5cf6 100%);
            color: white;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .auth-left-company::before {
            content: '';
            position: absolute;
            top: -50%; left: -50%; width: 200%; height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%);
            z-index: 1;
        }
        .auth-left-company .auth-left-content { position: relative; z-index: 2; }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-left-company">
            <div class="auth-left-content">
                <div class="brand-logo">
                    <div class="brand-logo-circle" style="color: #4c1d95;">
                        <i class="ri-building-4-fill"></i>
                    </div>
                    Ignite Recruiter
                </div>
                <h1 style="font-size: 3rem; font-weight: 700; margin-bottom: 1rem; line-height: 1.2;">Hire Top<br>Talent Today.</h1>
                <p style="font-size: 1rem; opacity: 0.8; line-height: 1.6; margin-bottom: 2rem;">Access a diverse pool of brilliant students ready to make an impact at your company.</p>
                <div style="margin-top: 2rem;">
                    <a href="../../index.jsp" style="color: white; text-decoration: none; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem; width: max-content; padding: 0.5rem 1rem; border-radius: 8px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); transition: all 0.2s;">
                        <i class="ri-arrow-left-line"></i> Back to Home
                    </a>
                </div>
            </div>
        </div>
        <div class="auth-right">
            <h2>Recruiter Sign In</h2>

        <% 
            String errorMsg = (String) session.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <div style="background-color: #fee2e2; border-left: 4px solid #ef4444; color: #b91c1c; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; display: flex; align-items: center; gap: 0.5rem; font-weight: 500; font-size: 0.9rem;">
                <i class="ri-error-warning-fill" style="font-size: 1.25rem;"></i> <%= errorMsg %>
            </div>
        <% 
                session.removeAttribute("errorMsg");
            } 
            String succMsg = (String) session.getAttribute("succMsg");
            if (succMsg != null) {
        %>
            <div style="background-color: #d1fae5; border-left: 4px solid #10b981; color: #064e3b; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; display: flex; align-items: center; gap: 0.5rem; font-weight: 500; font-size: 0.9rem;">
                <i class="ri-checkbox-circle-fill" style="font-size: 1.25rem;"></i> <%= succMsg %>
            </div>
        <% 
                session.removeAttribute("succMsg");
            } 
        %>

        <form action="/placement-portal/company-login" method="post">
            <div class="input-group">
                <label class="input-label">Company Email</label>
                <div class="input-field">
                    <i class="ri-mail-line input-icon"></i>
                    <input type="email" name="email" placeholder="hr@company.com" required>
                </div>
            </div>
            <div class="input-group">
                <label class="input-label">Password</label>
                <div class="input-field">
                    <i class="ri-lock-line input-icon"></i>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>
            </div>
            
            <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%);">Sign In</button>
        </form>

        <div class="auth-footer">
            New company? <a href="register.jsp" style="color: #8b5cf6;">Register here</a>
        </div>
    </div>
</div>
</body>
</html>
