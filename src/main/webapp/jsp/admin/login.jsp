<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | Ignite</title>
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
                <h1>System<br>Administration</h1>
                <p>Log in to the administrative portal to manage students, approve applications, and post jobs.</p>
                <div style="margin-top: 2rem;">
                    <a href="../../index.jsp" style="color: white; text-decoration: none; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem; width: max-content; padding: 0.5rem 1rem; border-radius: 8px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); transition: all 0.2s;">
                        <i class="ri-arrow-left-line"></i> Back to Home
                    </a>
                </div>
            </div>
        </div>
        <div class="auth-right">
            <h2>Admin Sign In</h2>
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div style="background-color: #fee2e2; border-left: 4px solid #ef4444; color: #b91c1c; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; display: flex; align-items: center; gap: 0.5rem; font-weight: 500; font-size: 0.9rem;">
                    <i class="ri-error-warning-fill" style="font-size: 1.25rem;"></i> Invalid credentials. Please try again.
                </div>
            <% } %>
            <% 
               String succMsg = (String) session.getAttribute("succMsg");
               if (succMsg != null) { 
            %>
                <div style="background-color: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; display: flex; align-items: center; gap: 0.5rem; font-weight: 500; font-size: 0.9rem;">
                    <i class="ri-checkbox-circle-fill" style="font-size: 1.25rem;"></i> <%= succMsg %>
                </div>
            <% 
                   session.removeAttribute("succMsg");
               } 
            %>
            <form action="/placement-portal/admin-login" method="post">
                <div class="input-group">
                    <label class="input-label">Username</label>
                    <div class="input-field">
                        <i class="ri-user-settings-line input-icon"></i>
                        <input type="text" name="username" placeholder="admin" required>
                    </div>
                </div>
                
                <div class="input-group">
                    <label class="input-label">Password</label>
                    <div class="input-field">
                        <i class="ri-lock-line input-icon"></i>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                </div>
                
                <div class="auth-options">
                    <label class="checkbox-group">
                        <input type="checkbox" name="remember">
                        Remember me
                    </label>
                </div>
                
                <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #0f172a 0%, #334155 100%); box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.3);">Login to Dashboard</button>
            </form>
            
            <div class="auth-footer">
                New Admin? <a href="register.jsp" style="color: #0f172a;">Register</a>
            </div>
        </div>
    </div>

</body>
</html>