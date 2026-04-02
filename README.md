# 💼 Job Recruitment Management System

A backend-driven recruitment platform built with **Python** and **MySQL** for managing job listings, applicants, and recruiter workflows.

---

## 📌 Overview

This system simulates a real-world job recruitment pipeline — managing applicants, job postings, and recruiters through a structured relational database. It supports fast filtering, ranking, and reporting across large applicant datasets using optimized SQL queries.

---

## 🚀 Features

- 📋 Manage job listings, applicant profiles, and recruiter accounts
- 🔗 Relational schema modeling complex multi-entity relationships
- 🔍 Parameterized query workflows for fast applicant filtering and ranking
- 📊 Reporting tools for recruiter dashboards and hiring summaries
- ⚡ Optimized join paths reducing query latency on large datasets

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Language | Python |
| Database | MySQL |
| DB Connectivity | MySQL Connector (Python) |
| Schema Design | 3NF Normalized Relational Schema |

---

## 🗂️ Project Structure

```
JobRecruitmentSystem/
├── src/
│   ├── main.py                 # Entry point
│   ├── db_connection.py        # Database connection handler
│   ├── applicant.py            # Applicant CRUD operations
│   ├── job.py                  # Job listing operations
│   └── recruiter.py            # Recruiter operations
├── database/
│   └── schema.sql              # MySQL schema setup script
├── requirements.txt
└── README.md
```

---

## 🗄️ Database Schema

The system uses a **3NF-normalized** relational schema with the following tables:

- **applicants** — personal info, skills, experience
- **jobs** — job title, description, requirements, status
- **recruiters** — recruiter profiles and assigned roles
- **applications** — links applicants to job postings
- **interviews** — interview scheduling and status tracking

---

## ⚙️ Setup & Installation

### Prerequisites
- Python 3.8+
- MySQL 8.0+

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/shreyanshbhaik/job-recruitment-system.git
   cd job-recruitment-system
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up the database**
   ```sql
   source database/schema.sql;
   ```

4. **Configure database credentials**

   Update `db_connection.py`:
   ```python
   host = "localhost"
   user = "your_username"
   password = "your_password"
   database = "recruitment_db"
   ```

5. **Run the application**
   ```bash
   python src/main.py
   ```

---

## 📸 Screenshots

> _Add screenshots of the application output here_

---

## 🧠 What I Learned

- Designing **3NF-normalized schemas** for complex multi-entity relationships
- Writing **parameterized SQL queries** to prevent injection and improve performance
- Building **query-driven workflows** for filtering and ranking large datasets
- Structuring Python applications with clean **modular architecture**

---

## 👤 Author

**Shreyansh Bhaik**  
[LinkedIn](https://linkedin.com/in/shreyansh-bhaik) • [GitHub](https://github.com/shreyanshbhaik)
