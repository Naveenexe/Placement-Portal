<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login | Ignite</title>
    <!-- Modern Icons -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
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
                <h1>Welcome<br>Back!</h1>
                <p>Welcome back! Please enter your details to login as a Student and explore new opportunities.</p>
                <div style="margin-top: 2rem;">
                    <a href="../../index.jsp" style="color: white; text-decoration: none; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem; width: max-content; padding: 0.5rem 1rem; border-radius: 8px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); transition: all 0.2s;">
                        <i class="ri-arrow-left-line"></i> Back to Home
                    </a>
                </div>
            </div>
        </div>
        <div class="auth-right">
            <h2>Student Sign In</h2>
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div style="background-color: #fee2e2; border-left: 4px solid #ef4444; color: #b91c1c; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; display: flex; align-items: center; gap: 0.5rem; font-weight: 500; font-size: 0.9rem;">
                    <i class="ri-error-warning-fill" style="font-size: 1.25rem;"></i> Invalid email or password. Please try again.
                </div>
            <% } %>
            <form action="/placement-portal/login" method="post">
                <div class="input-group">
                    <label class="input-label">Email address</label>
                    <div class="input-field">
                        <i class="ri-mail-line input-icon"></i>
                        <input type="email" name="email" placeholder="name@mail.com" required>
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
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>
                
                <button type="submit" class="btn-primary">Login</button>
            </form>
            
            <div class="auth-footer">
                Not a member yet? <a href="register.jsp">Sign up</a>
            </div>
        </div>
    </div>

</body>
</html>