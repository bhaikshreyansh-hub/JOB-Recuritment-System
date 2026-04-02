-- ============================================================
-- Seed Data for Job Recruitment System
-- ============================================================
USE job_recruitment;

-- Skills
INSERT INTO Skill (skill_name, category) VALUES
('Python','Programming'),('Java','Programming'),('JavaScript','Programming'),
('React','Frontend'),('Node.js','Backend'),('MySQL','Database'),
('PostgreSQL','Database'),('MongoDB','Database'),('AWS','Cloud'),
('Docker','DevOps'),('Git','Tools'),('Machine Learning','AI/ML'),
('Data Analysis','Analytics'),('Project Management','Soft Skills'),
('Communication','Soft Skills'),('SQL','Database'),('PHP','Backend'),
('Django','Backend'),('Spring Boot','Backend'),('Flutter','Mobile');

-- Companies
INSERT INTO Company (company_name, industry, website, email, phone, address, description, founded_year) VALUES
('TechNova Solutions','Information Technology','https://technova.com','hr@technova.com','9876543210','Bengaluru, Karnataka','Leading IT solutions provider.',2010),
('DataBridge Analytics','Data Science','https://databridge.in','careers@databridge.in','9812345678','Mysuru, Karnataka','Advanced data analytics firm.',2015),
('CloudPeak Systems','Cloud Computing','https://cloudpeak.io','jobs@cloudpeak.io','9765432109','Hyderabad, Telangana','Cloud infrastructure specialists.',2018),
('GreenLeaf Fintech','Finance Technology','https://greenleaf.co.in','recruit@greenleaf.co.in','9654321098','Mumbai, Maharashtra','Innovative fintech startup.',2019),
('NovaMed Health','Healthcare IT','https://novamed.in','hr@novamed.in','9543210987','Pune, Maharashtra','Digital health platform.',2016);

-- Candidates
INSERT INTO Candidate (full_name, email, phone, date_of_birth, gender, address, profile_summary) VALUES
('Arjun Sharma','arjun.sharma@gmail.com','9900112233','1998-05-14','Male','Mysuru, Karnataka','Full stack developer with 3 years experience in React and Node.js.'),
('Priya Nair','priya.nair@gmail.com','9911223344','1999-08-22','Female','Bengaluru, Karnataka','Data analyst skilled in Python, SQL, and Power BI.'),
('Rahul Mehta','rahul.mehta@gmail.com','9922334455','1997-03-10','Male','Mumbai, Maharashtra','Backend engineer specialising in Java and Spring Boot.'),
('Sneha Patel','sneha.patel@gmail.com','9933445566','2000-11-05','Female','Ahmedabad, Gujarat','Frontend developer with React and Flutter expertise.'),
('Vikram Reddy','vikram.reddy@gmail.com','9944556677','1996-07-18','Male','Hyderabad, Telangana','DevOps engineer with Docker and AWS experience.'),
('Ananya Singh','ananya.singh@gmail.com','9955667788','1999-01-30','Female','Delhi, NCR','Machine learning enthusiast with strong Python skills.'),
('Karan Joshi','karan.joshi@gmail.com','9966778899','1998-09-25','Male','Pune, Maharashtra','Full stack developer with 2 years of experience.'),
('Deepika Rao','deepika.rao@gmail.com','9977889900','2001-04-12','Female','Chennai, Tamil Nadu','Fresh graduate with skills in SQL and Java.');

-- Candidate Skills
INSERT INTO Candidate_Skill (candidate_id, skill_id, proficiency, years_exp) VALUES
(1,3,'Advanced',3),(1,4,'Advanced',3),(1,5,'Intermediate',2),(1,11,'Advanced',3),
(2,1,'Advanced',3),(2,16,'Advanced',4),(2,13,'Advanced',3),
(3,2,'Expert',5),(3,19,'Advanced',4),(3,11,'Advanced',5),
(4,3,'Advanced',3),(4,4,'Advanced',3),(4,20,'Intermediate',1),
(5,10,'Advanced',4),(5,9,'Advanced',3),(5,11,'Expert',5),
(6,1,'Advanced',3),(6,12,'Advanced',2),(6,13,'Intermediate',2),
(7,1,'Intermediate',2),(7,3,'Intermediate',2),(7,4,'Beginner',1),
(8,2,'Beginner',1),(8,16,'Intermediate',1);

