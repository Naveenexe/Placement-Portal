<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Portal | Ignite</title>
    <!-- Modern Icons -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <div class="auth-container">
        <div class="auth-left">
            <div class="auth-left-content">
                <div class="brand-logo">
                    <div class="brand-logo-circle">
                        <i class="ri-graduation-cap-fill"></i>
                    </div>
                    Ignite
                </div>
                <h1>Welcome to<br>Placement Portal!</h1>
                <p>Connecting talented students with top companies. Step into a world of opportunities and kickstart your dream career today.</p>
                
                <div class="action-buttons">
                    <a href="jsp/student/login.jsp" class="large-btn large-btn-primary">
                        <i class="ri-user-smile-line"></i> Login as Student
                    </a>
                    <a href="jsp/company/login.jsp" class="large-btn large-btn-primary" style="background: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.2);">
                        <i class="ri-building-4-line"></i> Login as Recruiter
                    </a>
                    <a href="jsp/admin/login.jsp" class="large-btn large-btn-primary" style="background: transparent; border-color: rgba(255,255,255,0.4);">
                        <i class="ri-shield-user-line"></i> Login as Administrator
                    </a>
                </div>
            </div>
        </div>
        <div class="auth-right" style="position: relative; text-align: center; background: #f8fafc; align-items: center; overflow: hidden;">
            <div style="position: absolute; width: 300px; height: 300px; background: rgba(59, 130, 246, 0.2); filter: blur(60px); border-radius: 50%; top: 20%; left: 50%; transform: translateX(-50%);"></div>
            <img src="https://illustrations.popsy.co/blue/freelancer.svg" alt="Welcome Illustration" style="max-width: 80%; margin: 0 auto; display: block; position: relative; z-index: 1;">
            <h3 style="margin-top: 2rem; color: var(--text-dark); font-size: 1.5rem; font-weight: 600;">Launch your career</h3>
            <p style="color: var(--text-muted); margin-top: 0.5rem; max-width: 80%; margin-left: auto; margin-right: auto; line-height: 1.5;">Join our platform to discover exclusive job opportunities tailored just for you.</p>
        </div>
    </div>

</body>
</html>