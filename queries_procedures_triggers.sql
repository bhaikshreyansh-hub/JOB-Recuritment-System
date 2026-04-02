-- ============================================================
-- SQL Queries: Basic, Complex, Procedures, Triggers
-- Online Job Recruitment & Application Management System
-- ============================================================
USE job_recruitment;

-- ============================================================
-- SECTION 1: BASIC QUERIES
-- ============================================================

-- 1. List all open job postings
SELECT j.job_id, j.title, c.company_name, j.location, j.job_type,
       j.salary_min, j.salary_max, j.vacancies, j.deadline
FROM Job_Posting j
JOIN Company c ON j.company_id = c.company_id
WHERE j.status = 'Open'
ORDER BY j.posted_at DESC;

-- 2. Get all candidates with their skills
SELECT c.candidate_id, c.full_name, c.email,
       GROUP_CONCAT(s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS skills
FROM Candidate c
LEFT JOIN Candidate_Skill cs ON c.candidate_id = cs.candidate_id
LEFT JOIN Skill s ON cs.skill_id = s.skill_id
GROUP BY c.candidate_id;

-- 3. All applications with status
SELECT a.application_id, c.full_name AS candidate, j.title AS job,
       co.company_name, a.status, a.applied_at
FROM Application a
JOIN Candidate c ON a.candidate_id = c.candidate_id
JOIN Job_Posting j ON a.job_id = j.job_id
JOIN Company co ON j.company_id = co.company_id
ORDER BY a.applied_at DESC;

-- 4. Upcoming interviews
SELECT i.interview_id, c.full_name AS candidate, j.title AS job,
       i.scheduled_at, i.mode, i.interviewer, i.outcome
FROM Interview i
JOIN Application a ON i.application_id = a.application_id
JOIN Candidate c ON a.candidate_id = c.candidate_id
JOIN Job_Posting j ON a.job_id = j.job_id
ORDER BY i.scheduled_at ASC;

-- 5. All job offers
SELECT o.offer_id, c.full_name AS candidate, j.title AS job,
       co.company_name, o.offered_salary, o.joining_date, o.status
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Candidate c ON a.candidate_id = c.candidate_id
JOIN Job_Posting j ON a.job_id = j.job_id
JOIN Company co ON j.company_id = co.company_id;

-- ============================================================
-- SECTION 2: COMPLEX QUERIES
-- ============================================================

-- 6. Top companies by number of open job postings
SELECT c.company_name, COUNT(j.job_id) AS open_jobs
FROM Company c
JOIN Job_Posting j ON c.company_id = j.company_id
WHERE j.status = 'Open'
GROUP BY c.company_id
ORDER BY open_jobs DESC;

-- 7. Candidates who applied for more than 1 job
SELECT c.candidate_id, c.full_name, COUNT(a.application_id) AS total_applications
FROM Candidate c
JOIN Application a ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id
HAVING total_applications > 1
ORDER BY total_applications DESC;

-- 8. Application funnel: count by status per company
SELECT co.company_name, a.status, COUNT(*) AS count
FROM Application a
JOIN Job_Posting j ON a.job_id = j.job_id
JOIN Company co ON j.company_id = co.company_id
GROUP BY co.company_name, a.status
ORDER BY co.company_name, a.status;

-- 9. Candidates shortlisted but not yet interviewed
SELECT c.full_name, j.title, co.company_name, a.status
FROM Application a
JOIN Candidate c ON a.candidate_id = c.candidate_id
JOIN Job_Posting j ON a.job_id = j.job_id
JOIN Company co ON j.company_id = co.company_id
WHERE a.status = 'Shortlisted'
  AND a.application_id NOT IN (SELECT application_id FROM Interview);

-- 10. Average offered salary by company
SELECT co.company_name, AVG(o.offered_salary) AS avg_offer_salary
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Job_Posting j ON a.job_id = j.job_id
JOIN Company co ON j.company_id = co.company_id
GROUP BY co.company_id;

-- 11. Jobs expiring within next 7 days
SELECT j.title, c.company_name, j.deadline,
       DATEDIFF(j.deadline, CURDATE()) AS days_remaining
FROM Job_Posting j
JOIN Company c ON j.company_id = c.company_id
WHERE j.status = 'Open'
  AND j.deadline BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);

