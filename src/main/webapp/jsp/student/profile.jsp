<%@ page import="com.placement.model.Student" %>
<%
    Student s = (Student) session.getAttribute("student");
    if (s == null) {
        response.sendRedirect("login.jsp");
        return;
    }

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile · Ignite</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body class="dash-body">

<div class="profile-wrapper">
    <a href="dashboard.jsp" class="back-link"><i class="ri-arrow-left-line"></i> Back to Dashboard</a>

    <% if ("updated".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success" style="margin: 0;"><i class="ri-checkbox-circle-fill"></i> Profile updated successfully!</div>
    <% } %>

    <div class="profile-card">
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
                <div style="margin-top: 0.65rem; display: flex; gap: 0.6rem; flex-wrap: wrap;">
                    <span class="profile-tag">CGPA: <%= s.getCgpa() %></span>
                    <% if (s.getResumePath() != null) { %>
                        <span class="profile-tag success"><i class="ri-check-line"></i> Resume Uploaded</span>
                    <% } else { %>
                        <span class="profile-tag" style="background: var(--bg-soft); color: var(--text-muted);">No Resume</span>
                    <% } %>
                </div>
            </div>
        </div>

        <h3 class="section-title"><i class="ri-user-settings-line"></i> Personal Information</h3>

        <form action="/placement-portal/update-profile-details" method="post">
            <div class="row">
                <div class="input-group">
                    <label class="input-label">Enrollment / Roll No.</label>
                    <div class="input-field">
                        <i class="ri-hashtag input-icon"></i>
                        <input type="text" name="enrollmentNo" placeholder="CS202201" value="<%= enrollmentNo %>">
                    </div>
                </div>

                <div class="input-group">
                    <label class="input-label">Contact Number</label>
                    <div class="input-field">
                        <i class="ri-phone-line input-icon"></i>
                        <input type="text" name="contactNumber" placeholder="+1 234 567 890" value="<%= contactNumber %>">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="input-group">
                    <label class="input-label">LinkedIn URL</label>
                    <div class="input-field">
                        <i class="ri-link input-icon"></i>
                        <input type="url" name="linkedinUrl" placeholder="https://linkedin.com/in/username" value="<%= linkedinUrl %>">
                    </div>
                </div>

                <div class="input-group">
                    <label class="input-label">Branch / Degree</label>
                    <div class="input-field">
                        <i class="ri-book-read-line input-icon"></i>
                        <input type="text" name="branch" placeholder="Computer Science" value="<%= branch %>">
                    </div>
                </div>
            </div>

            <div class="input-group">
                <label class="input-label">Technical Skills</label>
                <% if (!skills.isEmpty()) {
                    String[] skillArray = skills.split(",");
                %>
                <div class="skill-tags">
                    <% for (String skill : skillArray) {
                        if (!skill.trim().isEmpty()) {
                    %>
                    <span class="skill-tag"><%= skill.trim() %></span>
                    <%  } } %>
                </div>
                <% } %>
                <div class="input-field">
                    <i class="ri-code-s-slash-line input-icon"></i>
                    <input type="text" name="skills" placeholder="Java, Python, React, SQL..." value="<%= skills %>">
                </div>
                <small style="color: var(--text-muted); font-size: 0.78rem; margin-top: 0.3rem; display: block;">Separate skills with commas.</small>
            </div>

            <div style="display: flex; justify-content: flex-end; margin-top: 1rem;">
                <button type="submit" class="btn-primary" style="width: auto;"><i class="ri-save-line"></i> Save Profile Details</button>
            </div>
        </form>
    </div>

    <div class="profile-card">
        <h3 class="section-title"><i class="ri-folder-upload-line"></i> Documents & Media</h3>
        <p style="color: var(--text-muted); margin-bottom: 1.25rem; font-size: 0.9rem;">Keep your resume and profile picture updated to stand out to recruiters.</p>

        <form action="/placement-portal/upload-profile" method="post" enctype="multipart/form-data">
            <div class="row">
                <div class="input-group">
                    <label class="input-label"><i class="ri-file-pdf-line"></i> Update Resume (PDF)</label>
                    <input type="file" name="resume" class="file-input" accept=".pdf">
                </div>

                <div class="input-group">
                    <label class="input-label"><i class="ri-image-add-line"></i> Update Profile Picture</label>
                    <input type="file" name="profilePic" class="file-input" accept="image/*">
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end; margin-top: 0.5rem;">
                <button type="submit" class="btn-primary" style="width: auto; background: linear-gradient(135deg, #1f2937 0%, #111827 100%); box-shadow: 0 4px 10px -2px rgba(15,23,42,0.3);"><i class="ri-upload-cloud-2-line"></i> Upload Files</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
