# 👨‍💻 Developer Guide

Complete guide for developers contributing to the Ignite Placement Portal project.

## Table of Contents
- [Development Environment Setup](#development-environment-setup)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Git Workflow](#git-workflow)
- [Building & Running](#building--running)
- [Testing](#testing)
- [Code Review Checklist](#code-review-checklist)
- [Debugging Tips](#debugging-tips)
- [Common Issues & Solutions](#common-issues--solutions)
- [Contribution Guidelines](#contribution-guidelines)

---

## Development Environment Setup

### System Requirements

| Requirement | Version | Why |
|-----------|---------|-----|
| **Java JDK** | 8+ | Required for Java compilation |
| **Maven** | 3.6+ | Build tool and dependency management |
| **Maven** | 10.0+ | Application server for JSP deployment |
| **MySQL** | 8.0+ | Relational database engine |
| **Git** | 2.0+ | Version control system |
| **IDE** | IntelliJ/Eclipse/VS Code | Code editor and debugging tools |

### IDE Setup

#### IntelliJ IDEA

1. **Open Project**
   - File → Open → Select project directory
   - Trust project when prompted

2. **Configure JDK**
   - File → Project Structure → Project → Set SDK to JDK 8+
   - Apply and OK

3. **Configure Maven**
   - File → Settings → Build, Execution, Deployment → Build Tools → Maven
   - Maven home path: Select your Maven installation
   - OK

4. **Configure Tomcat**
   - Run → Edit Configurations...
   - Click `+` → Tomcat Server → Local
   - Click `Configure` next to Application server
   - Select Tomcat installation directory
   - OK

#### Eclipse

1. Open Eclipse → File → Import → General → Existing Projects into Workspace
2. Select placement-portal folder
3. Configure JDK: Windows → Preferences → Java → Installed JREs
4. Configure Tomcat: Windows → Preferences → Server → Runtime Environments

#### VS Code

```bash
# Install extensions
- Extension Pack for Java (Microsoft)
- Tomcat for Java (Wimonsoft)
- MySQL (cweijan)

# Configure launch.json for debugging
# Configure tasks.json for Maven build commands
```

### Environment Variables

```bash
# Add to .bashrc or .env file
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export MAVEN_HOME=/usr/share/maven
export TOMCAT_HOME=/opt/tomcat
export PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin:$TOMCAT_HOME/bin
```

### Database Setup

```bash
# Create database and user
mysql -u root -p

CREATE DATABASE placement_portal CHARACTER SET utf8mb4;
CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'DevPassword123!';
GRANT ALL PRIVILEGES ON placement_portal.* TO 'dev_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Test connection
mysql -u dev_user -p placement_portal
```

---

## Project Structure

```
placement-portal/
├── docs/                              # Documentation
│   ├── README.md                      # Project overview
│   ├── architecture.md                # System design & diagrams
│   ├── API_DOCUMENTATION.md           # Endpoint specifications
│   ├── DATABASE_SCHEMA.md             # Database design
│   ├── DEPLOYMENT_GUIDE.md            # Production deployment
│   ├── DEVELOPER_GUIDE.md             # This file
│   └── TESTING_GUIDE.md               # Testing procedures
│
├── src/
│   ├── main/
│   │   ├── java/com/placement/
│   │   │   ├── controller/            # HTTP Servlets - Handle requests
│   │   │   │   ├── LoginServlet.java
│   │   │   │   ├── RegisterServlet.java
│   │   │   │   ├── ApplyServlet.java
│   │   │   │   ├── AddJobServlet.java
│   │   │   │   ├── UpdateStatusServlet.java
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── model/                 # POJOs - Data objects
│   │   │   │   ├── Student.java
│   │   │   │   ├── Job.java
│   │   │   │   ├── Application.java
│   │   │   │   ├── Company.java
│   │   │   │   └── Admin.java
│   │   │   │
│   │   │   ├── dao/                   # DAO Interfaces
│   │   │   │   ├── StudentDAO.java
│   │   │   │   ├── JobDAO.java
│   │   │   │   ├── ApplicationDAO.java
│   │   │   │   ├── CompanyDAO.java
│   │   │   │   ├── AdminDAO.java
│   │   │   │   │
│   │   │   │   └── impl/              # DAO Implementations
│   │   │   │       ├── StudentDAOImpl.java
│   │   │   │       ├── JobDAOImpl.java
│   │   │   │       ├── ApplicationDAOImpl.java
│   │   │   │       ├── CompanyDAOImpl.java
│   │   │   │       └── AdminDAOImpl.java
│   │   │   │
│   │   │   ├── service/               # Business logic (Future)
│   │   │   │   └── (To be implemented)
│   │   │   │
│   │   │   └── util/                  # Utility classes
│   │   │       ├── DBConnection.java  # Database connection pooling
│   │   │       └── EmailUtil.java     # Email sending
│   │   │
│   │   ├── resources/                 # Configuration files
│   │   │   └── (log4j.properties, etc.)
│   │   │
│   │   └── webapp/                    # Web tier
│   │       ├── index.jsp              # Landing page
│   │       ├── css/
│   │       │   └── style.css
│   │       ├── js/                    # Frontend scripts
│   │       ├── images/                # Static images
│   │       └── jsp/
│   │           ├── student/
│   │           │   ├── dashboard.jsp
│   │           │   ├── login.jsp
│   │           │   ├── register.jsp
│   │           │   ├── profile.jsp
│   │           │   └── top-students.jsp
│   │           ├── admin/
│   │           │   ├── dashboard.jsp
│   │           │   ├── login.jsp
│   │           │   ├── register.jsp
│   │           │   ├── add-job.jsp
│   │           │   └── applicants.jsp
│   │           └── common/
│   │
│   └── test/                          # Unit tests
│       └── java/com/placement/
│           └── (Test classes)
│
├── target/                            # Build output (generated)
├── pom.xml                            # Maven configuration
├── placement-portal.iml               # IntelliJ project file
├── .gitignore                         # Git ignore rules
└── README.md                          # Quick start

```

---

## Coding Standards

### Java Code Style

#### Naming Conventions

```java
// Classes and Interfaces - PascalCase
public class StudentController { }
public interface StudentDAO { }

// Methods and Variables - camelCase
public void getUserById() { }
private String userName = "";

// Constants - UPPER_SNAKE_CASE
private static final int MAX_FILE_SIZE = 5242880; // 5 MB

// Package naming - lowercase
package com.placement.controller;
package com.placement.dao.impl;
```

#### Code Formatting

```java
// Indent with 4 spaces (not tabs)
public class Example {
    // 4 space indent
    private String name;
    
    public void method() {
        // 4 space indent
        if (condition) {
            // 4 space indent
        }
    }
}

// Braces on same line
if (condition) {
    doSomething();
} else {
    doSomethingElse();
}

// Max line length: 120 characters
```

### Servlet Standards

```java
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Extract parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.isEmpty()) {
            response.sendRedirect("jsp/student/login.jsp?error=invalid");
            return;
        }
        
        try {
            // Business logic
            StudentDAO dao = new StudentDAOImpl();
            Student student = dao.login(email, password);
            
            if (student != null) {
                // Success - set session
                HttpSession session = request.getSession();
                session.setAttribute("student", student);
                response.sendRedirect("jsp/student/dashboard.jsp");
            } else {
                // Failure
                response.sendRedirect("jsp/student/login.jsp?error=invalid");
            }
        } catch (Exception e) {
            // Log error
            e.printStackTrace();
            response.sendRedirect("jsp/common/error.jsp?error=server_error");
        }
    }
}
```

### DAO Standards

```java
// DAO Interface
public interface StudentDAO {
    Student login(String email, String password);
    boolean register(Student student);
    Student getStudentById(int id);
    void updateProfile(Student student);
    List<Student> getTopStudents();
}

// DAO Implementation
public class StudentDAOImpl implements StudentDAO {
    
    @Override
    public Student login(String email, String password) {
        Student student = null;
        String query = "SELECT * FROM students WHERE email = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            
            pst.setString(1, email);
            pst.setString(2, hashPassword(password));
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    student = new Student();
                    student.setId(rs.getInt("student_id"));
                    student.setName(rs.getString("name"));
                    student.setEmail(rs.getString("email"));
                    student.setCgpa(rs.getDouble("cgpa"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    
    // Use try-with-resources for proper resource management
}
```

### Comments & Documentation

```java
/**
 * Retrieves a student by ID from the database.
 * 
 * @param studentId the unique student identifier
 * @return Student object if found, null otherwise
 * @throws SQLException if database connection fails
 * 
 * @author John Doe
 * @since 1.0
 */
public Student getStudentById(int studentId) {
    // Implementation
}

// Inline comments for complex logic
if (applicant.getCgpa() >= job.getEligibility()) {
    // Student is eligible for the job, proceed with application
    addApplication(applicant, job);
}
```

### Security Best Practices

```java
// ✅ GOOD - Using prepared statements (prevents SQL injection)
String query = "SELECT * FROM students WHERE email = ? AND password = ?";
PreparedStatement pst = conn.prepareStatement(query);
pst.setString(1, email);
pst.setString(2, hashPassword(password));

// ❌ BAD - String concatenation (SQL injection vulnerability)
String query = "SELECT * FROM students WHERE email = '" + email + "'";

// ✅ GOOD - Hash passwords
String hashedPassword = hashPassword(plainPassword);
pst.setString(1, hashedPassword);

// ❌ BAD - Store password as plaintext
String password = request.getParameter("password");

// ✅ GOOD - Validate session
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("student") == null) {
    response.sendRedirect("jsp/student/login.jsp");
    return;
}

// ❌ BAD - No session validation
Student student = (Student) request.getSession().getAttribute("student");
```

---

## Git Workflow

### Branch Naming

```
main              - Production-ready code
develop           - Integration branch for features
feature/xxx       - New features
bugfix/xxx        - Bug fixes
hotfix/xxx        - Critical production fixes

Examples:
feature/student-registration
feature/job-search-filter
bugfix/login-session-issue
hotfix/sql-injection-fix
```

### Commit Message Format

```
<type>: <subject>

<body>

<footer>

Type: feat, fix, docs, style, refactor, test, chore
Subject: Brief description (50 chars max)
Body: Detailed explanation (wrap at 72 chars)
Footer: Reference to issues (Fixes #123)

Example:
feat: Add student profile update functionality

Implement profile update servlet and form validation.
- Update StudentDAOImpl with updateProfile method
- Add profile.jsp form for editing details
- Add input validation in UpdateProfileDetailsServlet

Fixes #42
```

### Workflow Steps

```bash
# 1. Create feature branch
git checkout -b feature/student-registration

# 2. Make changes and stage
git add src/main/java/com/placement/controller/RegisterServlet.java
git add src/main/webapp/jsp/student/register.jsp

# 3. Commit with message
git commit -m "feat: Add student registration functionality

- Create RegisterServlet for form submission
- Add validation for email uniqueness
- Hash password before storing in database
- Send welcome email to new students

Fixes #10"

# 4. Push to remote
git push origin feature/student-registration

# 5. Create Pull Request (GitHub/GitLab)
# - Link to issue
# - Add description
# - Request reviewers

# 6. Address code review feedback
git add .
git commit -m "Address code review feedback: add input validation"
git push origin feature/student-registration

# 7. Merge to develop after approval
git checkout develop
git merge feature/student-registration

# 8. Delete feature branch
git branch -d feature/student-registration
git push origin --delete feature/student-registration
```

---

## Building & Running

### Maven Commands

```bash
# Clean build
mvn clean

# Compile code
mvn compile

# Run tests
mvn test

# Package as WAR
mvn package

# Install to local repository
mvn install

# Clean and package
mvn clean package

# Skip tests during build (not recommended)
mvn clean package -DskipTests

# View dependencies
mvn dependency:tree

# Resolve dependency conflicts
mvn dependency:resolve-plugins
```

### IDE Build & Run

#### IntelliJ IDEA

```bash
# Build
Ctrl + F9 (Windows/Linux)
Cmd + F9 (Mac)

# Run
Shift + F10 (Windows/Linux)
Ctrl + R (Mac)

# Run with debugging
Shift + F9 (Windows/Linux)
Ctrl + D (Mac)
```

#### Eclipse

```bash
# Build
Ctrl + B

# Run on Server
Right-click project → Run As → Run on Server
```

### Access Application

```
Development: http://localhost:8080/placement-portal
Admin Login: admin@college.com / admin123
Student Login: john@college.com / john123
```

---

## Testing

### Unit Testing

```java
import org.junit.Test;
import static org.junit.Assert.*;

public class StudentDAOTest {
    
    @Test
    public void testLogin() {
        StudentDAO dao = new StudentDAOImpl();
        Student student = dao.login("john@college.com", "john123");
        
        assertNotNull("Student should be found", student);
        assertEquals("Student name should match", "John Doe", student.getName());
        assertEquals("Student CGPA should match", 8.5, student.getCgpa(), 0.01);
    }
    
    @Test
    public void testLoginInvalidPassword() {
        StudentDAO dao = new StudentDAOImpl();
        Student student = dao.login("john@college.com", "wrongpassword");
        
        assertNull("Student should not be found with wrong password", student);
    }
}
```

### Integration Testing

```java
@RunWith(Spring Runner.class)
@SpringBootTest
public class ApplicationFlowTest {
    
    @Test
    public void testStudentRegistrationAndLogin() {
        // Register
        Student newStudent = new Student();
        newStudent.setName("Jane Doe");
        newStudent.setEmail("jane@college.com");
        newStudent.setCgpa(8.5);
        
        StudentDAO dao = new StudentDAOImpl();
        boolean registered = dao.register(newStudent);
        assertTrue("Registration should succeed", registered);
        
        // Login
        Student loggedIn = dao.login("jane@college.com", "password");
        assertNotNull("Login should succeed", loggedIn);
        assertEquals("Names should match", "Jane Doe", loggedIn.getName());
    }
}
```

---

## Code Review Checklist

Before submitting PR, ensure:

- [ ] Code follows naming conventions and formatting standards
- [ ] All public methods/classes have Javadoc comments
- [ ] No hardcoded values (use constants or config files)
- [ ] SQL queries use PreparedStatements (not concatenation)
- [ ] Exception handling is comprehensive
- [ ] Session validation is performed where required
- [ ] Input validation is implemented
- [ ] Files are not committed unnecessarily
- [ ] Build passes without warnings: `mvn clean install`
- [ ] Unit tests written and passing
- [ ] No logs that expose sensitive information
- [ ] Changes are minimal and focused on the feature

---

## Debugging Tips

### Enable Debug Mode in Tomcat

```java
// In catalina.sh
export CATALINA_DEBUG_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000"

// Then start with debug
./catalina.sh jpda start
```

### Debug in IDE

1. Set breakpoint by clicking on line number
2. Run → Debug (Shift+F9 in IntelliJ)
3. Step through code using Step Over/Into/Out
4. Inspect variables in Variables panel

### Common Debugging Scenarios

```java
// ❌ Issue: Session returns null
// ✅ Solution: Check session creation
HttpSession session = request.getSession(true); // true = create if doesn't exist

// ❌ Issue: Database connection fails
// ✅ Solution: Check connection string and credentials
System.out.println("DB URL: " + DB_URL);
System.out.println("DB User: " + DB_USER);

// ❌ Issue: JSP not found (404)
// ✅ Solution: Verify path in sendRedirect
response.sendRedirect("jsp/student/dashboard.jsp"); // Relative path
response.sendRedirect("/placement-portal/jsp/student/dashboard.jsp"); // Absolute path

// ❌ Issue: Data not persisting to database
// ✅ Solution: Check if commit() is called
conn.commit();
```

---

## Common Issues & Solutions

### Issue 1: "Java compiler level does not match the version in pom.xml"

**Solution:**
```xml
<!-- In pom.xml -->
<properties>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
</properties>

<!-- Or in IDE: File → Project Structure → Project → Set SDK to Java 8 -->
```

### Issue 2: "Cannot find symbol - class HttpSession"

**Solution:**
```java
// Import missing
import jakarta.servlet.http.HttpSession;

// Or in web.xml
<dependency>
    <groupId>jakarta.servlet.jsp</groupId>
    <artifactId>jakarta.servlet.jsp-api</artifactId>
    <version>3.0.0</version>
</dependency>
```

### Issue 3: "Access denied for user 'root'@'localhost'"

**Solution:**
```java
// Update credentials in DBConnection.java
private static final String DB_USER = "dev_user";
private static final String DB_PASSWORD = "DevPassword123!";

// Or create user in MySQL
mysql> CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'DevPassword123!';
mysql> GRANT ALL PRIVILEGES ON placement_portal.* TO 'dev_user'@'localhost';
```

### Issue 4: "Port 8080 is already in use"

**Solution:**
```bash
# Find process using port 8080
netstat -ab | findstr ":8080"  # Windows
lsof -i :8080                  # Mac/Linux

# Kill process (be careful!)
kill -9 <PID>

# Or change Tomcat port in server.xml
<Connector port="8081" protocol="HTTP/1.1" ...
```

### Issue 5: "Transaction marked as rollback only"

**Solution:**
```java
// Ensure no exception occurs in savepoint
try {
    dao.addStudent(student);
    return true;
} catch (SQLException e) {
    e.printStackTrace();
    return false;
}

// Or check auto-commit
connection.setAutoCommit(true);
```

---

## Contribution Guidelines

### Before Starting

1. Check if issue already exists
2. Create issue describing feature/bug
3. Get assigned to issue
4. Create feature branch from `develop`

### While Working

1. Keep commits focused and logical
2. Write clear commit messages
3. Update documentation as needed
4. Test locally before pushing

### Submitting PR

1. Push to your branch
2. Create Pull Request
3. Link to related issue
4. Add description of changes
5. Request review from maintainers
6. Address feedback and push updates
7. Merge after approval

### Code Review Process

1. **Automated Checks**
   - Build passes
   - Tests pass
   - Code quality checks

2. **Manual Review**
   - At least 2 approvals required
   - Follow code standards
   - Check for security issues

3. **Merge**
   - Delete feature branch
   - Update changelog

### Commit Etiquette

```bash
# Good - Small, focused commits
git commit -m "feat: Add CGPA validation to job eligibility"
git commit -m "fix: Fix database connection pool leak"

# Bad - Large, multi-purpose commits
git commit -m "Updated some files"
git git commit -m "Fixed various bugs and added features"
```

---

## Resources

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Oracle Java Documentation](https://docs.oracle.com/javase/8/docs/)
- [Maven Official Documentation](https://maven.apache.org/guides/)
- [Apache Tomcat Documentation](https://tomcat.apache.org/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

---

## Getting Help

1. **Check Documentation**
   - Read README.md and docs/ folder files
   - Search for similar issues

2. **Ask Team**
   - Comment on GitHub issue
   - Ask in team chat/discussions

3. **Debug Yourself**
   - Use IDE debugger
   - Check logs
   - Enable verbose logging

---

Happy coding! 🚀