-- 12. Candidate skill match for a specific job (job_id=1)
SELECT c.full_name,
       COUNT(DISTINCT cs.skill_id) AS matched_skills,
       GROUP_CONCAT(s.skill_name SEPARATOR ', ') AS skills
FROM Candidate c
JOIN Candidate_Skill cs ON c.candidate_id = cs.candidate_id
JOIN Skill s ON cs.skill_id = s.skill_id
WHERE cs.skill_id IN (
    -- Subquery: skills mentioned in job requirements (illustrative)
    SELECT skill_id FROM Skill WHERE skill_name IN ('React','Node.js','Git')
)
GROUP BY c.candidate_id
ORDER BY matched_skills DESC;

-- ============================================================
-- SECTION 3: STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- Procedure 1: Apply for a job
DROP PROCEDURE IF EXISTS sp_apply_job $$
CREATE PROCEDURE sp_apply_job(
    IN p_job_id      INT,
    IN p_candidate_id INT,
    IN p_cover_letter TEXT
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_status VARCHAR(20);

    -- Check if job is open
    SELECT status INTO v_status FROM Job_Posting WHERE job_id = p_job_id;

    IF v_status != 'Open' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'This job is not currently open for applications.';
    END IF;

    -- Check duplicate application
    SELECT COUNT(*) INTO v_count
    FROM Application
    WHERE job_id = p_job_id AND candidate_id = p_candidate_id;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Candidate has already applied for this job.';
    END IF;

    INSERT INTO Application (job_id, candidate_id, cover_letter, status)
    VALUES (p_job_id, p_candidate_id, p_cover_letter, 'Pending');

    SELECT LAST_INSERT_ID() AS new_application_id, 'Application submitted successfully.' AS message;
END $$

-- Procedure 2: Update application status
DROP PROCEDURE IF EXISTS sp_update_application_status $$
CREATE PROCEDURE sp_update_application_status(
    IN p_application_id INT,
    IN p_new_status     ENUM('Pending','Reviewed','Shortlisted','Rejected','Hired')
)
BEGIN
    UPDATE Application SET status = p_new_status WHERE application_id = p_application_id;
    SELECT ROW_COUNT() AS rows_updated, 'Status updated.' AS message;
END $$

-- Procedure 3: Schedule an interview
DROP PROCEDURE IF EXISTS sp_schedule_interview $$
CREATE PROCEDURE sp_schedule_interview(
    IN p_application_id INT,
    IN p_scheduled_at   DATETIME,
    IN p_mode           ENUM('In-Person','Video','Phone'),
    IN p_interviewer    VARCHAR(150),
    IN p_venue          VARCHAR(200)
)
BEGIN
    INSERT INTO Interview (application_id, scheduled_at, mode, interviewer, venue)
    VALUES (p_application_id, p_scheduled_at, p_mode, p_interviewer, p_venue);

    -- Auto shortlist the application
    UPDATE Application SET status = 'Shortlisted' WHERE application_id = p_application_id;

    SELECT LAST_INSERT_ID() AS new_interview_id, 'Interview scheduled successfully.' AS message;
END $$

-- Procedure 4: Generate recruitment summary report
DROP PROCEDURE IF EXISTS sp_recruitment_report $$
CREATE PROCEDURE sp_recruitment_report()
BEGIN
    SELECT
        co.company_name,
        COUNT(DISTINCT j.job_id)          AS total_jobs,
        COUNT(DISTINCT a.application_id)  AS total_applications,
        SUM(a.status = 'Shortlisted')     AS shortlisted,
        SUM(a.status = 'Hired')           AS hired,
        SUM(a.status = 'Rejected')        AS rejected
    FROM Company co
    LEFT JOIN Job_Posting j ON co.company_id = j.company_id
    LEFT JOIN Application a ON j.job_id = a.job_id
    GROUP BY co.company_id
    ORDER BY total_applications DESC;
END $$

-- Procedure 5: Make an offer
DROP PROCEDURE IF EXISTS sp_make_offer $$
CREATE PROCEDURE sp_make_offer(
    IN p_application_id INT,
    IN p_salary         DECIMAL(12,2),
    IN p_joining_date   DATE,
    IN p_letter         TEXT
)
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM Offer WHERE application_id = p_application_id;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Offer already exists for this application.';
    END IF;

    INSERT INTO Offer (application_id, offered_salary, joining_date, offer_letter)
    VALUES (p_application_id, p_salary, p_joining_date, p_letter);

    UPDATE Application SET status = 'Hired' WHERE application_id = p_application_id;

    SELECT LAST_INSERT_ID() AS new_offer_id, 'Offer created successfully.' AS message;
END $$

DELIMITER ;

-- ============================================================
-- SECTION 4: TRIGGERS
-- ============================================================

DELIMITER $$

-- Trigger 1: Log new application inserts
DROP TRIGGER IF EXISTS trg_after_application_insert $$
CREATE TRIGGER trg_after_application_insert
AFTER INSERT ON Application
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action, record_id, details)
    VALUES ('Application', 'INSERT', NEW.application_id,
            CONCAT('Candidate ', NEW.candidate_id, ' applied for Job ', NEW.job_id));
