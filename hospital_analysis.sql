USE HOSPITAL_ANALYSIS;
### Identify top revenue-generating treatments and patient demographics

### “Which treatments and patient groups generate the most hospital revenue?”

SELECT P.GENDER, T.TREATMENT_ID,
P.INSURANCE_PROVIDER, SUM(B.AMOUNT) AS TOTAL_REVENUE,
COUNT(B.BILL_ID) AS TOTAL_CASE 
FROM BILLING B 
JOIN TREATMENTS T
ON T.TREATMENT_ID = B.TREATMENT_ID
JOIN PATIENT P 
ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY P.GENDER, T.TREATMENT_ID,
P.INSURANCE_PROVIDER
ORDER BY TOTAL_REVENUE DESC;

### 1: Payment Status Analysis

SELECT PAYMENT_STATUS, 
COUNT(BILL_ID) AS TOTAL_CASES, 
SUM(AMOUNT) AS TOTAL_AMOUNT FROM BILLING 
GROUP BY PAYMENT_STATUS;

### 2: Monthly Revenue Trend

SELECT DATE_FORMAT(bill_date, '%Y-%m') AS billing_month, COUNT(BILL_ID) AS TOTAL_CASES, 
SUM(AMOUNT) AS TOTAL_AMOUNT FROM BILLING
GROUP BY BILLING_MONTH;

### 3: Top Revenue-Generating Patients

SELECT P.PATIENT_ID, CONCAT(P.FIRST_NAME," ", P.LAST_NAME) AS FULL_NAME,
COUNT(b.bill_id) AS total_visits,
SUM(B.AMOUNT) AS TOTAL_AMOUNT
FROM PATIENT P
JOIN BILLING B ON B.PATIENT_ID = P.PATIENT_ID
GROUP BY P.PATIENT_ID, FULL_NAME
ORDER BY P.PATIENT_ID;

### 4: Treatment Revenue Distribution

SELECT
    t.treatment_type,
    COUNT(b.bill_id) AS total_cases,
    SUM(b.amount) AS total_revenue,
    AVG(b.amount) AS avg_bill_value
FROM BILLING b
JOIN TREATMENTS t
    ON b.treatment_id = t.treatment_id
GROUP BY t.treatment_type
ORDER BY total_revenue DESC;

### Insight: Treatment Profitability vs Frequency
### Business Question
### Which treatments are performed most often, and which treatments generate the highest revenue?

SELECT t.treatment_type,
COUNT(t.treatment_id) AS treatment_frequency,
SUM(b.amount) AS total_revenue
FROM TREATMENTS t
JOIN BILLING b
    ON t.treatment_id = b.treatment_id
GROUP BY t.treatment_type
ORDER BY total_revenue DESC;

### Patient Lifecycle Value (PLV)

### Who are long-term value patients?
### Does retention actually pay off?

SELECT P.PATIENT_ID, P.REGISTRATION_DATE,
SUM(B.AMOUNT) AS TOTAL_REVENUE
FROM PATIENT p
JOIN BILLING b
    ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.registration_date;

SELECT
    YEAR(p.registration_date) AS registration_year,
    COUNT(DISTINCT p.patient_id) AS patient_count,
    SUM(b.amount) AS total_revenue
FROM PATIENT p
JOIN BILLING b
    ON p.patient_id = b.patient_id
GROUP BY YEAR(p.registration_date)
ORDER BY registration_year;

###  Top Treatments by Revenue (RANKING)

SELECT
    t.treatment_type,
    SUM(b.amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(b.amount) DESC) AS revenue_rank
FROM TREATMENTS t
JOIN BILLING b
    ON t.treatment_id = b.treatment_id
GROUP BY t.treatment_type;

### 1️. Top 20% Patients Driving Revenue
### A small percentage of patients contributes the majority of revenue → dependency & retention focus.

SELECT *
FROM (
    SELECT
        p.patient_id,
        CONCAT(p.first_name,' ',p.last_name) AS patient_name,
        SUM(b.amount) AS total_revenue,
        ROUND(
            SUM(b.amount) * 100.0 /
            SUM(SUM(b.amount)) OVER (),
            2) AS revenue_percentage,
        RANK() OVER (ORDER BY SUM(b.amount) DESC) AS revenue_rank
    FROM PATIENT p
    JOIN BILLING b
        ON p.patient_id = b.patient_id
    GROUP BY p.patient_id, patient_name
) ranked_patients
WHERE revenue_rank <= (
    SELECT CEIL(COUNT(DISTINCT patient_id) * 0.2)
    FROM PATIENT
);  
