-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?

SELECT 
    YEAR(start) AS yr, COUNT(id) AS total_encounters
FROM
    encounters
GROUP BY yr
ORDER BY yr ASC;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

SELECT 
    YEAR(start) AS yr,
    ROUND(sum(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS ambulatory,
    ROUND(sum(CASE WHEN ENCOUNTERCLASS = 'outpatient' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS outpatient,
    ROUND(sum(CASE WHEN ENCOUNTERCLASS = 'wellness' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS wellness,
    ROUND(sum(CASE WHEN ENCOUNTERCLASS = 'urgentcare' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS urgent_care,
    ROUND(sum(CASE WHEN ENCOUNTERCLASS = 'emergency' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS emergency,
    ROUND(sum(CASE WHEN ENCOUNTERCLASS = 'inpatient' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS inpatient
FROM
    encounters
GROUP BY yr
ORDER BY yr ASC;

-- c. What percentage of encounters were over 24 hours versus under 24 hours?
SELECT COUNT(timestampdiff(HOUR,START,STOP)) FROM ENCOUNTERS
WHERE timestampdiff(HOUR,START,STOP) >= 24;

SELECT COUNT(timestampdiff(HOUR,START,STOP)) FROM ENCOUNTERS
WHERE timestampdiff(HOUR,START,STOP) < 24;

SELECT 
		ROUND(SUM(CASE WHEN timestampdiff(HOUR,START,STOP) >= 24 THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS OVER_24_HOURS,
		ROUND(SUM(CASE WHEN timestampdiff(HOUR,START,STOP) < 24 THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS UNDER_24_HOURS
FROM ENCOUNTERS;

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

SELECT COUNT(*) FROM ENCOUNTERS WHERE PAYER = 0;
SELECT
	SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) AS ZERO_PAYER_COVERAGE,
	ROUND(SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100 , 1) AS ZERO_PAYER_COVERAGE_PCT
FROM encounters;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?

SELECT CODE, DESCRIPTION, COUNT(*) AS NUM_PROCEDURES, AVG(BASE_COST) AS AVG_BASE_COST 
FROM procedures
group by CODE, DESCRIPTION
ORDER BY NUM_PROCEDURES DESC
LIMIT 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT CODE, DESCRIPTION, AVG(BASE_COST) AS AVG_BASE_COST, COUNT(*) AS NUM_PROCEDURES
FROM procedures
group by CODE, DESCRIPTION
ORDER BY AVG_BASE_COST DESC
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?

SELECT P.NAME,  avg(E.TOTAL_CLAIM_COST) AS AVG_TOTAL_CLAIM_COST
FROM payers P LEFT JOIN ENCOUNTERS E ON P.ID = E.PAYER
GROUP BY P.NAME
ORDER BY AVG_TOTAL_CLAIM_COST DESC;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?

SELECT 
    YEAR(START) AS YR,
    QUARTER(START) AS QRTR,
    COUNT(DISTINCT PATIENT) AS NUM_UNIQUE_PATIENTS
FROM
    encounters
GROUP BY YR , QRTR
ORDER BY YR , QRTR;

-- b. How many patients were readmitted within 30 days of a previous encounter?

SELECT PATIENT,START,STOP,
	LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS NEXT_START_DATE
FROM encounters
order by PATIENT,START;

WITH CTE AS (
	SELECT PATIENT,START,STOP,
	LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS NEXT_START_DATE
FROM encounters
)
SELECT COUNT(DISTINCT PATIENT) AS NUM_PATIENTS FROM CTE WHERE datediff(NEXT_START_DATE,STOP)<30;

-- c. Which patients had the most readmissions?
WITH CTE AS (
	SELECT PATIENT,START,STOP,
	LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS NEXT_START_DATE
FROM encounters
)
SELECT PATIENT, COUNT(*) AS NUM_READMISSIONS FROM CTE WHERE datediff(NEXT_START_DATE,STOP)<30
GROUP BY PATIENT
ORDER BY NUM_READMISSIONS DESC;