END $$

-- Trigger 2: Log application status changes
DROP TRIGGER IF EXISTS trg_after_application_update $$
CREATE TRIGGER trg_after_application_update
AFTER UPDATE ON Application
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Audit_Log (table_name, action, record_id, details)
        VALUES ('Application', 'UPDATE', NEW.application_id,
                CONCAT('Status changed from ', OLD.status, ' to ', NEW.status));
    END IF;
END $$

-- Trigger 3: Auto-close job when all vacancies are filled
DROP TRIGGER IF EXISTS trg_close_job_on_hire $$
CREATE TRIGGER trg_close_job_on_hire
AFTER UPDATE ON Application
FOR EACH ROW
BEGIN
    DECLARE v_hired    INT;
    DECLARE v_vacancies INT;

    IF NEW.status = 'Hired' THEN
        SELECT COUNT(*) INTO v_hired
        FROM Application
        WHERE job_id = NEW.job_id AND status = 'Hired';

        SELECT vacancies INTO v_vacancies
        FROM Job_Posting WHERE job_id = NEW.job_id;

        IF v_hired >= v_vacancies THEN
            UPDATE Job_Posting SET status = 'Closed' WHERE job_id = NEW.job_id;

            INSERT INTO Audit_Log (table_name, action, record_id, details)
            VALUES ('Job_Posting', 'UPDATE', NEW.job_id,
                    CONCAT('Job auto-closed: all ', v_vacancies, ' vacancies filled.'));
        END IF;
    END IF;
END $$

-- Trigger 4: Set responded_at when offer status changes
DROP TRIGGER IF EXISTS trg_offer_responded $$
CREATE TRIGGER trg_offer_responded
BEFORE UPDATE ON Offer
FOR EACH ROW
BEGIN
    IF OLD.status = 'Pending' AND NEW.status IN ('Accepted','Declined') THEN
        SET NEW.responded_at = NOW();
    END IF;
END $$

-- Trigger 5: Log offer inserts
DROP TRIGGER IF EXISTS trg_after_offer_insert $$
CREATE TRIGGER trg_after_offer_insert
AFTER INSERT ON Offer
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action, record_id, details)
    VALUES ('Offer', 'INSERT', NEW.offer_id,
            CONCAT('Offer created for application ', NEW.application_id,
                   ' with salary ', NEW.offered_salary));
END $$

DELIMITER ;
