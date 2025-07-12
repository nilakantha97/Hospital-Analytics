# Hospital-Analytics

This repository contains SQL queries and analysis performed as part of the Maven Analytics "Hospital Analytics" guided project. The project focuses on leveraging SQL to derive insights from hospital patient encounters, costs, and behavior trends.

## Project Overview

The core objective of this project was to analyze various aspects of hospital operations using a provided dataset. This involved extracting meaningful information related to patient encounters, financial aspects (costs and payer coverage), and patient behavioral patterns (admissions and readmissions).

## Project Objectives & Key Questions Answered

This project addressed the following key analytical questions:

### 1. Encounters Overview

* **Total Encounters Annually:** How many total encounters occurred each year?
* **Encounter Class Distribution:** For each year, what percentage of all encounters belonged to each encounter class (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
* **Encounter Duration Analysis:** What percentage of encounters were over 24 hours versus under 24 hours?

### 2. Cost & Coverage Insights

* **Zero Payer Coverage Encounters:** How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
* **Top Frequent Procedures:** What are the top 10 most frequent procedures performed and the average base cost for each?
* **Highest Cost Procedures:** What are the top 10 procedures with the highest average base cost and the number of times they were performed?
* **Average Claim Cost by Payer:** What is the average total claim cost for encounters, broken down by payer?

### 3. Patient Behavior Analysis

* **Quarterly Unique Patient Admissions:** How many unique patients were admitted each quarter over time?
* **30-Day Readmissions:** How many patients were readmitted within 30 days of a previous encounter?
* **Patients with Most Readmissions:** Which patients had the most readmissions?

## Database Schema (Assumed)

The analysis was performed on a relational database, likely consisting of tables such as:

* **`encounters`**: Contains details about patient visits, including `id`, `start` (encounter start time), `stop` (encounter end time), `patient` (patient ID), `payer` (payer ID), `total_claim_cost`, and `encounterclass`.
* **`procedures`**: Contains information about medical procedures performed, including `code`, `description`, and `base_cost`.
* **`payers`**: Contains details about insurance payers, including `id` and `name`.

The relationships between these tables allow for comprehensive analysis across patient visits, associated procedures, and financial aspects.

## Files in this Repository

* `sql/hospital_analytics_questions_answers.sql`: This is the core SQL script containing all the queries. It includes comments detailing the objective for each set of queries and the SQL solutions to answer the analytical questions listed above.
* ** `data/` folder:** This folder contain the SQL dump of the database schema and sample data used for this project, allowing for replication of the environment.

## Technologies Used

* **Database:** MySQL (The queries are written using MySQL syntax, but can be adapted for other SQL-compliant databases like PostgreSQL, SQL Server, etc.)
* **Language:** SQL

## How to Set Up and Run the Queries

To execute these queries and replicate the analysis:

1.  **Database Setup:** Ensure you have a MySQL (or compatible) database server running.
2.  **Import Data:** Import the `create_hospital_db` schema and data into your MySQL instance.
3.  **Connect to Database:** Use a MySQL client (e.g., MySQL Workbench, DBeaver, or command-line client) to connect to your `create_hospital_db`.
4.  **Execute Queries:** Open and run the queries from `sql/hospital_analytics_questions_answers.sql` against your connected database.

## Author

**Nilakantha Mohapatra**
* [GitHub Profile](https://github.com/nilakantha97)
* [LinkedIn Profile](https://www.linkedin.com/in/nilakantha97)
