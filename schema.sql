-- ============================================================
-- Online Job Recruitment & Application Management System
-- Database Schema - MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS job_recruitment;
USE job_recruitment;

-- ============================================================
-- TABLE: Candidates
-- ============================================================
CREATE TABLE IF NOT EXISTS Candidate (
    candidate_id    INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    date_of_birth   DATE,
    gender          ENUM('Male','Female','Other'),
    address         TEXT,
    resume_url      VARCHAR(300),
    profile_summary TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: Companies
-- ============================================================
CREATE TABLE IF NOT EXISTS Company (
    company_id      INT AUTO_INCREMENT PRIMARY KEY,
    company_name    VARCHAR(150) NOT NULL,
    industry        VARCHAR(100),
    website         VARCHAR(200),
    email           VARCHAR(150) UNIQUE,
    phone           VARCHAR(20),
    address         TEXT,
    description     TEXT,
    founded_year    YEAR,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: Skills (master list)
-- ============================================================
CREATE TABLE IF NOT EXISTS Skill (
    skill_id    INT AUTO_INCREMENT PRIMARY KEY,
    skill_name  VARCHAR(100) NOT NULL UNIQUE,
    category    VARCHAR(80)
);

-- ============================================================
-- TABLE: Candidate_Skills (bridge)
-- ============================================================
CREATE TABLE IF NOT EXISTS Candidate_Skill (
    candidate_id    INT NOT NULL,
    skill_id        INT NOT NULL,
    proficiency     ENUM('Beginner','Intermediate','Advanced','Expert') DEFAULT 'Intermediate',
    years_exp       DECIMAL(4,1),
    PRIMARY KEY (candidate_id, skill_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidate(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id)     REFERENCES Skill(skill_id)         ON DELETE CASCADE
);

-- ============================================================
-- TABLE: Job_Posting
-- ============================================================
CREATE TABLE IF NOT EXISTS Job_Posting (
    job_id          INT AUTO_INCREMENT PRIMARY KEY,
    company_id      INT NOT NULL,
    title           VARCHAR(150) NOT NULL,
    description     TEXT,
    requirements    TEXT,
    location        VARCHAR(150),
    job_type        ENUM('Full-Time','Part-Time','Contract','Internship','Remote') DEFAULT 'Full-Time',
    salary_min      DECIMAL(12,2),
    salary_max      DECIMAL(12,2),
    vacancies       INT DEFAULT 1,
    deadline        DATE,
    status          ENUM('Open','Closed','On-Hold') DEFAULT 'Open',
    posted_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: Application
-- ============================================================
CREATE TABLE IF NOT EXISTS Application (
    application_id  INT AUTO_INCREMENT PRIMARY KEY,
    job_id          INT NOT NULL,
    candidate_id    INT NOT NULL,
    cover_letter    TEXT,
    applied_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('Pending','Reviewed','Shortlisted','Rejected','Hired') DEFAULT 'Pending',
    UNIQUE KEY uq_app (job_id, candidate_id),
    FOREIGN KEY (job_id)         REFERENCES Job_Posting(job_id)   ON DELETE CASCADE,
    FOREIGN KEY (candidate_id)   REFERENCES Candidate(candidate_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: Interview
-- ============================================================
CREATE TABLE IF NOT EXISTS Interview (
    interview_id    INT AUTO_INCREMENT PRIMARY KEY,
    application_id  INT NOT NULL,
    scheduled_at    DATETIME NOT NULL,
    mode            ENUM('In-Person','Video','Phone') DEFAULT 'Video',
    interviewer     VARCHAR(150),
    venue           VARCHAR(200),
    notes           TEXT,
    outcome         ENUM('Pending','Passed','Failed','No-Show') DEFAULT 'Pending',
    FOREIGN KEY (application_id) REFERENCES Application(application_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: Offer
-- ============================================================
CREATE TABLE IF NOT EXISTS Offer (
    offer_id        INT AUTO_INCREMENT PRIMARY KEY,
    application_id  INT NOT NULL UNIQUE,
    offered_salary  DECIMAL(12,2),
    joining_date    DATE,
    offer_letter    TEXT,
    status          ENUM('Pending','Accepted','Declined','Revoked') DEFAULT 'Pending',
    offered_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at    TIMESTAMP NULL,
    FOREIGN KEY (application_id) REFERENCES Application(application_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: Audit_Log (extra feature — tracks all changes)
-- ============================================================
CREATE TABLE IF NOT EXISTS Audit_Log (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    table_name  VARCHAR(80),
    action      ENUM('INSERT','UPDATE','DELETE'),
    record_id   INT,
    changed_by  VARCHAR(100) DEFAULT 'system',
    changed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details     TEXT
);

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX idx_job_status      ON Job_Posting(status);
CREATE INDEX idx_job_company     ON Job_Posting(company_id);
CREATE INDEX idx_app_status      ON Application(status);
CREATE INDEX idx_app_candidate   ON Application(candidate_id);
CREATE INDEX idx_interview_app   ON Interview(application_id);
CREATE INDEX idx_offer_app       ON Offer(application_id);