-- Job Postings
INSERT INTO Job_Posting (company_id, title, description, requirements, location, job_type, salary_min, salary_max, vacancies, deadline, status) VALUES
(1,'Senior React Developer','Build scalable web apps using React.','3+ yrs React, REST APIs, Git.','Bengaluru','Full-Time',800000,1200000,2,'2025-09-30','Open'),
(1,'Backend Python Engineer','Develop microservices in Python Django.','2+ yrs Django, PostgreSQL.','Bengaluru','Full-Time',700000,1000000,1,'2025-09-15','Open'),
(2,'Data Analyst','Analyse business data and create dashboards.','SQL, Python, Power BI.','Mysuru','Full-Time',600000,900000,2,'2025-10-01','Open'),
(2,'ML Engineer','Build and deploy ML models.','Python, Scikit-learn, TensorFlow.','Remote','Remote',900000,1400000,1,'2025-09-20','Open'),
(3,'DevOps Engineer','Manage CI/CD pipelines and cloud infra.','Docker, Kubernetes, AWS.','Hyderabad','Full-Time',1000000,1500000,1,'2025-09-25','Open'),
(4,'Fullstack Developer','Develop fintech web apps.','React, Node.js, MySQL.','Mumbai','Full-Time',750000,1100000,2,'2025-10-10','Open'),
(5,'Java Backend Developer','Develop healthcare APIs.','Java, Spring Boot, REST.','Pune','Full-Time',700000,1050000,1,'2025-09-30','Open'),
(1,'Flutter Mobile Developer','Build cross-platform mobile apps.','Flutter, Dart, Firebase.','Bengaluru','Full-Time',600000,900000,1,'2025-10-05','Open');

-- Applications
INSERT INTO Application (job_id, candidate_id, cover_letter, status) VALUES
(1,1,'I am passionate about React and have 3 years of experience building SPAs.','Shortlisted'),
(1,4,'I have strong React and frontend skills.','Reviewed'),
(2,2,'I have Python and Django experience.','Pending'),
(3,2,'SQL and data analysis are my core strengths.','Shortlisted'),
(3,8,'I am a fresher eager to learn data analysis.','Pending'),
(4,6,'Machine learning is my passion with 2 years of project experience.','Shortlisted'),
(5,5,'DevOps with Docker and AWS — 4 years of hands-on experience.','Shortlisted'),
(6,1,'I have full-stack skills with React and Node.js.','Pending'),
(6,7,'I enjoy building fintech products.','Reviewed'),
(7,3,'Java and Spring Boot expert with 5 years of experience.','Hired'),
(8,4,'Flutter development is something I actively pursue.','Reviewed');

-- Interviews
INSERT INTO Interview (application_id, scheduled_at, mode, interviewer, venue, outcome) VALUES
(1,'2025-08-10 10:00:00','Video','Rajesh Kumar, CTO','Google Meet','Passed'),
(4,'2025-08-12 11:00:00','In-Person','Meera Iyer, Head Analytics','DataBridge Office, Mysuru','Passed'),
(6,'2025-08-14 14:00:00','Video','Dr. Anand Roy, AI Lead','Zoom','Pending'),
(7,'2025-08-13 09:30:00','In-Person','Suresh Yadav, DevOps Lead','CloudPeak Office, Hyderabad','Passed'),
(10,'2025-08-08 10:00:00','Phone','Nisha Thomas, HR','Phone Call','Passed');

-- Offers
INSERT INTO Offer (application_id, offered_salary, joining_date, offer_letter, status) VALUES
(10, 950000,'2025-09-01','Congratulations! You have been selected for the role of Java Backend Developer at NovaMed Health.','Accepted'),
(7,  1200000,'2025-09-15','We are pleased to offer you the DevOps Engineer position at CloudPeak Systems.','Pending');
