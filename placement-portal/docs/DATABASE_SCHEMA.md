# 🗄️ Database Schema & Design

Complete database design documentation for the Ignite Placement Portal.

## Table of Contents
- [Database Overview](#database-overview)
- [Tables Structure](#tables-structure)
- [Relationships & Constraints](#relationships--constraints)
- [Indexes](#indexes)
- [Stored Procedures & Triggers](#stored-procedures--triggers)
- [Sample Data Inserts](#sample-data-inserts)
- [Backup & Restore](#backup--restore)
- [Performance Optimization](#performance-optimization)

---

## Database Overview

**Database Name:** `placement_portal`  
**Database Engine:** MySQL 8.0+  
**Character Set:** UTF-8 MB4 (supports emojis and special characters)  
**Collation:** utf8mb4_unicode_ci

### Database Creation

```sql
CREATE DATABASE IF NOT EXISTS placement_portal 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE placement_portal;
```

---

## Tables Structure

### 1. STUDENTS Table

Stores all student information and profile details.

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    cgpa DOUBLE DEFAULT 0.0,
    branch VARCHAR(50),
    skills TEXT,
    contact_number VARCHAR(15),
    enrollment_no VARCHAR(50) UNIQUE NOT NULL,
    linkedin_url VARCHAR(255),
    profile_pic_path VARCHAR(255),
    resume_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for better query performance
    INDEX idx_email (email),
    INDEX idx_cgpa (cgpa),
    INDEX idx_enrollment (enrollment_no),
    INDEX idx_created_at (created_at),
    
    -- Constraints
    CONSTRAINT chk_cgpa CHECK (cgpa >= 0 AND cgpa <= 10),
    CONSTRAINT chk_email FORMAT CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add comment
ALTER TABLE students COMMENT = 'Stores student profile information and credentials';
```

**Column Descriptions:**

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| student_id | INT | No | AUTO_INCREMENT | Unique student identifier |
| name | VARCHAR(100) | No | - | Full name of student |
| email | VARCHAR(100) | No | UNIQUE | Email (used for login) |
| password | VARCHAR(255) | No | - | SHA256 hashed password |
| cgpa | DOUBLE | Yes | 0.0 | Current CGPA (0-10) |
| branch | VARCHAR(50) | Yes | - | Branch/Department |
| skills | TEXT | Yes | - | Comma-separated skills list |
| contact_number | VARCHAR(15) | Yes | - | Phone number |
| enrollment_no | VARCHAR(50) | No | UNIQUE | Enrollment/Roll number |
| linkedin_url | VARCHAR(255) | Yes | - | LinkedIn profile URL |
| profile_pic_path | VARCHAR(255) | Yes | - | Path to profile picture |
| resume_path | VARCHAR(255) | Yes | - | Path to resume PDF |
| created_at | TIMESTAMP | No | CURRENT_TIMESTAMP | Account creation time |
| updated_at | TIMESTAMP | No | CURRENT_TIMESTAMP ON UPDATE | Last profile update |

---

### 2. ADMIN Table

Stores administrator credentials and information.

```sql
### 2. ADMINS Table

Stores administrator credentials.

```sql
CREATE TABLE admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Column Descriptions:**

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| id | INT | No | AUTO_INCREMENT | Unique admin identifier |
| username | VARCHAR(100) | No | UNIQUE | Admin login name |
| password | VARCHAR(255) | No | - | Admin password |
| created_at | TIMESTAMP | No | CURRENT_TIMESTAMP | Account creation time |

---

### 3. COMPANIES Table

Stores company/organization information.

```sql
### 3. COMPANIES Table

Stores company information and recruiter credentials.

```sql
CREATE TABLE companies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Column Descriptions:**

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| id | INT | No | AUTO_INCREMENT | Unique company identifier |
| name | VARCHAR(150) | No | UNIQUE | Company name |
| email | VARCHAR(100) | No | UNIQUE | Company email (login) |
| password | VARCHAR(255) | No | - | Recruiter password |
| description | TEXT | Yes | - | Company background |
| logo_url | VARCHAR(255) | Yes | - | URL to logo |
| status | ENUM | No | 'Pending' | Registration status |
| created_at | TIMESTAMP | No | CURRENT_TIMESTAMP | Created time |

---

### 4. JOBS Table

Stores job posting information.

```sql
CREATE TABLE jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    admin_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    cgpa_eligibility DOUBLE DEFAULT 0.0,
    description TEXT,
    deadline DATE,
    total_positions INT DEFAULT 1,
    job_type VARCHAR(50),
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_company (company_id),
    INDEX idx_admin (admin_id),
    INDEX idx_deadline (deadline),
    INDEX idx_cgpa (cgpa_eligibility),
    INDEX idx_posted_at (posted_at),
    
    -- Constraints
    CONSTRAINT chk_cgpa_eligibility CHECK (cgpa_eligibility >= 0 AND cgpa_eligibility <= 10),
    CONSTRAINT chk_positions CHECK (total_positions > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE jobs COMMENT = 'Job postings with eligibility criteria';
```

**Column Descriptions:**

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| job_id | INT | No | AUTO_INCREMENT | Unique job posting identifier |
| company_id | INT | No | - | FK to companies table |
| admin_id | INT | No | - | FK to admin who posted the job |
| role | VARCHAR(100) | No | - | Job title/role (e.g., "Software Engineer") |
| cgpa_eligibility | DOUBLE | Yes | 0.0 | Minimum CGPA required (0-10) |
| description | TEXT | Yes | - | Detailed job description and requirements |
| deadline | DATE | Yes | - | Application deadline |
| total_positions | INT | Yes | 1 | Number of openings (min 1) |
| job_type | VARCHAR(50) | Yes | - | Job type (Full-time, Internship, etc.) |
| posted_at | TIMESTAMP | No | CURRENT_TIMESTAMP | When job was posted |
| updated_at | TIMESTAMP | No | CURRENT_TIMESTAMP ON UPDATE | Last update time |

---

### 5. APPLICATIONS Table

Stores student job applications and their status.

```sql
CREATE TABLE applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    job_id INT NOT NULL,
    status ENUM('Applied', 'Selected', 'Rejected', 'Under Review') DEFAULT 'Applied',
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    interview_feedback TEXT,
    
    -- Foreign Keys
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    
    -- Unique constraint to prevent duplicate applications
    UNIQUE KEY unique_application (student_id, job_id),
    
    -- Indexes
    INDEX idx_student (student_id),
    INDEX idx_job (job_id),
    INDEX idx_status (status),
    INDEX idx_applied_date (applied_date),
    INDEX idx_updated_date (updated_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE applications COMMENT = 'Student job applications tracking';
```

**Column Descriptions:**

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| application_id | INT | No | AUTO_INCREMENT | Unique application identifier |
| student_id | INT | No | - | FK to students table |
| job_id | INT | No | - | FK to jobs table |
| status | ENUM | No | 'Applied' | Current status (Applied/Selected/Rejected/Under Review) |
| applied_date | TIMESTAMP | No | CURRENT_TIMESTAMP | When application was submitted |
| updated_date | TIMESTAMP | No | CURRENT_TIMESTAMP ON UPDATE | Last status update |
| interview_feedback | TEXT | Yes | - | Admin feedback/notes about candidate |

---

## Relationships & Constraints

### Entity-Relationship Diagram

```
ADMIN (1) ──────────> (Many) JOBS
  │
  └──────────────────> COMPANIES

COMPANIES (1) ────────> (Many) JOBS

STUDENTS (1) ─────────> (Many) APPLICATIONS
JOBS (1) ──────────────> (Many) APPLICATIONS
```

### Constraint Types

1. **Primary Keys**: Each table has an auto-incrementing primary key
2. **Foreign Keys**: Maintain referential integrity
   - `jobs.company_id` → `companies.company_id`
   - `jobs.admin_id` → `admin.admin_id`
   - `applications.student_id` → `students.student_id`
   - `applications.job_id` → `jobs.job_id`
3. **Unique Keys**: Prevent duplicate entries
   - `students.email`
   - `students.enrollment_no`
   - `admin.email`
   - `companies.name`
   - `applications(student_id, job_id)` - unique per student-job pair
4. **Check Constraints**: Validate data ranges
   - CGPA between 0-10
   - Total positions > 0
   - Valid email format

---

## Indexes

### Index Strategy

```sql
-- Value lookup indexes (Unique)
CREATE UNIQUE INDEX idx_students_email ON students(email);
CREATE UNIQUE INDEX idx_students_enrollment ON students(enrollment_no);
CREATE UNIQUE INDEX idx_admin_email ON admin(email);

-- Foreign key indexes (automatically created)
-- On jobs
CREATE INDEX idx_jobs_company ON jobs(company_id);
CREATE INDEX idx_jobs_admin ON jobs(admin_id);

-- On applications
CREATE INDEX idx_applications_student ON applications(student_id);
CREATE INDEX idx_applications_job ON applications(job_id);

-- Filtering indexes
CREATE INDEX idx_students_cgpa ON students(cgpa);
CREATE INDEX idx_jobs_deadline ON jobs(deadline);
CREATE INDEX idx_applications_status ON applications(status);

-- Range/Sort indexes
CREATE INDEX idx_jobs_posted_at ON jobs(posted_at);
CREATE INDEX idx_students_created_at ON students(created_at);
CREATE INDEX idx_applications_applied_date ON applications(applied_date);

-- Composite indexes for common queries
CREATE INDEX idx_applications_job_status ON applications(job_id, status);
CREATE INDEX idx_applications_student_status ON applications(student_id, status);
```

### Query Performance Analysis

**Without Index:**
```sql
SELECT * FROM students WHERE cgpa >= 7.5;
-- Full table scan: O(n)
```

**With Index:**
```sql
CREATE INDEX idx_students_cgpa ON students(cgpa);
SELECT * FROM students WHERE cgpa >= 7.5;
-- Index scan: O(log n)
```

---

## Stored Procedures & Triggers

### Trigger 1: Auto-Update Student's updated_at

```sql
DELIMITER $$

CREATE TRIGGER students_update_timestamp
BEFORE UPDATE ON students
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END$$

DELIMITER ;
```

### Trigger 2: Cascade Application Status Updates

```sql
DELIMITER $$

CREATE TRIGGER applications_update_timestamp
BEFORE UPDATE ON applications
FOR EACH ROW
BEGIN
    SET NEW.updated_date = CURRENT_TIMESTAMP;
    IF NEW.status != OLD.status THEN
        -- Log status change for audit trail (future)
    END IF;
END$$

DELIMITER ;
```

### Procedure: Get Eligible Students for a Job

```sql
DELIMITER $$

CREATE PROCEDURE GetEligibleStudents(IN p_job_id INT)
BEGIN
    SELECT 
        s.student_id,
        s.name,
        s.email,
        s.cgpa,
        s.branch,
        s.skills,
        CASE 
            WHEN a.application_id IS NOT NULL THEN 'Applied'
            ELSE 'Not Applied'
        END as application_status
    FROM students s
    INNER JOIN jobs j ON j.job_id = p_job_id
    LEFT JOIN applications a ON s.student_id = a.student_id AND a.job_id = p_job_id
    WHERE s.cgpa >= j.cgpa_eligibility
    ORDER BY s.cgpa DESC;
END$$

DELIMITER ;

-- Usage
CALL GetEligibleStudents(5);
```

### Procedure: Get Application Statistics

```sql
DELIMITER $$

CREATE PROCEDURE GetApplicationStats(IN p_job_id INT)
BEGIN
    SELECT 
        'Total Applications' as stat_name,
        COUNT(*) as count
    FROM applications
    WHERE job_id = p_job_id
    
    UNION ALL
    
    SELECT 
        'Selected',
        COUNT(*)
    FROM applications
    WHERE job_id = p_job_id AND status = 'Selected'
    
    UNION ALL
    
    SELECT 
        'Rejected',
        COUNT(*)
    FROM applications
    WHERE job_id = p_job_id AND status = 'Rejected'
    
    UNION ALL
    
    SELECT 
        'Under Review',
        COUNT(*)
    FROM applications
    WHERE job_id = p_job_id AND status = 'Under Review';
END$$

DELIMITER ;

-- Usage
CALL GetApplicationStats(5);
```

---

## Sample Data Inserts

### Insert Admin

```sql
INSERT INTO admin (email, password, name) VALUES
('admin@college.com', SHA2('admin123', 256), 'College Admin'),
('admin2@college.com', SHA2('admin456', 256), 'Admin Officer');
```

### Insert Companies

```sql
INSERT INTO companies (name, description, logo_url, website) VALUES
('Tech Corp', 'Leading software development company', '/images/techcorp.png', 'https://techcorp.com'),
('Data Inc', 'Big data and analytics solutions', '/images/datainc.png', 'https://datainc.com'),
('Cloud Systems', 'Cloud infrastructure and services', '/images/cloud.png', 'https://cloudsys.com'),
('Innovate Labs', 'Innovation and research organization', '/images/innovate.png', 'https://innovatelabs.com');
```

### Insert Students

```sql
INSERT INTO students (name, email, password, cgpa, branch, skills, contact_number, enrollment_no, linkedin_url) VALUES
('John Doe', 'john@college.com', SHA2('john123', 256), 8.5, 'Computer Science', 'Java, Python, MySQL', '9876543210', '2021CS1001', 'https://linkedin.com/in/johndoe'),
('Jane Smith', 'jane@college.com', SHA2('jane123', 256), 9.0, 'Computer Science', 'C++, Web Dev, AI', '9876543211', '2021CS1002', 'https://linkedin.com/in/janesmith'),
('Mike Johnson', 'mike@college.com', SHA2('mike123', 256), 7.5, 'IT', 'Java, Spring, Cloud', '9876543212', '2021IT1001', 'https://linkedin.com/in/mikejohnson'),
('Sarah Wilson', 'sarah@college.com', SHA2('sarah123', 256), 8.8, 'Computer Science', 'Data Science, Python, ML', '9876543213', '2021CS1003', 'https://linkedin.com/in/sarahwilson');
```

### Insert Jobs

```sql
INSERT INTO jobs (company_id, admin_id, role, cgpa_eligibility, description, deadline, total_positions, job_type) VALUES
(1, 1, 'Software Engineer', 7.0, 'We are looking for talented software engineers...', '2026-06-30', 5, 'Full-time'),
(1, 1, 'Senior Developer', 8.0, 'Experience required for senior development role...', '2026-07-15', 3, 'Full-time'),
(2, 1, 'Data Analyst', 7.5, 'Analyze complex datasets and provide insights...', '2026-07-01', 4, 'Full-time'),
(3, 2, 'Cloud Engineer', 7.8, 'Design and implement cloud solutions...', '2026-06-20', 2, 'Full-time'),
(4, 2, 'Research Intern', 7.0, 'Research and development opportunities...', '2026-08-01', 10, 'Internship');
```

### Insert Applications

```sql
INSERT INTO applications (student_id, job_id, status) VALUES
(1, 1, 'Applied'),
(1, 2, 'Selected'),
(2, 1, 'Applied'),
(2, 3, 'Rejected'),
(3, 4, 'Under Review'),
(4, 3, 'Selected'),
(4, 5, 'Applied');
```

---

## Backup & Restore

### Full Database Backup

```bash
# Backup entire database
mysqldump -u root -p placement_portal > placement_portal_backup.sql

# Backup with timestamp
mysqldump -u root -p placement_portal > placement_portal_$(date +%Y%m%d_%H%M%S).sql

# Backup all databases
mysqldump -u root -p --all-databases > all_databases_backup.sql
```

### Backup Specific Table

```bash
mysqldump -u root -p placement_portal students > students_backup.sql
```

### Restore Database

```bash
# Restore full database
mysql -u root -p < placement_portal_backup.sql

# Restore database
mysql -u root -p placement_portal < placement_portal_backup.sql

# Restore specific table
mysql -u root -p placement_portal < students_backup.sql
```

### Automated Backup Script

```bash
#!/bin/bash
# backup.sh

DB_USER="root"
DB_PASSWORD="password"
DB_NAME="placement_portal"
BACKUP_DIR="/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME | gzip > $BACKUP_DIR/placement_portal_$DATE.sql.gz

# Keep only last 7 days of backups
find $BACKUP_DIR -name "placement_portal_*.sql.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/placement_portal_$DATE.sql.gz"
```

---

## Performance Optimization

### Query Optimization Tips

#### 1. Get All Applications for a Job with Student Details

```sql
-- OPTIMIZED VERSION
SELECT 
    a.application_id,
    a.status,
    a.applied_date,
    s.student_id,
    s.name,
    s.email,
    s.cgpa,
    s.resume_path
FROM applications a
INNER JOIN students s ON a.student_id = s.student_id
WHERE a.job_id = ? AND a.status = 'Applied'
ORDER BY s.cgpa DESC
LIMIT 10 OFFSET 0;

-- INDEXES NEEDED
CREATE INDEX idx_applications_job_status ON applications(job_id, status);
CREATE INDEX idx_students_cgpa ON students(cgpa);
```

#### 2. Get Eligible Students for a Job

```sql
-- OPTIMIZED VERSION
SELECT 
    s.student_id,
    s.name,
    s.cgpa,
    COUNT(a.application_id) as total_applications
FROM students s
LEFT JOIN applications a ON s.student_id = a.student_id
WHERE s.cgpa >= (SELECT cgpa_eligibility FROM jobs WHERE job_id = ?)
GROUP BY s.student_id
ORDER BY s.cgpa DESC;

-- INDEXES NEEDED
CREATE INDEX idx_students_cgpa ON students(cgpa);
CREATE INDEX idx_applications_student ON applications(student_id);
```

#### 3. Get Student's Applications with Company Info

```sql
-- OPTIMIZED VERSION
SELECT 
    a.application_id,
    a.status,
    a.applied_date,
    j.job_id,
    j.role,
    c.name as company_name,
    c.logo_url
FROM applications a
INNER JOIN jobs j ON a.job_id = j.job_id
INNER JOIN companies c ON j.company_id = c.company_id
WHERE a.student_id = ?
ORDER BY a.applied_date DESC;

-- INDEXES NEEDED
CREATE INDEX idx_applications_student ON applications(student_id);
CREATE INDEX idx_jobs_company ON jobs(company_id);
```

### Analysis of Slow Queries

```sql
-- Show table statistics
SHOW TABLE STATUS;

-- Show index information
SHOW INDEX FROM applications;
SHOW INDEX FROM students;

-- Get table size
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) as size_mb
FROM information_schema.tables
WHERE table_schema = 'placement_portal';
```

---

## Database Maintenance

### Regular Maintenance Tasks

```sql
-- Optimize tables
OPTIMIZE TABLE students;
OPTIMIZE TABLE jobs;
OPTIMIZE TABLE applications;
OPTIMIZE TABLE companies;
OPTIMIZE TABLE admin;

-- Analyze tables
ANALYZE TABLE students;
ANALYZE TABLE jobs;
ANALYZE TABLE applications;

-- Repair tables (if corrupted)
REPAIR TABLE students;
REPAIR TABLE jobs;
REPAIR TABLE applications;

-- Check table integrity
CHECK TABLE students;
CHECK TABLE jobs;
CHECK TABLE applications;
```

### Monitor Database Performance

```sql
-- Check current connections
SHOW PROCESSLIST;

-- Get database size
SELECT 
    SUM(ROUND(((data_length + index_length) / 1024 / 1024), 2)) as database_size_mb
FROM information_schema.tables
WHERE table_schema = 'placement_portal';

-- Get slow queries log
SHOW VARIABLES LIKE 'slow_query%';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

---

## Data Privacy & Security

### Password Hashing Verification

```sql
-- Verify password during login
SELECT student_id, name, email 
FROM students 
WHERE email = ? AND password = SHA2(?, 256);
```

### Data Encryption Recommendations

For sensitive fields like LinkedIn URL, consider encryption:

```sql
-- Encrypt LinkedIn URL (requires AES encryption)
UPDATE students 
SET linkedin_url = AES_ENCRYPT(linkedin_url, 'encryption_key')
WHERE linkedin_url IS NOT NULL;

-- Decrypt for retrieval
SELECT 
    student_id,
    name,
    AES_DECRYPT(linkedin_url, 'encryption_key') as linkedin_url
FROM students;
```

