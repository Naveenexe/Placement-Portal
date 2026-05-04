<%@ page import="com.placement.model.Student" %>
<%
    Student s = (Student) session.getAttribute("student");
    if (s == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Safely get string attributes without printing "null"
    String branch = s.getBranch() != null ? s.getBranch() : "";
    String skills = s.getSkills() != null ? s.getSkills() : "";
    String contactNumber = s.getContactNumber() != null ? s.getContactNumber() : "";
    String enrollmentNo = s.getEnrollmentNo() != null ? s.getEnrollmentNo() : "";
    String linkedinUrl = s.getLinkedinUrl() != null ? s.getLinkedinUrl() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | Ignite</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #3b82f6; --text-main: #1f2937; --text-muted: #6b7280; --bg: #f8fafc; --success: #10b981;}
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--text-main); display: flex; justify-content: center; align-items: flex-start; min-height: 100vh; padding: 2rem; }
        .dashboard-wrapper { width: 100%; max-width: 900px; display: grid; gap: 2rem; grid-template-columns: 1fr; margin-top: 2rem;}
        
        .card { background: white; border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05); padding: 2.5rem; position: relative; }
        
        .back-link { position: absolute; top: -2.5rem; left: 0; color: var(--text-muted); text-decoration: none; display: flex; align-items: center; gap: 0.4rem; font-weight: 500; transition: color 0.2s; }
        .back-link:hover { color: var(--primary); }
        
        .profile-header { display: flex; align-items: center; gap: 2rem; margin-bottom: 2rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 2rem; }
        .profile-pic-container { width: 100px; height: 100px; border-radius: 50%; border: 4px solid #eff6ff; overflow: hidden; background: #e2e8f0; display: flex; justify-content: center; align-items: center; flex-shrink: 0; }
        .profile-pic-container img { width: 100%; height: 100%; object-fit: cover; }
        .profile-header h2 { font-size: 1.75rem; font-weight: 700; color: var(--text-main); margin-bottom: 0.25rem; }
        .profile-header p { color: var(--text-muted); font-size: 1rem; display: flex; align-items: center; gap: 0.5rem;}
        
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        
        .section-title { font-size: 1.25rem; font-weight: 700; color: var(--text-main); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;}
        
        .input-group { margin-bottom: 1.5rem; }
        .input-label { display: block; font-weight: 600; font-size: 0.875rem; margin-bottom: 0.5rem; color: var(--text-main); }
        .input-field { width: 100%; padding: 0.75rem 1rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 1rem; font-family: inherit; transition: all 0.2s; background: #f8fafc; }
        .input-field:focus { border-color: var(--primary); background: white; outline: none; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        
        .file-input { width: 100%; padding: 0.75rem; border: 1px dashed #cbd5e1; border-radius: 8px; background: #f8fafc; cursor: pointer; }
        
        .btn-primary { padding: 0.875rem 1.5rem; background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); color: white; border: none; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.2s; display: inline-flex; justify-content: center; align-items: center; gap: 0.5rem; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3); }
        
        .alert-success { background: #d1fae5; border-left: 4px solid #10b981; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; color: #065f46; font-weight: 500; display: flex; align-items: center; gap: 0.5rem;}
        
        @media (max-width: 768px) {
            .grid-2 { grid-template-columns: 1fr; }
            .profile-header { flex-direction: column; text-align: center; }
        }
    </style>
</head>
<body>

<div class="dashboard-wrapper">
    <div style="position: relative;">
        <a href="dashboard.jsp" class="back-link"><i class="ri-arrow-left-line"></i> Back to Dashboard</a>
    </div>

    <% if ("updated".equals(request.getParameter("msg"))) { %>
        <div class="alert-success">
            <i class="ri-checkbox-circle-fill"></i> Profile updated successfully!
        </div>
    <% } %>

    <div class="card">
        <div class="profile-header">
            <div class="profile-pic-container">
                <% if (s.getProfilePic() != null) { %>
                    <img src="/placement-portal/<%= s.getProfilePic() %>" alt="Profile">
                <% } else { %>
                    <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(s.getName(), "UTF-8") %>&background=e2e8f0&color=64748b" alt="Avatar">
                <% } %>
            </div>
            <div>
                <h2><%= s.getName() %></h2>
                <p><i class="ri-mail-line"></i> <%= s.getEmail() %></p>
                <div style="margin-top: 0.5rem; display: flex; gap: 1rem;">
                    <span style="background: #eff6ff; color: var(--primary); padding: 0.2rem 0.8rem; border-radius: 99px; font-size: 0.85rem; font-weight: 600;">CGPA: <%= s.getCgpa() %></span>
                    <% if (s.getResumePath() != null) { %>
                        <span style="background: #d1fae5; color: var(--success); padding: 0.2rem 0.8rem; border-radius: 99px; font-size: 0.85rem; font-weight: 600;"><i class="ri-check-line"></i> Resume Uploaded</span>
                    <% } %>
                </div>
            </div>
        </div>

        <h3 class="section-title"><i class="ri-user-settings-line"></i> Personal Information</h3>
        
        <form action="/placement-portal/update-profile-details" method="post">
            <div class="grid-2">
                <div class="input-group">
                    <label class="input-label">Enrollment / Roll No.</label>
                    <input type="text" name="enrollmentNo" class="input-field" placeholder="Ex: CS202201" value="<%= enrollmentNo %>">
                </div>
                
                <div class="input-group">
                    <label class="input-label">Contact Number</label>
                    <input type="text" name="contactNumber" class="input-field" placeholder="Ex: +1 234 567 890" value="<%= contactNumber %>">
                </div>
                
                <div class="input-group">
                    <label class="input-label">LinkedIn URL</label>
                    <input type="url" name="linkedinUrl" class="input-field" placeholder="https://linkedin.com/in/username" value="<%= linkedinUrl %>">
                </div>
                
                <div class="input-group">
                    <label class="input-label">Branch/Degree</label>
                    <input type="text" name="branch" class="input-field" placeholder="Computer Science" value="<%= branch %>">
                </div>
            </div>
            
            <div class="input-group">
                <label class="input-label">Technical Skills</label>
                
                <% if (!skills.isEmpty()) { 
                    String[] skillArray = skills.split(",");
                %>
                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap; margin-bottom: 0.75rem;">
                    <% for (String skill : skillArray) { 
                        if (!skill.trim().isEmpty()) {
                    %>
                    <span style="background: rgba(59, 130, 246, 0.1); color: var(--primary); padding: 0.3rem 0.8rem; border-radius: 999px; font-size: 0.85rem; font-weight: 600; border: 1px solid rgba(59, 130, 246, 0.2);">
                        <%= skill.trim() %>
                    </span>
                    <%  } 
                       } %>
                </div>
                <% } %>
                
                <input type="text" name="skills" class="input-field" placeholder="Java, Python, React, SQL..." value="<%= skills %>">
                <small style="color: var(--text-muted); font-size: 0.8rem; margin-top: 0.25rem; display: block;">Separate skills with commas.</small>
            </div>
            
            <div style="display: flex; justify-content: flex-end; margin-top: 1rem;">
                <button type="submit" class="btn-primary"><i class="ri-save-line"></i> Save Profile Details</button>
            </div>
        </form>
    </div>

    <div class="card">
        <h3 class="section-title"><i class="ri-folder-upload-line"></i> Documents & Media</h3>
        <p style="color: var(--text-muted); margin-bottom: 1.5rem; font-size: 0.95rem;">Keep your resume and profile picture updated to stand out to recruiters.</p>
        
        <form action="/placement-portal/upload-profile" method="post" enctype="multipart/form-data">
            <div class="grid-2">
                <div class="input-group">
                    <label class="input-label"><i class="ri-file-pdf-line"></i> Update Resume (PDF)</label>
                    <input type="file" name="resume" class="file-input" accept=".pdf">
                </div>
                
                <div class="input-group">
                    <label class="input-label"><i class="ri-image-add-line"></i> Update Profile Picture</label>
                    <input type="file" name="profilePic" class="file-input" accept="image/*">
                </div>
            </div>
            
            <div style="display: flex; justify-content: flex-end; margin-top: 1rem;">
                <button type="submit" class="btn-primary" style="background: #1f2937;"><i class="ri-upload-cloud-2-line"></i> Upload Files</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>