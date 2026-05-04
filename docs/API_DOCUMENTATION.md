# 📡 API Documentation

Complete reference for all HTTP endpoints and servlet mappings in the Ignite Placement Portal.

## Table of Contents
- [Authentication Endpoints](#authentication-endpoints)
- [Student Endpoints](#student-endpoints)
- [Admin Endpoints](#admin-endpoints)
- [Job Endpoints](#job-endpoints)
- [Application Endpoints](#application-endpoints)
- [File Upload Endpoints](#file-upload-endpoints)
- [Error Handling](#error-handling)
- [Status Codes](#status-codes)

---

## Authentication Endpoints

### 1. Student Login
**Endpoint:** `POST /login`  
**Description:** Authenticate a student with email and password  
**Authentication:** None

**Request:**
```
POST /login HTTP/1.1
Content-Type: application/x-www-form-urlencoded

email=student@college.com&password=securePassword123
```

**Request Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| email | String | Yes | Student's email address |
| password | String | Yes | Student's password (plaintext, hashed on server) |

**Response (Success - 302 Redirect):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/dashboard.jsp
Set-Cookie: JSESSIONID=ABC123DEF456...
```

**Response (Failure - 302 Redirect):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/login.jsp?error=invalid
```

**Session Storage:**
```java
session.setAttribute("student", studentObject);
```

---

### 2. Admin Login
**Endpoint:** `POST /admin-login`  
**Description:** Authenticate an admin with email and password  
**Authentication:** None

**Request:**
```
POST /admin-login HTTP/1.1
Content-Type: application/x-www-form-urlencoded

email=admin@college.com&password=adminPassword123
```

**Response (Success):**
- Redirects to `/jsp/admin/dashboard.jsp`
- Session attribute `admin` set with Admin object

**Response (Failure):**
- Redirects to `/jsp/admin/login.jsp?error=invalid`

---

### 3. Student Registration
**Endpoint:** `POST /register`  
**Description:** Create a new student account  
**Authentication:** None

**Request:**
```
POST /register HTTP/1.1
Content-Type: application/x-www-form-urlencoded

name=John Doe&email=john@college.com&password=securePass123&
cgpa=8.5&branch=Computer Science&enrollmentNo=2021CS1234
```

**Request Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| name | String | Yes | Full name (2-100 chars) |
| email | String | Yes | Valid email (unique) |
| password | String | Yes | Password (min 6 chars) |
| cgpa | Double | Yes | Current CGPA (0-10) |
| branch | String | Yes | Branch of study |
| enrollmentNo | String | Yes | Unique enrollment number |

**Response (Success):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/login.jsp?success=registered
```

**Response (Failure - Email Already Exists):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/register.jsp?error=email_exists
```

---

### 4. Admin Registration
**Endpoint:** `POST /admin-register`  
**Description:** Create a new admin account  
**Authentication:** Required (Admin)

**Request:**
```
POST /admin-register HTTP/1.1
Content-Type: application/x-www-form-urlencoded

username=admin_new&password=adminPass123
```

---

### 5. Company Registration
**Endpoint:** `POST /company-register`  
**Description:** Create a new recruiter/company account (Status defaults to 'Pending')  
**Authentication:** None

**Request:**
```
POST /company-register HTTP/1.1
Content-Type: application/x-www-form-urlencoded

name=Tech Solutions&email=recruiter@tech.com&password=securePass123&
description=Software development firm&logoUrl=https://link.to/logo.png
```

---

### 6. Company Login
**Endpoint:** `POST /company-login`  
**Description:** Authenticate a recruiter with email and password  
**Authentication:** None

**Request:**
```
POST /company-login HTTP/1.1
Content-Type: application/x-www-form-urlencoded

email=recruiter@tech.com&password=securePass123
```

**Response (Success):** Redirects to `/jsp/company/dashboard.jsp`

---

### 7. Logout
**Endpoint:** `GET /logout`  
**Description:** Destroy user session and logout  
**Authentication:** Required

**Request:**
```
GET /logout HTTP/1.1
Cookie: JSESSIONID=ABC123DEF456...
```

**Response:**
```
HTTP/1.1 302 Found
Location: /placement-portal/index.jsp
```

**Session Invalidation:**
```java
session.invalidate();
```

---

## Student Endpoints

### 1. Get Student Dashboard
**Endpoint:** `GET /jsp/student/dashboard.jsp`  
**Description:** View available jobs and current applications  
**Authentication:** Required (Student)

**Request:**
```
GET /jsp/student/dashboard.jsp HTTP/1.1
Cookie: JSESSIONID=ABC123DEF456...
```

**Response (HTML Page):**
- Displays all jobs with CGPA >= student's CGPA
- Shows application status for applied jobs
- Includes apply buttons for eligible jobs

---

### 2. Update Student Profile
**Endpoint:** `POST /updateProfile`  
**Description:** Update student profile details  
**Authentication:** Required (Student)

**Request:**
```
POST /updateProfile HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Cookie: JSESSIONID=ABC123DEF456...

skills=Java,Python,MySQL&contactNumber=9876543210&
linkedinUrl=https://linkedin.com/in/johndoe
```

**Request Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| skills | String | Yes | Comma-separated skills |
| contactNumber | String | Yes | 10-digit phone number |
| linkedinUrl | String | No | LinkedIn profile URL |

**Response (Success):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/profile.jsp?success=updated
```

---

### 3. View Student Profile
**Endpoint:** `GET /jsp/student/profile.jsp`  
**Description:** View and edit personal profile  
**Authentication:** Required (Student)

**Response (HTML Page):**
- Displays student info: name, email, CGPA, skills, etc.
- Shows resume and profile picture
- Provides edit forms for updating information

---

### 4. View Top Students Leaderboard
**Endpoint:** `GET /jsp/student/top-students.jsp`  
**Description:** View leaderboard of top performers  
**Authentication:** Not required

**Response (HTML Page):**
- Top 10 students by CGPA
- Shows name, branch, CGPA, and number of placements

---

## Admin Endpoints

### 1. Admin Dashboard
**Endpoint:** `GET /jsp/admin/dashboard.jsp`  
**Description:** Admin overview and quick stats  
**Authentication:** Required (Admin)

**Response (HTML Page):**
- Total registered students
- Total active job postings  
- Total applications
- Recent activities

---

### 2. Add New Job
**Endpoint:** `POST /add-job`  
**Description:** Create a new job posting  
**Authentication:** Required (Admin)

**Request:**
```
POST /add-job HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Cookie: JSESSIONID=XYZ789...

companyId=5&role=Software Engineer&cgpaEligibility=7.0&
deadline=2026-06-30&totalPositions=5&description=...
```

**Request Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| companyId | Int | Yes | Company ID |
| role | String | Yes | Job title/role |
| cgpaEligibility | Double | Yes | Minimum CGPA required |
| deadline | Date | Yes | Application deadline (YYYY-MM-DD) |
| totalPositions | Int | Yes | Number of positions (1-100) |
| description | String | No | Job description |

**Response (Success):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/admin/dashboard.jsp?success=job_added
```

---

### 3. View Job Applicants
**Endpoint:** `GET /jsp/admin/applicants.jsp`  
**Description:** View all applicants for a specific job  
**Authentication:** Required (Admin)

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| jobId | Int | Yes | Job ID to view applicants for |

**Request:**
```
GET /jsp/admin/applicants.jsp?jobId=12 HTTP/1.1
Cookie: JSESSIONID=XYZ789...
```

**Response (HTML Page):**
- List of all applicants for the job
- Student details, resume link, and action buttons
- Filter by status (Applied, Selected, Rejected)

---

### 4. Update Application Status
**Endpoint:** `POST /updateStatus`  
**Description:** Accept or reject a student application. Only allowed for 'Pending' applications.  
**Authentication:** Required (Admin or Recruiter)

**Request:**
```
POST /updateStatus HTTP/1.1
Content-Type: application/x-www-form-urlencoded

appId=45&status=Selected
```

**Logic:** Once status is updated to 'Selected' or 'Rejected', action buttons are disabled in the UI.

---

### 5. Update Company Status (Admin only)
**Endpoint:** `POST /update-company-status`  
**Description:** Approve or Reject a company registration  
**Authentication:** Required (Admin)

**Request:**
```
POST /update-company-status HTTP/1.1
Content-Type: application/x-www-form-urlencoded

companyId=5&status=Approved
```

---

## Recruiter Endpoints

### 1. Recruiter Dashboard
**Endpoint:** `GET /jsp/company/dashboard.jsp`  
**Description:** View jobs posted by the company and total applicants  
**Authentication:** Required (Company)

### 2. View Applicants (Recruiter)
**Endpoint:** `GET /view-applicants`  
**Description:** Review students who applied for a specific job  
**Authentication:** Required (Company)

**Query Params:** `jobId`

## Job Endpoints

### 1. Get All Jobs
**Endpoint:** `GET /api/jobs`  
**Description:** Retrieve all available jobs  
**Authentication:** Not required

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| companyId | Int | Filter by company (optional) |
| role | String | Filter by job title (optional) |
| page | Int | Pagination page (default: 1) |
| limit | Int | Results per page (default: 10) |

**Request:**
```
GET /api/jobs?companyId=5&page=1&limit=10 HTTP/1.1
```

**Response (JSON):**
```json
{
  "success": true,
  "data": [
    {
      "jobId": 12,
      "companyId": 5,
      "role": "Software Engineer",
      "cgpaEligibility": 7.0,
      "deadline": "2026-06-30",
      "totalPositions": 5,
      "postedDate": "2026-04-15",
      "description": "Senior software engineer role..."
    }
  ],
  "total": 25,
  "page": 1
}
```

---

### 2. Get Job Details
**Endpoint:** `GET /api/jobs/{jobId}`  
**Description:** Get detailed information about a specific job  
**Authentication:** Not required

**Request:**
```
GET /api/jobs/12 HTTP/1.1
```

**Response (JSON):**
```json
{
  "success": true,
  "data": {
    "jobId": 12,
    "companyId": 5,
    "companyName": "Tech Corp",
    "companyLogo": "/images/techcorp.png",
    "role": "Software Engineer",
    "cgpaEligibility": 7.0,
    "deadline": "2026-06-30",
    "totalPositions": 5,
    "totalApplications": 23,
    "selectedCount": 5,
    "rejectedCount": 10,
    "description": "We are looking for...",
    "postedDate": "2026-04-15"
  }
}
```

---

## Application Endpoints

### 1. Apply for Job
**Endpoint:** `POST /apply`  
**Description:** Submit an application for a job  
**Authentication:** Required (Student)

**Request:**
```
POST /apply HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Cookie: JSESSIONID=ABC123DEF456...

jobId=12
```

**Request Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| jobId | Int | Yes | Job ID to apply for |

**Response (Success):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/dashboard.jsp?success=applied
```

**Response (Failure - Already Applied):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/dashboard.jsp?error=already_applied
```

**Response (Failure - Not Eligible):**
```
HTTP/1.1 302 Found
Location: /placement-portal/jsp/student/dashboard.jsp?error=not_eligible
```

---

### 2. Get Student Applications
**Endpoint:** `GET /api/applications/my`  
**Description:** Get all applications submitted by current student  
**Authentication:** Required (Student)

**Request:**
```
GET /api/applications/my HTTP/1.1
Cookie: JSESSIONID=ABC123DEF456...
```

**Response (JSON):**
```json
{
  "success": true,
  "data": [
    {
      "applicationId": 45,
      "jobId": 12,
      "jobRole": "Software Engineer",
      "companyName": "Tech Corp",
      "status": "Applied",
      "appliedDate": "2026-04-20",
      "deadline": "2026-06-30"
    },
    {
      "applicationId": 46,
      "jobId": 15,
      "jobRole": "Data Analyst",
      "companyName": "Data Inc",
      "status": "Selected",
      "appliedDate": "2026-04-18",
      "deadline": "2026-06-25"
    }
  ]
}
```

---

### 3. Get Application Details
**Endpoint:** `GET /api/applications/{applicationId}`  
**Description:** Get details of a specific application  
**Authentication:** Required

**Request:**
```
GET /api/applications/45 HTTP/1.1
Cookie: JSESSIONID=ABC123DEF456...
```

**Response (JSON):**
```json
{
  "success": true,
  "data": {
    "applicationId": 45,
    "studentId": 10,
    "studentName": "John Doe",
    "studentEmail": "john@college.com",
    "jobId": 12,
    "jobRole": "Software Engineer",
    "companyName": "Tech Corp",
    "status": "Selected",
    "appliedDate": "2026-04-20",
    "updatedDate": "2026-04-25",
    "feedback": "Excellent coding skills, selected for final round",
    "resumePath": "/uploads/10_resume.pdf"
  }
}
```

---

### 4. Get Job Applications (Admin)
**Endpoint:** `GET /api/jobs/{jobId}/applications`  
**Description:** Get all applications for a specific job (admin only)  
**Authentication:** Required (Admin)

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| status | String | Filter by status (optional) |
| sort | String | Sort by (applied_date, status) (optional) |

**Request:**
```
GET /api/jobs/12/applications?status=Applied&sort=applied_date HTTP/1.1
Cookie: JSESSIONID=XYZ789...
```

**Response (JSON):**
```json
{
  "success": true,
  "jobId": 12,
  "jobRole": "Software Engineer",
  "totalApplications": 25,
  "data": [
    {
      "applicationId": 45,
      "studentId": 10,
      "studentName": "John Doe",
      "studentCGPA": 8.5,
      "studentBranch": "CS",
      "status": "Applied",
      "appliedDate": "2026-04-20",
      "resumePath": "/uploads/10_resume.pdf",
      "linkedinUrl": "https://linkedin.com/in/johndoe"
    }
  ]
}
```

---

## File Upload Endpoints

### 1. Upload Resume
**Endpoint:** `POST /upload`  
**Description:** Upload student resume (PDF)  
**Authentication:** Required (Student)  
**Content-Type:** multipart/form-data

**Request:**
```
POST /upload HTTP/1.1
Content-Type: multipart/form-data; boundary=----Boundary123
Cookie: JSESSIONID=ABC123DEF456...

------Boundary123
Content-Disposition: form-data; name="resumeFile"; filename="resume.pdf"
Content-Type: application/pdf

[binary PDF data]
------Boundary123--
```

**Request Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| resumeFile | File | Yes | PDF file (max 5MB) |

**Response (Success):**
```json
{
  "success": true,
  "message": "Resume uploaded successfully",
  "filePath": "/uploads/10_resume.pdf",
  "fileName": "10_resume.pdf"
}
```

**Response (Error - Invalid File Type):**
```json
{
  "success": false,
  "error": "Invalid file type. Only PDF allowed."
}
```

---

### 2. Upload Profile Picture
**Endpoint:** `POST /upload-profile`  
**Description:** Upload student profile picture (JPG/PNG)  
**Authentication:** Required (Student)  
**Content-Type:** multipart/form-data

**Request:**
```
POST /upload-profile HTTP/1.1
Content-Type: multipart/form-data; boundary=----Boundary123
Cookie: JSESSIONID=ABC123DEF456...

------Boundary123
Content-Disposition: form-data; name="profilePic"; filename="photo.jpg"
Content-Type: image/jpeg

[binary image data]
------Boundary123--
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Profile picture updated",
  "imagePath": "/uploads/10_profile.jpg"
}
```

---

## Error Handling

### Error Response Format

```json
{
  "success": false,
  "error": "Error message describing what went wrong",
  "errorCode": "ERROR_CODE",
  "details": {
    "field": "Additional context about error"
  }
}
```

### Common Error Codes

| Error Code | Description | HTTP Status |
|-----------|-------------|------------|
| INVALID_CREDENTIALS | Email or password is incorrect | 401 |
| UNAUTHORIZED | User not authenticated or not authorized | 403 |
| NOT_FOUND | Resource not found | 404 |
| VALIDATION_ERROR | Input validation failed | 400 |
| DUPLICATE_ENTRY | Duplicate email or enrollment number | 409 |
| SERVER_ERROR | Internal server error | 500 |
| SESSION_EXPIRED | Session has expired, please login again | 401 |

---

## Status Codes

| Status Code | Meaning | Description |
|-----------|---------|-------------|
| 200 | OK | Request successful |
| 302 | Found | Redirect to another endpoint |
| 400 | Bad Request | Invalid input parameters |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Duplicate entry or conflict |
| 500 | Internal Server Error | Server error |

---

## Rate Limiting

Currently, there is no rate limiting implemented. For production, consider implementing:
- 100 requests per minute per IP for login endpoints
- 1000 requests per minute per user for general endpoints

---

## Security Headers

All responses include security headers:
```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000
```

---

## CORS Policy

CORS is currently restricted to same-origin requests. Update if building a separate frontend:

```
Access-Control-Allow-Origin: https://yourdomain.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

---

## Pagination

Endpoints that return lists use pagination with defaults:
- **pageSize**: 10 records per page
- **maxPageSize**: 100 records per page
- **defaultSort**: Most recent first

**Example Pagination Response:**
```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "pageSize": 10,
    "totalRecords": 45,
    "totalPages": 5,
    "hasNext": true,
    "hasPrev": false
  }
}
```

---

## API Versioning

Current API Version: **v1**  
Future versions will maintain backward compatibility with `/api/v1/*` prefix.

---

## Authentication Methods

### Session-Based (Current)
Uses HTTP sessions with cookies. Stateful authentication.

### Future: Token-Based (JWT)
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Changelog

### Version 1.0
- Student authentication and profile management
- Job posting and application tracking
- Admin application review and status updates

### Version 1.1 (Current)
- **Recruiter Portal**: Added Company authentication and dashboard.
- **Admin Approval**: Implemented workflow for approving/rejecting company registrations.
- **Enhanced UI**: Added Chart.js for Admin analytics and improved applicant review logic (resume viewing).
- **Security**: Refined session handling and role-based redirects.
