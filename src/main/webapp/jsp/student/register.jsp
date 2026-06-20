<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration · Ignite</title>
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
                <h1>Join us<br>today!</h1>
                <p>Create your student account to discover opportunities, build your profile, and land your ideal job.</p>
                <a href="login.jsp" class="auth-back-link"><i class="ri-arrow-left-line"></i> Back to login</a>
            </div>
        </div>

        <div class="auth-right">
            <h2>Create Student Account</h2>
            <%
               String errorMsg = (String) session.getAttribute("errorMsg");
               if (errorMsg != null) {
            %>
                <div class="alert alert-error"><i class="ri-error-warning-fill"></i> <%= errorMsg %></div>
            <%     session.removeAttribute("errorMsg"); } %>

            <form action="/placement-portal/register" method="post">
                <div class="input-group">
                    <label class="input-label">Full Name</label>
                    <div class="input-field">
                        <i class="ri-user-line input-icon"></i>
                        <input type="text" name="name" placeholder="John Doe" required>
                    </div>
                </div>

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

                <div class="row">
                    <div class="input-group">
                        <label class="input-label">CGPA</label>
                        <div class="input-field">
                            <i class="ri-bar-chart-line input-icon"></i>
                            <input type="number" step="0.01" name="cgpa" placeholder="8.5" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Branch</label>
                        <div class="input-field">
                            <i class="ri-book-read-line input-icon"></i>
                            <input type="text" name="branch" placeholder="Computer Science">
                        </div>
                    </div>
                </div>

                <div class="input-group">
                    <label class="input-label">Skills</label>
                    <div class="input-field">
                        <i class="ri-code-s-slash-line input-icon"></i>
                        <input type="text" name="skills" placeholder="Java, SQL, React...">
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="margin-top: 0.5rem;">Create Account <i class="ri-check-line"></i></button>
            </form>

            <div class="auth-footer">
                Already have an account? <a href="login.jsp">Sign in</a>
            </div>
        </div>
    </div>

</body>
</html>
