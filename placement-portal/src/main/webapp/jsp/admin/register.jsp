<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration | Ignite</title>
    <!-- Modern Icons -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>

    <div class="auth-container">
        <div class="auth-left" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);">
            <div class="auth-left-content">
                <div class="brand-logo">
                    <div class="brand-logo-circle" style="color: #0f172a;">
                        <i class="ri-shield-check-fill"></i>
                    </div>
                    Ignite Admin
                </div>
                <h1>System<br>Onboarding</h1>
                <p>Register as an administrator to gain access to system management, user control, and hiring pipelines.</p>
                <div style="margin-top: 2rem;">
                    <a href="login.jsp" style="color: white; text-decoration: none; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem; width: max-content; padding: 0.5rem 1rem; border-radius: 8px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); transition: all 0.2s;">
                        <i class="ri-arrow-left-line"></i> Back to Login
                    </a>
                </div>
            </div>
        </div>
        <div class="auth-right">
            <h2>Admin Registration</h2>
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
            %>
            <form action="/placement-portal/admin-register" method="post">
                <div class="input-group">
                    <label class="input-label">Username</label>
                    <div class="input-field">
                        <i class="ri-user-settings-line input-icon"></i>
                        <input type="text" name="username" placeholder="Choose a username" required>
                    </div>
                </div>
                
                <div class="input-group">
                    <label class="input-label">Password</label>
                    <div class="input-field">
                        <i class="ri-lock-line input-icon"></i>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #0f172a 0%, #334155 100%); box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.3); margin-top: 1rem;">Register Account</button>
            </form>
            
            <div class="auth-footer">
                Already have an account? <a href="login.jsp" style="color: #0f172a;">Sign in</a>
            </div>
        </div>
    </div>

</body>
</html>