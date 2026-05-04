<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Registration | Ignite Placement</title>
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
        .auth-container { height: 600px; }
        .auth-right { overflow-y: auto; }
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
                <h1 style="font-size: 3rem; font-weight: 700; margin-bottom: 1rem; line-height: 1.2;">Join Our<br>Network.</h1>
                <p style="font-size: 1rem; opacity: 0.8; line-height: 1.6; margin-bottom: 2rem;">Register your company to post opportunities and recruit the best upcoming graduates.</p>
            </div>
        </div>
        <div class="auth-right">
            <h2>Register Company</h2>

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

        <form action="/placement-portal/company-register" method="post">
            <div class="input-group">
                <label class="input-label">Company Name</label>
                <div class="input-field">
                    <i class="ri-building-line input-icon"></i>
                    <input type="text" name="name" placeholder="Acme Corp" required>
                </div>
            </div>
            <div class="input-group">
                <label class="input-label">Recruitment Email</label>
                <div class="input-field">
                    <i class="ri-mail-line input-icon"></i>
                    <input type="email" name="email" placeholder="hr@acme.com" required>
                </div>
            </div>
            <div class="input-group">
                <label class="input-label">Password</label>
                <div class="input-field">
                    <i class="ri-lock-line input-icon"></i>
                    <input type="password" name="password" placeholder="Create a strong password" required>
                </div>
            </div>
            <div class="input-group">
                <label class="input-label">Company Description</label>
                <div class="input-field" style="align-items: flex-start;">
                    <i class="ri-file-text-line input-icon" style="margin-top: 0.2rem;"></i>
                    <textarea name="description" placeholder="A brief description of what your company does..." required style="border:none;background:transparent;outline:none;width:100%;font-size:1rem;color:var(--text-dark);resize:vertical;min-height:80px;"></textarea>
                </div>
            </div>
            <div class="input-group">
                <label class="input-label">Logo URL</label>
                <div class="input-field">
                    <i class="ri-image-line input-icon"></i>
                    <input type="url" name="logoUrl" placeholder="https://example.com/logo.png">
                </div>
            </div>
            
            <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%);">Submit for Admin Approval</button>
        </form>

        <div class="auth-footer">
            Already registered? <a href="login.jsp" style="color: #8b5cf6;">Sign in</a>
        </div>
    </div>
</div>
</body>
</html>
