# 🔥 Ignite | Placement Portal

<div align="center">

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)
![JSP/Servlets](https://img.shields.io/badge/JSP_&_Servlets-3A75B0?style=for-the-badge&logo=java&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![Tomcat](https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)

**A Premium Campus Placement Portal** built with Java, JSP, and MySQL

*Bridging the gap between students, colleges, and top-tier recruiters*

[Documentation](#-documentation) • [Features](#-key-features) • [Installation](#-installation--setup) • [Contributing](#-contributing)

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
  - [For Students](#-for-students)
  - [For Administrators](#-for-administrators)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Installation & Setup](#-installation--setup)
- [Project Structure](#-project-structure)
- [Usage Guide](#-usage-guide)
- [Documentation](#-documentation)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**Ignite Placement Portal** is an enterprise-grade web application designed to streamline the campus placement process. It provides a centralized platform where:

- **Students** can discover placement opportunities, build professional profiles, and track their application status
- **Recruiters** can register company profiles, post job vacancies, and review/select student candidates
- **Administrators** can moderate company registrations, manage job postings, and oversee placement analytics

Built with modern design principles (glassmorphism), responsive UI, and robust backend architecture, Ignite ensures a seamless experience for all stakeholders.

### Key Statistics
- **MVC Architecture** for clean separation of concerns
- **Zero External CSS Frameworks** - Custom hand-crafted CSS with design system
- **JDBC-based** Database Layer with DAO pattern
- **Session Management** for secure authentication
- **File Upload Support** for resumes and profile pictures
- **Responsive Design** supporting desktop and tablet views

---

## ✨ Key Features

### 🎓 For Students

| Feature | Description |
|---------|-------------|
| **Modern Dashboard** | Discover and apply to active placement drives dynamically tailored to your CGPA eligibility |
| **Profile Management** | Comprehensive profile system with personal info, automatic avatars, and PDF resume uploads |
| **Live Application Tracking** | Track whether applications are *Applied*, *Selected*, or *Rejected* in real-time |
| **Leaderboard System** | View top-performing students on the college leaderboard |
| **Resume Upload** | Secure file upload for PDF resumes with automatic naming to prevent overwrites |
| **Advanced Search** | Filter job postings by company, role, salary, and eligibility criteria |
| **Notifications** | Email notifications for application status updates and new job postings |

### 🏢 For Recruiters

| Feature | Description |
|---------|-------------|
| **Approved Access** | Only companies approved by training & placement officers can access student data |
| **Recruiter Dashboard** | View live applicant lists and aggregate stats for each posted job |
| **Resume Review** | Direct in-browser viewing of student resumes for selection |
| **Status Management** | One-click Select/Reject actions that update student dashboards instantly |

### 🛠 For Administrators

| Feature | Description |
|---------|-------------|
| **Moderation Dashboard** | Review and Approve/Reject new company registration requests |
| **Analytics (Chart.js)** | Real-time doughnut charts showing overall placement statistics |
| **Drive Oversight** | Monitor all active job postings across different organizations |
| **Applicant Tracking** | Global view of all student applications and their movement through the funnel |

---

## 🛠 Tech Stack

### Backend
- **Language**: Java 8+
- **Framework**: Jakarta EE (Servlets 5.0, JSP 3.0)
- **Build Tool**: Maven 3.6+
- **Application Server**: Apache Tomcat 10.0+
- **Database**: MySQL 8.0+
- **Email**: Jakarta Mail 2.0

### Frontend
- **HTML5** - Semantic markup
- **CSS3** - Custom design system with glassmorphism effects
- **JavaScript** - Native DOM manipulation (no frameworks)
- **Icons**: Remix Icon CDN
- **Fonts**: Inter (Google Fonts)

### Database
- **Engine**: MySQL 8.0
- **Architecture**: Relational model with foreign keys
- **Connection Pooling**: via DBConnection utility

---

## 🏗 System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT BROWSER                           │
│              (HTML + CSS + JavaScript)                      │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP Requests/Responses
┌──────────────────────────▼──────────────────────────────────┐
│              APACHE TOMCAT (Web Container)                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │       CONTROLLER LAYER (Servlets)                    │  │
│  │  - LoginServlet, AdminLoginServlet                   │  │
│  │  - ApplyServlet, AddJobServlet                       │  │
│  │  - UpdateProfileDetailsServlet                       │  │
│  │  - ViewApplicantsServlet, etc.                       │  │
│  └──────────────────────────────────────────────────────┘  │
│                           ▲                                   │
│                           │                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        VIEW LAYER (JSP Pages)                        │  │
│  │  - jsp/student/dashboard.jsp                         │  │
│  │  - jsp/admin/dashboard.jsp                           │  │
│  │  - jsp/company/dashboard.jsp                         │  │
│  │  - login.jsp, register.jsp, etc.                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                           ▲                                   │
│                           │                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │      MODEL & DATA ACCESS LAYER                       │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │  Models: Student, Job, Admin, Company, etc  │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │  DAOs (Interfaces)                           │   │  │
│  │  │  - StudentDAO, JobDAO, AdminDAO, etc         │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │  DAO Implementations                         │   │  │
│  │  │  - StudentDAOImpl, JobDAOImpl, etc             │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │  Utilities                                   │   │  │
│  │  │  - DBConnection, EmailUtil                   │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────┘  │
│                           ▲                                   │
│                           │ JDBC Queries                      │
└───────────────────────────┼────────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────────┐
│              MYSQL DATABASE                                 │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Tables: students, jobs, companies, admin,         │   │
│  │          applications                              │   │
│  └────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Installation & Setup

### Prerequisites

- **Java Development Kit (JDK)** 8 or higher
- **Apache Tomcat** 10.0 or higher
- **MySQL Server** 8.0 or higher
- **Maven** 3.6 or higher
- **IDE**: IntelliJ IDEA (Ultimate), Eclipse EE, or VS Code with Java extensions
- **Git** for version control

### Step-by-Step Installation

#### 1. **Clone the Repository**
```bash
git clone https://github.com/your-org/placement-portal.git
cd placement-portal
```

#### 2. **Configure MySQL Database**

Create a new database and user:
```sql
CREATE DATABASE IF NOT EXISTS placement_portal;
USE placement_portal;
```

#### 3. **Update Database Credentials**

Edit `src/main/java/com/placement/util/DBConnection.java`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_portal";
private static final String DB_USER = "your_username";
private static final String DB_PASSWORD = "your_password";
```

#### 4. **Build the Project**

```bash
# Download dependencies and compile
mvn clean install

# Package as WAR
mvn clean package
```

#### 5. **Deploy and Run**

In your IDE, deploy the project to Tomcat and start the server.

Access the application at: `http://localhost:8080/placement-portal`

---

## 📂 Project Structure

```
placement-portal/
├── docs/                        # Documentation
├── src/
│   └── main/
│       ├── java/com/placement/
│       │   ├── controller/      # HTTP Servlets
│       │   ├── dao/             # Data Access Interfaces
│       │   ├── dao/impl/        # DAO Implementations
│       │   ├── model/           # Domain entities
│       │   ├── service/         # Business logic
│       │   └── util/            # Utilities
│       └── webapp/
│           ├── jsp/
│           │   ├── student/     # Student portal
│           │   ├── admin/       # Admin control center
│           │   └── company/     # Recruiter profile & review portal
│           ├── css/
│           ├── js/
│           └── uploads/         # User resumes & pics
│
├── pom.xml                      # Maven configuration
└── README.md                    # This file
```

---

## 📖 Documentation

Comprehensive documentation for different aspects of the project:

| Document | Purpose |
|----------|---------|
| [**Architecture & Diagrams**](./docs/architecture.md) | System design, UML diagrams, database ER diagrams, sequence flows |
| [**API Documentation**](./docs/API_DOCUMENTATION.md) | All REST/Servlet endpoints with request/response formats |
| [**Database Schema**](./docs/DATABASE_SCHEMA.md) | Complete database design with table structures, relationships, and queries |
| [**Deployment Guide**](./docs/DEPLOYMENT_GUIDE.md) | Production deployment steps for various cloud platforms |
| [**Developer Guide**](./docs/DEVELOPER_GUIDE.md) | Code standards, contribution guidelines, local development setup |
| [**Testing Guide**](./docs/TESTING_GUIDE.md) | Unit testing, integration testing, and QA procedures |
| [**Technical Documentation**](./docs/documentation.md) | Engineering details and operational workflows |

---

## 👨‍💻 Usage Guide

### For Students
1. **Register**: Fill in your details and create an account
2. **Login**: Access your dashboard with email and password
3. **Complete Profile**: Upload profile picture and resume
4. **Browse & Apply**: Apply to jobs matching your eligibility
5. **Track Status**: Monitor application progress

### For Administrators
1. **Login**: Access admin portal with credentials
2. **Add Jobs**: Post new job openings
3. **Review Applications**: View and manage applications
4. **Update Status**: Accept or reject candidates

---

## 🚀 Deployment

For production deployment, refer to [**DEPLOYMENT_GUIDE.md**](./docs/DEPLOYMENT_GUIDE.md)

---

## 🤝 Contributing

Contributions are welcome! Please check [**DEVELOPER_GUIDE.md**](./docs/DEVELOPER_GUIDE.md) for guidelines.

---

## 📝 License

MIT License - see LICENSE file for details.

---

<div align="center">

**Made with ❤️ for the next generation of engineers**

</div>
