# 🚀 Deployment Guide

Complete guide for deploying the Ignite Placement Portal to production environments.

## Table of Contents
- [Local Development Setup](#local-development-setup)
- [Production Checklist](#production-checklist)
- [AWS Deployment](#aws-deployment)
- [DigitalOcean Deployment](#digitalocean-deployment)
- [Docker Deployment](#docker-deployment)
- [Tomcat Configuration](#tomcat-configuration)
- [MySQL Optimization](#mysql-optimization)
- [Security Hardening](#security-hardening)
- [Monitoring & Logging](#monitoring--logging)
- [Troubleshooting](#troubleshooting)

---

## Local Development Setup

### Prerequisites

```bash
# Check Java installation
java -version
# Output: java version "1.8.0_291"

# Check Maven installation
mvn -version
# Output: Apache Maven 3.6.3

# Check MySQL installation
mysql --version
# Output: Ver 8.0.25
```

### Setup Steps

#### 1. Clone Repository

```bash
git clone https://github.com/your-org/placement-portal.git
cd placement-portal
```

#### 2. Create Database

```bash
# Connect to MySQL
mysql -u root -p

# Create database
CREATE DATABASE placement_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Create user
CREATE USER 'placement_user'@'localhost' IDENTIFIED BY 'SecurePassword123!';

# Grant privileges
GRANT ALL PRIVILEGES ON placement_portal.* TO 'placement_user'@'localhost';
FLUSH PRIVILEGES;

# Exit MySQL
EXIT;
```

#### 3. Configure Database Connection

Edit `src/main/java/com/placement/util/DBConnection.java`:

```java
public class DBConnection {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_portal";
    private static final String DB_USER = "placement_user";
    private static final String DB_PASSWORD = "SecurePassword123!";
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new SQLException("Unable to connect to database");
        }
    }
}
```

#### 4. Initialize Database Schema

```bash
# No SQL script provided yet, create tables manually or use:
mysql -u placement_user -p placement_portal < docs/database_schema.sql
```

#### 5. Configure Tomcat (IntelliJ)

1. Go to `Run` → `Edit Configurations`
2. Click `+` → `Tomcat Server` → `Local`
3. Click `Configure` and select Tomcat installation path
4. Application server: Select configured Tomcat
5. Check "On Update action" → "Redeploy"
6. Click OK

#### 6. Build and Run

```bash
# Build project
mvn clean install

# Run on Tomcat via IDE (Shift + F10 in IntelliJ)
# Access at http://localhost:8080/placement-portal
```

---

## Production Checklist

Before deploying to production:

- [ ] Database credentials changed from defaults
- [ ] Email configuration verified (SMTP settings)
- [ ] File upload directories have proper permissions
- [ ] HTTPS/SSL certificates installed
- [ ] Database backups configured
- [ ] Logging configured to appropriate level
- [ ] Session timeout set appropriately
- [ ] Error pages customized (no stack traces exposed)
- [ ] Admin accounts created and secured
- [ ] Load balancer configured (if applicable)
- [ ] CDN configured for static assets (optional)
- [ ] Firewall rules configured
- [ ] DDoS protection enabled (if on cloud)
- [ ] Monitoring and alerts configured
- [ ] Disaster recovery plan in place

---

## AWS Deployment

### Architecture

```
                    ┌─────────────────┐
                    │   Route 53      │
                    │  (DNS)          │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ CloudFront CDN  │
                    │ (Static Assets) │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Application     │
                    │ Load Balancer   │
                    └────┬────────┬───┘
                         │        │
        ┌────────────────┘        └──────────────────┐
        │                                            │
    ┌───▼──────┐                                 ┌───▼──────┐
    │ Tomcat   │                                 │ Tomcat   │
    │ Instance │   (Auto Scaling Group)          │ Instance │
    │ A        │                                 │ B        │
    └───┬──────┘                                 └──────┬───┘
        │                                              │
        └──────────────────┬───────────────────────────┘
                           │
                    ┌──────▼──────┐
                    │ RDS MySQL   │
                    │ (Multi-AZ)  │
                    └─────────────┘
```

### Step-by-Step AWS Deployment

#### 1. Create EC2 Instances

```bash
# Launch EC2 instance with Ubuntu 20.04
# Instance type: t3.medium (2 vCPU, 4GB RAM)
# Security group: Allow HTTP(80), HTTPS(443), SSH(22)

# Connect to instance
ssh -i placement-portal.pem ec2-user@your-instance-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install OpenJDK 8
sudo apt install openjdk-8-jdk-headless -y

# Install Tomcat 10
cd /opt
sudo wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.tar.gz
sudo tar -xzf apache-tomcat-10.0.27.tar.gz
sudo mv apache-tomcat-10.0.27 tomcat
sudo chown -R tomcat:tomcat tomcat/

# Start Tomcat
/opt/tomcat/bin/startup.sh
```

#### 2. Create RDS MySQL Instance

```bash
# Via AWS Console:
# 1. Services → RDS → Databases → Create database
# 2. Engine: MySQL 8.0.25
# 3. DB instance class: db.t3.micro (free tier eligible)
# 4. Storage: 20 GB GP2
# 5. Multi-AZ: Yes (for production)
# 6. Database name: placement_portal
# 7. Master username: admin
# 8. Auto backup: 30 days
# 9. Encryption: Enabled
```

#### 3. Deploy Application

```bash
# Build on local machine
mvn clean package

# Transfer WAR to EC2 instance
scp -i placement-portal.pem target/placement-portal.war \
    ec2-user@your-instance-ip:/opt/tomcat/webapps/

# Connect and restart Tomcat
ssh -i placement-portal.pem ec2-user@your-instance-ip
/opt/tomcat/bin/shutdown.sh
/opt/tomcat/bin/startup.sh
```

#### 4. Configure Application Load Balancer

```bash
# Via AWS Console:
# 1. EC2 → Load Balancers → Create Load Balancer
# 2. Type: Application Load Balancer
# 3. Port: 80 (HTTP) and 443 (HTTPS with SSL certificate)
# 4. Target group: EC2 instances running Tomcat
# 5. Health check: /placement-portal/index.jsp
# 6. Stickiness: Enable (for session management)
```

#### 5. Setup Auto Scaling

```bash
# Via AWS Console:
# 1. EC2 → Auto Scaling Groups → Create Auto Scaling Group
# 2. Launch template: Based on configured EC2 instance
# 3. Min size: 2, Desired: 3, Max: 6
# 4. Scaling policy: Target tracking (CPU 70%)
# 5. Load balancer: Application Load Balancer
```

#### 6. Configure SSL Certificate (AWS Certificate Manager)

```bash
# Via AWS Console:
# 1. Certificate Manager → Request certificate
# 2. Domain name: yourdomain.com
# 3. DNS validation
# 4. Attach to Load Balancer
# 5. Redirect HTTP to HTTPS
```

#### 7. Setup S3 for File Uploads (Optional)

```bash
# Create S3 bucket for resumes and profile pictures
aws s3api create-bucket \
    --bucket placement-portal-uploads \
    --region us-east-1 \
    --acl private

# Update application to use S3 SDK
```

#### 8. Configure CloudWatch Monitoring

```bash
# Via AWS Console or CLI
aws cloudwatch put-metric-alarm \
    --alarm-name placement-portal-cpu \
    --alarm-description "Alert when CPU > 80%" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold
```

---

## DigitalOcean Deployment

### Architecture

```
                    ┌──────────────────┐
                    │  DigitalOcean    │
                    │  DNS (Domains)   │
                    └────────┬─────────┘
                             │
                    ┌────────▼────────┐
                    │ DigitalOcean    │
                    │ App Platform    │
                    │ (Droplet)       │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Tomcat Server   │
                    │ + Java App      │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Managed MySQL   │
                    │ Database        │
                    └─────────────────┘
```

### Step-by-Step Deployment

#### 1. Create Droplet

```bash
# Via DigitalOcean Console:
# 1. Create → Droplets
# 2. Image: Ubuntu 20.04 LTS
# 3. Size: $12/month (2GB RAM, 2 vCPU)
# 4. Region: Choose closest to users
# 5. Add SSH key
# 6. Create Droplet

# Connect via SSH
ssh root@your-droplet-ip
```

#### 2. Initial Server Setup

```bash
# Create non-root user
adduser placement_user
usermod -aG sudo placement_user

# Install necessary packages
apt update && apt upgrade -y
apt install openjdk-8-jdk-headless mysql-client wget unzip -y

# Setup firewall
ufw enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

# Install Tomcat
cd /opt
wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.tar.gz
tar -xzf apache-tomcat-10.0.27.tar.gz
mv apache-tomcat-10.0.27 tomcat
chown -R placement_user:placement_user tomcat/
chmod +x tomcat/bin/startup.sh tomcat/bin/shutdown.sh
```

#### 3. Setup Managed MySQL Database

```bash
# Via DigitalOcean Console:
# 1. Create → Databases → MySQL
# 2. Version: 8
# 3. Cluster configuration: Single node ($15/month)
# 4. Region: Same as Droplet
# 5. Create database cluster

# In DigitalOcean Console:
# 1. Connections → Databases
# 2. Create new database: placement_portal
# 3. Note connection string
```

#### 4. Configure and Deploy Application

```bash
# Update DBConnection.java with managed database credentials
# build locally, then transfer WAR

scp target/placement-portal.war root@your-droplet-ip:/opt/tomcat/webapps/

# On droplet
sudo /opt/tomcat/bin/startup.sh

# Verify
curl http://localhost:8080/placement-portal/
```

#### 5. Setup SSL with Let's Encrypt

```bash
# Install Certbot
apt install certbot python3-certbot-apache -y

# Get certificate
certbot certonly --standalone -d yourdomain.com

# Configure Tomcat for HTTPS (edit conf/server.xml)
# Add connector on port 443 with SSL certificate

# Restart Tomcat
/opt/tomcat/bin/shutdown.sh
/opt/tomcat/bin/startup.sh
```

#### 6. Configure Domain Name

```bash
# Via DigitalOcean Domains:
# 1. Create domain pointing to droplet
# 2. Add DNS records
# 3. A record: yourdomain.com → droplet IP
# 4. CNAME: www.yourdomain.com → yourdomain.com
```

#### 7. Setup Monitoring

```bash
# DigitalOcean Monitoring (enable in Console)
# Monitor CPU, Memory, Disk I/O, Bandwidth

# Setup Alerts
# Alert when CPU > 80% for 5 minutes
```

---

## Docker Deployment

### Dockerfile

```dockerfile
FROM openjdk:8-jdk-slim

# Install Tomcat
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN cd /opt && \
    wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.tar.gz && \
    tar -xzf apache-tomcat-10.0.27.tar.gz && \
    mv apache-tomcat-10.0.27 tomcat && \
    rm apache-tomcat-10.0.27.tar.gz

# Copy application WAR
COPY target/placement-portal.war /opt/tomcat/webapps/

# Expose ports
EXPOSE 8080 8443

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
```

### Docker Compose

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: placement-mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: placement_portal
      MYSQL_USER: placement_user
      MYSQL_PASSWORD: userpassword
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - placement_network

  tomcat:
    build: .
    container_name: placement-tomcat
    environment:
      DB_HOST: mysql
      DB_PORT: 3306
      DB_NAME: placement_portal
      DB_USER: placement_user
      DB_PASSWORD: userpassword
    ports:
      - "8080:8080"
      - "8443:8443"
    depends_on:
      - mysql
    networks:
      - placement_network
    volumes:
      - ./uploads:/opt/tomcat/webapps/placement-portal/uploads

volumes:
  mysql_data:

networks:
  placement_network:
    driver: bridge
```

### Build and Run Docker

```bash
# Build image
docker build -t placement-portal:1.0 .

# Run container
docker run -d -p 8080:8080 \
  -e DB_HOST=mysql \
  -e DB_USER=placement_user \
  -e DB_PASSWORD=userpassword \
  --name placement-app \
  placement-portal:1.0

# Using Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f tomcat

# Stop
docker-compose down
```

---

## Tomcat Configuration

### catalina.sh (startup options)

```bash
# Set Java heap size
export CATALINA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"

# Enable debugging
export CATALINA_DEBUG_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000"
```

### server.xml Configuration

```xml
<Server port="8005" shutdown="SHUTDOWN">
  
  <!-- Define Connector ports -->
  <Service name="Catalina">
    
    <!-- HTTP Connector -->
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" 
               maxThreads="150"
               minSpareThreads="25"
               maxSpareThreads="75"
               enableLookups="false"
               acceptCount="100"
               compression="on"
               compressionMinSize="2048"/>
    
    <!-- HTTPS Connector -->
    <Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
               maxThreads="150" SSLEnabled="true">
      <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/keystore.jks"
                     certificateKeystorePassword="password"
                     type="RSA" />
      </SSLHostConfig>
    </Connector>
    
    <!-- AJP Connector (for load balancer) -->
    <Connector port="8009" protocol="AJP/1.3"
               redirectPort="8443"
               connectionTimeout="20000"
               maxThreads="150" />
    
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve"
               directory="logs"
               prefix="localhost_access_log"
               suffix=".txt"
               pattern="%h %l %u %t "%r" %s %b" />
      </Host>
    </Engine>
  </Service>
</Server>
```

### context.xml Configuration

```xml
<Context useHttpOnly="true" sessionCookieSecure="true">
  
  <!-- Database Connection Pool -->
  <Resource name="jdbc/PlacementDB"
            auth="Container"
            type="javax.sql.DataSource"
            driverClassName="com.mysql.cj.jdbc.Driver"
            url="jdbc:mysql://db:3306/placement_portal?useSSL=false&serverTimezone=UTC"
            username="placement_user"
            password="userpassword"
            maxActive="20"
            maxIdle="10"
            maxWait="30000"
            testOnBorrow="true"
            testOnReturn="false"
            validationQuery="SELECT 1"
            validationInterval="30000" />
  
  <!-- Session Manager with Persistence -->
  <SessionCookiePath value="/" />
  <SessionCookieHttpOnly="true" />
  
</Context>
```

---

## MySQL Optimization

### Production MySQL Configuration (my.cnf)

```ini
[mysqld]
# Performance tuning
max_connections = 1000
max_allowed_packet = 64M
thread_stack = 192K
thread_cache_size = 8
myisam-recover-options = BACKUP
query_cache_limit = 1M
query_cache_size = 16M

# InnoDB settings
default-storage-engine = InnoDB
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT

# Binary logging for replication/backup
server-id = 1
log-bin = mysql-bin
binlog_format = ROW
max-binlog-size = 100M
expire-logs-days = 10

# Slow query logging
slow-query-log = 1
slow-query-log-file = /var/log/mysql/slow.log
long-query-time = 2
```

### Database Replication

```sql
-- On Master server
CHANGE MASTER TO
  MASTER_HOST = 'master-server',
  MASTER_USER = 'replication_user',
  MASTER_PASSWORD = 'password',
  MASTER_LOG_FILE = 'mysql-bin.000001',
  MASTER_LOG_POS = 154;

START SLAVE;
SHOW SLAVE STATUS;
```

---

## Security Hardening

### 1. Update Tomcat

```bash
# Regular updates
apt update && apt upgrade -y

# Specific Tomcat updates
cd /opt/tomcat
bin/shutdown.sh
# Backup current installation
cp -r /opt/tomcat /opt/tomcat.backup
# Download and extract new version
# Copy conf and webapps from backup
bin/startup.sh
```

### 2. Secure Tomcat

```bash
# Remove default applications
rm -rf /opt/tomcat/webapps/examples
rm -rf /opt/tomcat/webapps/docs
rm -rf /opt/tomcat/webapps/manager
rm -rf /opt/tomcat/webapps/host-manager

# Remove server information headers
# Edit /opt/tomcat/bin/catalina.sh
# Add: CATALINA_OPTS="$CATALINA_OPTS -Dorg.apache.catalina.connector.Response.ENFORCE_ENCODING_IN_GET_WRITER=true"
```

### 3. Firewall Configuration

```bash
# UFW (Ubuntu Firewall)
ufw enable
ufw allow 22/tcp      # SSH
ufw allow 80/tcp      # HTTP
ufw allow 443/tcp     # HTTPS
ufw deny 8080/tcp     # Block direct access to Tomcat
ufw deny 3306/tcp     # Block direct MySQL access

# Check status
ufw status
```

### 4. SSL/TLS Configuration

```bash
# Generate SSL certificate (Let's Encrypt)
certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Convert to PKCS12 format for Tomcat
openssl pkcs12 -export -in /etc/letsencrypt/live/yourdomain.com/fullchain.pem \
  -inkey /etc/letsencrypt/live/yourdomain.com/privkey.pem \
  -out /opt/tomcat/conf/keystore.p12 \
  -name tomcat -CAfile /etc/letsencrypt/live/yourdomain.com/cert.pem \
  -caname root -password pass:password

# Enable HTTPS in server.xml
```

### 5. Application Security

```java
// In web.xml
<security-constraint>
  <web-resource-collection>
    <url-pattern>/*</url-pattern>
  </web-resource-collection>
  <user-data-constraint>
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
  </user-data-constraint>
</security-constraint>

// Session security
<session-config>
  <secure>true</secure>
  <http-only>true</http-only>
  <tracking-mode>COOKIE</tracking-mode>
</session-config>
```

---

## Monitoring & Logging

### Application Logging Configuration

```properties
# log4j.properties
log4j.rootLogger=INFO, FILE, CONSOLE

log4j.appender.FILE=org.apache.log4j.RollingFileAppender
log4j.appender.FILE.File=/var/log/placement-portal/app.log
log4j.appender.FILE.MaxFileSize=10MB
log4j.appender.FILE.MaxBackupIndex=10
log4j.appender.FILE.layout=org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n

log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
log4j.appender.CONSOLE.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n

# Application specific
log4j.logger.com.placement=DEBUG
```

### Tomcat Access Logs

```xml
<Valve className="org.apache.catalina.valves.AccessLogValve"
       directory="logs"
       prefix="placement_access"
       suffix=".txt"
       pattern="%h %l %u %t "%r" %s %b %D %{User-Agent}i" />
```

### Health Check Endpoint

```java
@WebServlet("/health")
public class HealthCheckServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                response.getWriter().write("{\"status\": \"UP\", \"database\": \"connected\"}");
                response.setStatus(HttpServletResponse.SC_OK);
                conn.close();
            }
        } catch (Exception e) {
            response.getWriter().write("{\"status\": \"DOWN\", \"error\": \"" + e.getMessage() + "\"}");
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        }
    }
}
```

---

## Troubleshooting

### Application Won't Start

```bash
# Check Tomcat logs
tail -f /opt/tomcat/logs/catalina.out

# Check MySQL connection
mysql -h localhost -u placement_user -p -D placement_portal -e "SELECT 1"

# Check Java version
java -version

# Check port availability
netstat -tulpn | grep 8080
```

### High Memory Usage

```bash
# Monitor Tomcat memory
jps -v

# Analyze heap dump
jmap -heap <pid>

# Adjust JVM options in catalina.sh
export CATALINA_OPTS="-Xms256m -Xmx512m"
```

### Database Connection Issues

```bash
# Verify credentials
mysql -h localhost -u placement_user -p -D placement_portal

# Check connection pool
SELECT * FROM information_schema.processlist;

# Increase max_connections in my.cnf
max_connections = 1000
```

### SSL Certificate Issues

```bash
# Check certificate expiry
openssl x509 -in /path/to/cert.pem -text -noout

# Renew Let's Encrypt certificate
certbot renew

# Setup auto-renewal
crontab -e
# Add: 0 3 * * * /usr/bin/certbot renew --quiet
```

---

## Rollback Procedure

In case of failed deployment:

```bash
# Stop current Tomcat
/opt/tomcat/bin/shutdown.sh

# Restore from backup
rm /opt/tomcat/webapps/placement-portal.war
cp /opt/backups/placement-portal-backup.war /opt/tomcat/webapps/

# Restart
/opt/tomcat/bin/startup.sh

# Verify
curl http://localhost:8080/placement-portal/
```

---

## Conclusion

This guide covers deployment for various platforms. Choose the platform that best fits your requirements:

- **AWS**: Best for scalability and managed services
- **DigitalOcean**: Best for simplicity and cost-effectiveness
- **Docker**: Best for containerization and consistency
- **On-Premises**: Best for complete control

For production, always ensure proper monitoring, backup, and security measures are in place.
