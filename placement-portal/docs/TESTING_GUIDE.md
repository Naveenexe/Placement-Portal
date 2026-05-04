# 🧪 Testing Guide

Complete testing strategies and procedures for the Ignite Placement Portal.

## Table of Contents
- [Testing Overview](#testing-overview)
- [Unit Testing](#unit-testing)
- [Integration Testing](#integration-testing)
- [Functional Testing](#functional-testing)
- [Performance Testing](#performance-testing)
- [Security Testing](#security-testing)
- [Test Data](#test-data)
- [CI/CD Testing](#cicd-testing)
- [Bug Report Template](#bug-report-template)

---

## Testing Overview

### Testing Pyramid

```
        ▲
       /│\
      / │ \
     /  │  \                E2E / Manual Tests (Slow, Expensive)
    / E2E  \                ~10% of tests
   /________\

      /│\
     / │ \
    /  │  \                Integration Tests (Medium)
   / Integ \               ~30% of tests
  /________\

   /│\
  / │ \
 /  │  \                   Unit Tests (Fast, Cheap)
/Unit  \                   ~60% of tests
/__________\

```

### Test Strategy by Module

| Module | Unit Tests | Integration | Functional | Performance |
|--------|-----------|-------------|-----------|------------|
| DAO Layer | ✅ High | ✅ High | - | ✅ Medium |
| Controller | ✅ Medium | ✅ High | ✅ High | ✅ Low |
| View/JSP | - | ✅ Medium | ✅ High | - |
| Utilities | ✅ High | - | - | ✅ High |
| Security | ✅ High | ✅ High | ✅ High | - |

---

## Unit Testing

### Setup

```xml
<!-- In pom.xml -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>4.8.0</version>
    <scope>test</scope>
</dependency>
```

### DAO Unit Tests

```java
import org.junit.Before;
import org.junit.After;
import org.junit.Test;
import static org.junit.Assert.*;

public class StudentDAOTest {
    
    private StudentDAO studentDAO;
    private Connection testConnection;
    
    @Before
    public void setUp() throws Exception {
        // Setup test database connection
        studentDAO = new StudentDAOImpl();
        testConnection = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/placement_portal_test",
            "test_user",
            "test_password"
        );
        // Clear test data
        clearTestData();
    }
    
    @After
    public void tearDown() throws Exception {
        clearTestData();
        if (testConnection != null) {
            testConnection.close();
        }
    }
    
    private void clearTestData() throws SQLException {
        String clearQuery = "DELETE FROM students WHERE email LIKE '%test%'";
        try (Statement stmt = testConnection.createStatement()) {
            stmt.execute(clearQuery);
        }
    }
    
    // Test: Register a new student
    @Test
    public void testRegisterNewStudent() {
        Student student = new Student();
        student.setName("Test Student");
        student.setEmail("test@college.com");
        student.setPassword("hashedPassword123");
        student.setCgpa(8.5);
        student.setBranch("Computer Science");
        student.setEnrollmentNo("2021CS1000");
        
        boolean result = studentDAO.register(student);
        
        assertTrue("Student registration should succeed", result);
        
        // Verify student was added
        Student retrieved = studentDAO.login("test@college.com", "hashedPassword123");
        assertNotNull("Student should be retrievable after registration", retrieved);
        assertEquals("Retrieved student should have correct name", "Test Student", retrieved.getName());
    }
    
    // Test: Duplicate email registration
    @Test
    public void testRegisterDuplicateEmail() {
        Student student1 = createTestStudent("dup@college.com", "2021CS1001");
        Student student2 = createTestStudent("dup@college.com", "2021CS1002");
        
        studentDAO.register(student1);
        boolean result = studentDAO.register(student2);
        
        assertFalse("Duplicate email registration should fail", result);
    }
    
    // Test: Login with valid credentials
    @Test
    public void testLoginSuccess() {
        Student student = createTestStudent("login@college.com", "2021CS1003");
        studentDAO.register(student);
        
        Student loggedIn = studentDAO.login("login@college.com", "hashedPassword123");
        
        assertNotNull("Login should return student object", loggedIn);
        assertEquals("Retrieved student ID should match", student.getId(), loggedIn.getId());
    }
    
    // Test: Login with invalid password
    @Test
    public void testLoginInvalidPassword() {
        Student student = createTestStudent("invalid@college.com", "2021CS1004");
        studentDAO.register(student);
        
        Student loggedIn = studentDAO.login("invalid@college.com", "wrongPassword");
        
        assertNull("Login with wrong password should return null", loggedIn);
    }
    
    // Test: Update student profile
    @Test
    public void testUpdateProfile() {
        Student student = createTestStudent("update@college.com", "2021CS1005");
        studentDAO.register(student);
        
        Student retrieved = studentDAO.login("update@college.com", "hashedPassword123");
        retrieved.setSkills("Java, Python, MySQL");
        retrieved.setContactNumber("9876543210");
        
        studentDAO.updateProfile(retrieved);
        
        Student updated = studentDAO.getStudentById(retrieved.getId());
        assertEquals("Skills should be updated", "Java, Python, MySQL", updated.getSkills());
        assertEquals("Contact number should be updated", "9876543210", updated.getContactNumber());
    }
    
    // Test: Get top students
    @Test
    public void testGetTopStudents() {
        // Create students with different CGPAs
        createAndRegisterStudent("top1@college.com", 9.5, "2021CS1006");
        createAndRegisterStudent("top2@college.com", 9.2, "2021CS1007");
        createAndRegisterStudent("top3@college.com", 8.8, "2021CS1008");
        createAndRegisterStudent("low1@college.com", 6.5, "2021CS1009");
        
        List<Student> topStudents = studentDAO.getTopStudents();
        
        assertEquals("Should retrieve top students", 3, topStudents.size());
        assertEquals("First should have highest CGPA", 9.5, topStudents.get(0).getCgpa(), 0.01);
        assertEquals("Last should have lowest CGPA among top", 8.8, topStudents.get(2).getCgpa(), 0.01);
    }
    
    // Helper methods
    private Student createTestStudent(String email, String enrollmentNo) {
        Student student = new Student();
        student.setName("Test Student");
        student.setEmail(email);
        student.setPassword("hashedPassword123");
        student.setCgpa(8.5);
        student.setBranch("Computer Science");
        student.setEnrollmentNo(enrollmentNo);
        return student;
    }
    
    private void createAndRegisterStudent(String email, double cgpa, String enrollmentNo) {
        Student student = new Student();
        student.setName("Student with CGPA");
        student.setEmail(email);
        student.setPassword("hashedPassword123");
        student.setCgpa(cgpa);
        student.setBranch("Computer Science");
        student.setEnrollmentNo(enrollmentNo);
        studentDAO.register(student);
    }
}
```

### Servlet Unit Tests with Mocking

```java
import org.junit.Test;
import org.junit.Before;
import org.mockito.*;
import jakarta.servlet.http.*;

import static org.mockito.Mockito.*;

public class LoginServletTest {
    
    private LoginServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    
    @Before
    public void setUp() {
        servlet = new LoginServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
    }
    
    @Test
    public void testValidLogin() throws Exception {
        // Setup
        when(request.getParameter("email")).thenReturn("john@college.com");
        when(request.getParameter("password")).thenReturn("john123");
        when(request.getSession()).thenReturn(session);
        
        // Mock DAO
        StudentDAO mockDAO = mock(StudentDAO.class);
        Student mockStudent = new Student();
        mockStudent.setId(1);
        mockStudent.setName("John Doe");
        mockStudent.setEmail("john@college.com");
        
        when(mockDAO.login("john@college.com", "john123")).thenReturn(mockStudent);
        
        // Execute
        servlet.doPost(request, response);
        
        // Verify
        verify(session).setAttribute("student", mockStudent);
        verify(response).sendRedirect("jsp/student/dashboard.jsp");
    }
    
    @Test
    public void testInvalidLogin() throws Exception {
        // Setup
        when(request.getParameter("email")).thenReturn("invalid@college.com");
        when(request.getParameter("password")).thenReturn("wrongpassword");
        
        // Execute
        servlet.doPost(request, response);
        
        // Verify
        verify(response).sendRedirect("jsp/student/login.jsp?error=invalid");
    }
}
```

---

## Integration Testing

### Application Flow Testing

```java
import org.junit.Test;
import org.junit.BeforeClass;

public class StudentApplicationFlowTest {
    
    private static StudentDAO studentDAO;
    private static JobDAO jobDAO;
    private static ApplicationDAO applicationDAO;
    
    @BeforeClass
    public static void setUpClass() {
        studentDAO = new StudentDAOImpl();
        jobDAO = new JobDAOImpl();
        applicationDAO = new ApplicationDAOImpl();
    }
    
    @Test
    public void testCompleteApplicationFlow() {
        // 1. Register a student
        Student student = new Student();
        student.setName("Integration Test Student");
        student.setEmail("integration@college.com");
        student.setPassword("hashedPassword123");
        student.setCgpa(8.5);
        student.setBranch("CS");
        student.setEnrollmentNo("2021CS9999");
        
        boolean registered = studentDAO.register(student);
        assertTrue("Student should be registered", registered);
        
        // 2. Login student
        Student loggedIn = studentDAO.login("integration@college.com", "hashedPassword123");
        assertNotNull("Student should be able to login", loggedIn);
        int studentId = loggedIn.getId();
        
        // 3. Get available jobs
        List<Job> jobs = jobDAO.getAllJobs();
        assertTrue("Should have available jobs", jobs.size() > 0);
        
        Job eligibleJob = jobs.stream()
            .filter(j -> j.getEligibility() <= student.getCgpa())
            .findFirst()
            .orElse(null);
        
        assertNotNull("Should find eligible job", eligibleJob);
        
        // 4. Apply for job
        Application application = new Application();
        application.setStudentId(studentId);
        application.setJobId(eligibleJob.getId());
        application.setStatus("Applied");
        
        boolean applied = applicationDAO.addApplication(application);
        assertTrue("Application should be submitted", applied);
        
        // 5. Verify application status
        List<Application> applications = applicationDAO.getApplicationsByStudent(studentId);
        assertEquals("Student should have 1 application", 1, applications.size());
        assertEquals("Application status should be Applied", "Applied", applications.get(0).getStatus());
        
        // 6. Admin updates status
        applicationDAO.updateApplicationStatus(applications.get(0).getId(), "Selected");
        
        // 7. Verify status update
        List<Application> updatedApplicants = applicationDAO.getApplicationsByStudent(studentId);
        assertEquals("Application should be Selected", "Selected", updatedApplicants.get(0).getStatus());
    }
}
```

---

## Functional Testing

### Manual Test Cases

#### TC-001: Student Registration

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to /register | Registration form displays |
| 2 | Fill name: "John Doe" | Text entered correctly |
| 3 | Fill email: "john@college.com" | Email entered correctly |
| 4 | Fill password: "SecurePass123" | Password masked with dots |
| 5 | Fill CGPA: "8.5" | CGPA entered correctly |
| 6 | Select branch: "Computer Science" | Branch selected |
| 7 | Fill enrollment: "2021CS1001" | Enrollment number entered |
| 8 | Click "Register" | Form submitted |
| **Result** | Redirect to login page | Success message shown |

#### TC-002: Job Application

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login as student | Dashboard loaded with jobs |
| 2 | View job: "Software Engineer" | Job details visible |
| 3 | Check eligibility | Student CGPA shown: 8.5 >= 7.0 ✓ |
| 4 | Click "Apply Now" | Button changes to "Applied" |
| 5 | Navigate away and return | Application status persists |
| **Result** | Application recorded | Job shows "Applied" status |

#### TC-003: Admin Application Review

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login as admin | Admin dashboard displayed |
| 2 | Click "View Applicants" | List of all applications shown |
| 3 | Filter by status: "Applied" | Only "Applied" applications shown |
| 4 | Click student name | Student details modal opens |
| 5 | View resume | PDF opens in new tab |
| 6 | Select "Selected" | Status dropdown changes |
| 7 | Add feedback: "Great candidate" | Feedback entered |
| 8 | Click "Update" | Status updated, email sent to student |
| **Result** | Admin workflow complete | Student receives notification |

### Automated Functional Tests (Selenium)

```java
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class StudentFlowSeleniumTest {
    
    private WebDriver driver;
    private static final String BASE_URL = "http://localhost:8080/placement-portal";
    
    @Before
    public void setUp() {
        System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
        driver = new ChromeDriver();
    }
    
    @After
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
    
    @Test
    public void testStudentLogin() {
        // Navigate to login page
        driver.get(BASE_URL + "/jsp/student/login.jsp");
        
        // Enter credentials
        WebElement emailInput = driver.findElement(By.id("email"));
        WebElement passwordInput = driver.findElement(By.id("password"));
        WebElement loginButton = driver.findElement(By.id("loginBtn"));
        
        emailInput.sendKeys("john@college.com");
        passwordInput.sendKeys("john123");
        loginButton.click();
        
        // Wait for redirect and verify
        WebDriverWait wait = new WebDriverWait(driver, 10);
        wait.until(ExpectedConditions.urlContains("dashboard.jsp"));
        
        // Verify dashboard loaded
        WebElement welcomeMessage = driver.findElement(By.className("welcome-message"));
        assertTrue("Welcome message should be displayed", 
            welcomeMessage.getText().contains("Welcome"));
    }
    
    @Test
    public void testStudentApplyForJob() throws Exception {
        // Login first
        testStudentLogin();
        
        // Find and click Apply button
        WebElement applyButton = driver.findElement(By.id("applyJob-12"));
        applyButton.click();
        
        // Wait for confirmation
        WebDriverWait wait = new WebDriverWait(driver, 10);
        wait.until(ExpectedConditions.presenceOfElementLocated(By.id("successMessage")));
        
        // Verify button changed
        WebElement statusBadge = driver.findElement(By.id("jobStatus-12"));
        assertEquals("Button should show Applied", "Applied", statusBadge.getText());
    }
}
```

---

## Performance Testing

### Load Testing with JMeter

```
Test Plan:
├── Thread Group (50 users, 10 second ramp-up)
│   ├── HTTP Request: GET /placement-portal/index.jsp
│   ├── HTTP Request: POST /login (student login)
│   ├── HTTP Request: GET /jsp/student/dashboard.jsp
│   ├── HTTP Request: GET /jsp/student/profile.jsp
│   └── HTTP Request: POST /apply (job application)
├── Listeners:
│   ├── Results Tree
│   ├── Summary Report
│   └── Response Time Graph
```

### Database Query Performance Testing

```java
import org.junit.Test;

public class PerformanceTest {
    
    @Test
    public void testGetUsersWithApplicationsPerformance() {
        StudentDAO dao = new StudentDAOImpl();
        
        long startTime = System.currentTimeMillis();
        
        // Execute query
        List<Student> topStudents = dao.getTopStudents();
        
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        
        System.out.println("Query executed in: " + duration + "ms");
        assertTrue("Query should complete in < 100ms", duration < 100);
    }
    
    @Test
    public void testApplicationListPerformance() {
        ApplicationDAO dao = new ApplicationDAOImpl();
        int jobId = 1;
        
        long startTime = System.currentTimeMillis();
        
        List<Application> apps = dao.getApplicationsByJob(jobId);
        
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        
        System.out.println("Retrieved " + apps.size() + " applications in " + duration + "ms");
        assertTrue("Should handle 1000+ applications", duration < 500);
    }
}
```

---

## Security Testing

### SQL Injection Testing

```java
import org.junit.Test;

public class SecurityTest {
    
    @Test
    public void testSQLInjectionPrevention() {
        StudentDAO dao = new StudentDAOImpl();
        
        // Try SQL injection
        String maliciousEmail = "' OR '1'='1";
        String password = "anything";
        
        // Should NOT return any student
        Student result = dao.login(maliciousEmail, password);
        assertNull("SQL injection attempt should be prevented", result);
    }
    
    @Test
    public void testPasswordHashing() {
        // Verify passwords are hashed, not stored as plaintext
        // Check database directly
        Student student = getStudentFromDB(1);
        String storedPassword = student.getPassword();
        
        // Should not be plain text
        assertNotEquals("Password should be hashed", "plainPassword", storedPassword);
        // Should be SHA256 hash (64 chars)
        assertEquals("Hash should be 64 chars", 64, storedPassword.length());
    }
    
    @Test
    public void testSessionValidation() {
        // Try accessing protected page without session
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getSession(false)).thenReturn(null);
        
        // Should redirect to login, not grant access
        assertTrue("Should enforce session validation", 
            !hasAccessWithoutSession(request));
    }
    
    @Test
    public void testXSSPrevention() {
        // Try XSS payload in student name
        String xssPayload = "<script>alert('XSS')</script>";
        
        Student student = new Student();
        student.setName(xssPayload);
        student.setEmail("xss@college.com");
        
        StudentDAO dao = new StudentDAOImpl();
        dao.register(student);
        
        // Retrieved should be encoded/escaped
        Student retrieved = dao.getStudentById(student.getId());
        assertNotNull("Record should exist", retrieved);
        // Should not contain raw script tags in output
        assertTrue("XSS should be prevented", 
            retrieved.getName().equals(xssPayload)); // Stored safely, encoded on output
    }
}
```

---

## Test Data

### Sample Test Data

```sql
-- Test Users
INSERT INTO students (name, email, password, cgpa, branch, enrollment_no) VALUES
('John Doe', 'john@college.com', SHA2('john123', 256), 8.5, 'CS', '2021CS1001'),
('Jane Smith', 'jane@college.com', SHA2('jane123', 256), 9.0, 'CS', '2021CS1002'),
('Mike Johnson', 'mike@college.com', SHA2('mike123', 256), 7.5, 'IT', '2021IT1001'),
('Low CGPA Student', 'low@college.com', SHA2('low123', 256), 5.5, 'CS', '2021CS1050');

INSERT INTO admin (email, password, name) VALUES
('admin@college.com', SHA2('admin123', 256), 'College Admin'),
('admin2@college.com', SHA2('admin456', 256), 'Admin Officer');

-- Test data seeding script
sh scripts/seed-test-data.sh
```

### Test Database Setup

```bash
#!/bin/bash
# setup-test-db.sh

# Create test database
mysql -u root -p <<EOF
CREATE DATABASE placement_portal_test CHARACTER SET utf8mb4;
CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'test_password';
GRANT ALL PRIVILEGES ON placement_portal_test.* TO 'test_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Import schema
mysql -u test_user -p placement_portal_test < docs/database_schema.sql

# Seed test data
mysql -u test_user -p placement_portal_test < scripts/test-data.sql

echo "Test database setup complete!"
```

---

## CI/CD Testing

### GitHub Actions Workflow

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: placement_portal_test
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 3306:3306
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up JDK 8
      uses: actions/setup-java@v2
      with:
        java-version: '8'
    
    - name: Build with Maven
      run: mvn clean install
    
    - name: Run unit tests
      run: mvn test
    
    - name: Generate coverage report
      run: mvn jacoco:report
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v2
```

---

## Bug Report Template

### Bug Report Format

```markdown
## Bug Title
[Concise description of the bug]

## Severity
- [ ] Low
- [ ] Medium
- [ ] High
- [ ] Critical

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happened

## Screenshots/Logs
[Attach relevant screenshots or error logs]

## Environment
- Browser: Chrome 100.0
- OS: Windows 10
- Java Version: 1.8.0_291
- Tomcat Version: 10.0.27

## Additional Context
Any additional information about the bug
```

### Example Bug Report

```markdown
## Student cannot apply for job if CGPA is exactly at eligibility

## Severity
- [ ] Low
- [x] Medium
- [ ] High
- [ ] Critical

## Steps to Reproduce
1. Login as student with CGPA 7.0
2. View job posting with eligibility 7.0
3. Click "Apply Now" button
4. Job validation fails

## Expected Behavior
Student with CGPA exactly matching eligibility should be able to apply

## Actual Behavior
Error message: "CGPA below eligibility for this job"

## Root Cause
Comparison uses > instead of >= in ApplyServlet.java line 42:
```java
if (student.getCgpa() > job.getEligibility()) {  // Should be >=
```

## Fix
```java
if (student.getCgpa() >= job.getEligibility()) {  // ✓ Fixed
```
```

---

## Test Metrics

### Target Code Coverage

```
Overall: >= 80%
├── Controller: >= 70%
├── DAO: >= 85%
├── Model: >= 90%
├── Util: >= 85%
└── View: >= 50% (harder to test JSP)
```

### Quality Gates

```
Build fails if:
- Coverage drops below 80%
- New warnings introduced
- Tests fail
- Code smells increase

Build succeeds if:
- All tests pass
- Coverage maintained/improved
- No critical/blocker issues
```

---

