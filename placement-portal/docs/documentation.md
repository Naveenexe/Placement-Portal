# 📖 Engineering & Technical Documentation

Welcome to the internal engineering documentation page for **Ignite Placement Portal**. This document details operational workflows, directory hierarchies, and component instructions crucial to internal developers taking over the project.

---

## 📂 Project Structure Map

To keep the development logic clean, the project uses a highly strict standard Maven folder tree:

```text
d:\placement-portal\placement-portal\
├── docs/                        # Internal Software Architect docs
├── README.md                    # Public Front-Page
├── pom.xml                      # Maven Dependency Configuration
└── src/
    └── main/
        ├── java/
        │   └── com/placement/
        │       ├── controller/  # HTTP Web Servlets mapping to user interactions
        │       ├── dao/         # Data Access Object Interfaces
        │       ├── dao/impl/    # MySQL Database Implementation Logic
        │       ├── model/       # Java POJO Domain Entities
        │       └── util/        # Helpers (DBConnection Provider)
        └── webapp/
            ├── css/             # Compiled/Raw CSS containing the modern design system
            ├── uploads/         # Server-side directory storing user PDF resumes & pics
            ├── jsp/             
            │   ├── admin/       # Shielded folder for root administrator pages
            │   ├── student/     # Shielded folder for student-centric pages
            │   └── company/     # Portal for recruiters to review applicants
            └── index.jsp        # Root landing split-screen logic
```

---

## 🛠 Features & Capabilities Reference

### 1. Unified Design System (`style.css`)
Our UI does not rely on heavy external frameworks. We achieve an incredibly premium feel utilizing hand-crafted CSS custom properties (variables) defined in `:root`. 
- **Typography:** `Inter` typeface.
- **Iconography:** `Remix Icon` font system via CDN.
- **Glassmorphism:** Leveraged via translucent `rgba()` backgrounds and gentle `box-shadows`.

### 2. Form Safeguards & Error Handling
All authentication routes (`LoginServlet`, `AdminLoginServlet`, `CompanyLoginServlet`) implement strict failure redirection. Upon a misfire, the portals gracefully redirect appending `?error=invalid`. JSPs intelligently capture this parameter and display themed error banners. Registration endpoints (`AdminRegisterServlet`, `CompanyRegisterServlet`) utilize `HttpSession` to pass stateful success (`succMsg`) or error (`errorMsg`) feedback to the view.

### 3. Company Onboarding & Approval Flow
The system implements a dual-layer registration for recruitment companies. Recruiters register via the Public Portal; however, access is strictly prohibited until their status is shifted from `Pending` to `Approved` by a valid System Administrator. This prevents unverified entities from viewing student datasets.

### 4. File Upload & MIME Parsing
The `UploadServlet` utilizes `jakarta.servlet.annotation.MultipartConfig` and securely generates serialized files appending `studentId` onto the front of images/pdfs to avoid file overwrites (e.g., `4_resume.pdf`). 

### 4. Dynamic Safeguarding Protocol (Anti-crash mechanism)
Within Dashboard elements (`Student Dashboard`, `Admin Dashboard`), rendering logic handles missing relational queries gracefully. If an Admin completely wipes out a localized company from the map via direct SQL commands, the dashboard gracefully reverts the job owner to **"Unknown Company (Deleted)"** and removes image mapping to protect JSP generation scripts from firing `NullPointerExceptions`.

---

## ⚡ Deployment Playbook (Production Build)

If deploying to a cloud-provider like DigitalOcean or AWS via Tomcat container:

1. **Clean & Package**
   Ensure maven successfully packages your `.war` (Web Archive) without test failures.
   `mvn clean install`
2. **Move Artifact to webapps/**
   Take the generated `placement-portal.war` and drop it inside Tomcat's `/webapps` folder.
   `cp target/placement-portal-1.0.war /usr/local/tomcat/webapps/placement-portal.war`
3. **Environment Checks**
   Ensure `MySQL` is reachable (e.g. `localhost:3306`). Update `DBConnection.java` to point to the secure production VPC IP if needed instead of localhost.

---

> *For system architecture specifics, please refer to the `architecture.md` guide.*
