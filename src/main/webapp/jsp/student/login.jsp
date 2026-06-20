<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
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
                <h1>Welcome<br>back!</h1>
                <p>Sign in to access your dashboard, browse placement drives, and track your application status.</p>
                <a href="../../index.jsp" class="auth-back-link"><i class="ri-arrow-left-line"></i> Back to home</a>
            </div>
        </div>

        <div class="auth-right">
            <h2>Student Sign In</h2>

            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error"><i class="ri-error-warning-fill"></i> Invalid email or password. Please try again.</div>
            <% } %>
            <% if ("registered".equals(request.getParameter("success"))) {
                   String succMsg = (String) session.getAttribute("succMsg");
                   if (succMsg != null) {
                       session.removeAttribute("succMsg");
            %>
                <div class="alert alert-success"><i class="ri-checkbox-circle-fill"></i> <%= succMsg %></div>
            <%     }
               } %>

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
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="btn-primary">Sign In <i class="ri-arrow-right-line"></i></button>
            </form>

            <div class="auth-footer">
                Not a member yet? <a href="register.jsp">Create an account</a>
            </div>
        </div>
    </div>

</body>
</html>
