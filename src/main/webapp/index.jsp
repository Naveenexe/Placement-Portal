<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ignite · Placement Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-body">

    <div class="auth-container">
        <div class="auth-left student">
            <div class="auth-left-content">
                <div class="brand-logo">
                    <div class="brand-logo-circle" style="color: #1e3a8a;">
                        <i class="ri-graduation-cap-fill"></i>
                    </div>
                    Ignite
                </div>
                <h1>Launch your<br>career today.</h1>
                <p>Connecting talented students with top recruiters. Discover exclusive placement opportunities, track your applications, and land your dream job.</p>

                <div class="action-buttons">
                    <a href="jsp/student/login.jsp" class="large-btn large-btn-primary">
                        <i class="ri-user-smile-line"></i> Student Portal
                    </a>
                    <a href="jsp/company/login.jsp" class="large-btn large-btn-secondary">
                        <i class="ri-building-4-line"></i> Recruiter Portal
                    </a>
                    <a href="jsp/admin/login.jsp" class="large-btn large-btn-ghost">
                        <i class="ri-shield-user-line"></i> Administrator
                    </a>
                </div>
            </div>
        </div>

        <div class="auth-right" style="align-items: center; justify-content: center; text-align: center; background: #f8fafc;">
            <div style="position: relative; width: 100%; max-width: 360px;">
                <div style="position: absolute; width: 260px; height: 260px; background: rgba(37, 99, 235, 0.15); filter: blur(70px); border-radius: 50%; top: 10%; left: 50%; transform: translateX(-50%); z-index: 0;"></div>
                <img src="https://illustrations.popsy.co/blue/freelancer.svg" alt="Career opportunities" style="width: 100%; position: relative; z-index: 1;">
            </div>
            <h3 style="margin-top: 1.5rem; color: var(--text); font-size: 1.4rem; font-weight: 700; letter-spacing: -0.02em; position: relative; z-index: 1;">Your future starts here</h3>
            <p style="color: var(--text-muted); margin-top: 0.5rem; max-width: 80%; line-height: 1.6; font-size: 0.9rem; position: relative; z-index: 1;">Join our platform to discover exclusive job opportunities tailored just for you.</p>
        </div>
    </div>

</body>
</html>
