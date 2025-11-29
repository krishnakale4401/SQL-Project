CREATE SCHEMA dev_Refinsed_Reports;

-- KPI 1) What is the yearly trend of total claim amount, Total number of claims processed, and average claim amount paid?			
select * from Refinsed_claims;

CREATE OR ALTER VIEW dev_Refinsed_Reports.yearly_claims_trend
AS
SELECT YEAR(admit_date) as yearly_trands,
SUM(total_paid_amount) as Total_Claim_amount,
COUNT(claim_id) as Total_Claims_Processed,
AVG(total_paid_amount) as Avg_Claim_Amount
from Refinsed_claims
where claim_status = 'paid'
group by YEAR (admit_date);


SELECT * FROM dev_Refinsed_Reports.yearly_claims_trend
ORDER BY yearly_trands;

-- KPI 2) What is the total claim amount paid and total number of claims processed by each insurance payer?		

CREATE OR ALTER VIEW dev_Refinsed_Reports.Yearly_Claim_By_Payers AS 
SELECT 
payer_name, 
SUM(total_paid_amount) AS TotalClaimAmount,
COUNT(claim_id) AS Total_Claims
FROM Refinsed_claims AS A
LEFT JOIN Refinsed_payers AS B 
ON A.payer_id = B.payer_id
where claim_status = 'paid'
GROUP BY payer_name;

SELECT * FROM dev_Refinsed_Reports.Yearly_Claim_By_Payers
ORDER BY Total_Claims DESC;

-- KPI 3) What is the Total claim amount for the Current and Previous Year’s Year to Date (YTD), Quarter To Date(QTD), Month To Date (MTD) and Week To Date(WTD)?					
SELECT * FROM Refinsed_claims;

CREATE OR ALTER VIEW dev_Refinsed_Reports.Total_Claims_Amount_YTD_QTD_MTD_WTD_Wise
AS
SELECT 
  CASE WHEN YEAR(admit_date)=YEAR(GETDATE()) THEN 'Current Year' ELSE 'Previous Year' END AS PeriodType,
  YEAR(admit_date) AS ClaimYear,

  SUM(CASE WHEN admit_date >= DATEFROMPARTS(YEAR(admit_date),1,1) THEN total_paid_amount END) AS YTD_ClaimAmount,
  SUM(CASE WHEN admit_date >= DATEADD(YEAR, YEAR(admit_date)-YEAR(GETDATE()),

  DATEADD(QUARTER, DATEDIFF(QUARTER,0,GETDATE()),0)) THEN total_paid_amount END) AS QTD_ClaimAmount,
  SUM(CASE WHEN admit_date >= DATEADD(YEAR, YEAR(admit_date)-YEAR(GETDATE()),

  DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE()),0)) THEN total_paid_amount END) AS MTD_ClaimAmount,
  SUM(CASE WHEN admit_date >= DATEADD(YEAR, YEAR(admit_date)-YEAR(GETDATE()),

  DATEADD(WEEK, DATEDIFF(WEEK,0,GETDATE()),0)) THEN total_paid_amount END) AS WTD_ClaimAmount
FROM Refinsed_claims
WHERE YEAR(admit_date) IN (YEAR(GETDATE()), YEAR(GETDATE())-1)
GROUP BY CASE WHEN YEAR(admit_date)=YEAR(GETDATE()) THEN 'Current Year' ELSE 'Previous Year' END,
         YEAR(admit_date);

        
SELECT * FROM dev_Refinsed_Reports.Total_Claims_Amount_YTD_QTD_MTD_WTD_Wise
ORDER BY ClaimYear DESC;

-- KPI 4) Which healthcare providers have shown the highest patient engagement count over the last five years, based on the total number of patient visits handled each year?				





-- kpi 5) Which diagnoses contribute most to total healthcare claim costs?	
SELECT * FROM Refinsed_claims;

CREATE OR ALTER VIEW dev_Refinsed_Reports.Top_Costly_Diagnoses AS 
SELECT  
diagnosis_description,
SUM(total_paid_amount) AS TotalClaimAmount
FROM Refinsed_diagnoses AS a 
LEFT JOIN Refinsed_claims AS b 
ON a.encounter_id = b.encounter_id 
GROUP BY diagnosis_description;

SELECT * FROM dev_Refinsed_Reports.Top_Costly_Diagnoses
ORDER BY TotalClaimAmount DESC;

-- KPI 6) What is the total number of patient visits, total claim cost, and average cost per patient visit per year?			

CREATE OR ALTER VIEW dev_Refinsed_Reports.Patients_Visits_Stats AS
SELECT
    YEAR(c.admit_date) AS Year,
    COUNT(p.patient_id) AS Total_Patient_Visits,
    SUM(c.total_paid_amount) AS Total_Claim_Cost,
    AVG(c.total_paid_amount) * 1.0 / COUNT(p.patient_id) AS Avg_Cost_Per_Visit
FROM Refinsed_claims AS c
LEFT JOIN Refinsed_encounters AS e 
    ON e.encounter_id = c.encounter_id
LEFT JOIN Refinsed_patients AS p
    ON e.patient_id = p.patient_id

GROUP BY YEAR(c.admit_date);

SELECT * FROM dev_Refinsed_Reports.Patients_Visits_Stats
ORDER BY year;

SELECT * FROM Refinsed_claims;
select * from Refinsed_encounters;


-- KPI 7) What are the total claim amount, total number of claims, and average claim amount by patient gender?			

CREATE OR ALTER VIEW dev_Refinsed_Reports.Claim_Stats_By_Gender AS
SELECT
    p.gender AS Gender,
    SUM(c.total_paid_amount) AS TotalClaimPaid,
    COUNT(c.claim_id) AS TotalClaims,
    AVG(c.total_paid_amount)  AS AvgClaimAmount
FROM Refinsed_patients as p 
LEFT JOIN Refinsed_encounters as e on e.patient_id = p.patient_id
LEFT JOIN Refinsed_claims AS c  on c.encounter_id = e.encounter_id
WHERE p.gender IS NOT NULL
GROUP BY p.gender;

SELECT * FROM dev_Refinsed_Reports.Claim_Stats_By_Gender
ORDER BY Gender DESC;


-- KPI 8) Which medications are prescribed most frequently across all patient visits?		
	
CREATE OR ALTER VIEW dev_Refinsed_Reports.Most_Prescribed_Medications_Across_Patient_Visits AS

WITH R AS (
    SELECT 
        m.drug_name AS drug_name, 
        a.procedure_description AS Prescriptions, 
        SUM(m.days_supply) AS TotalDaysSupplied
    FROM Refinsed_medications AS m
    JOIN Refinsed_procedures AS a
        ON a.procedure_id = m.medication_id
    GROUP BY 
        m.drug_name,
        a.procedure_description
),
Y AS (
    SELECT *, DENSE_RANK() OVER(ORDER BY TotalDaysSupplied DESC) AS RNK
    FROM R
)
SELECT drug_name, Prescriptions, TotalDaysSupplied FROM Y WHERE RNK = 1;

select * from dev_Refinsed_Reports.Most_Prescribed_Medications_Across_Patient_Visits;


-- KPI 9) What is age group wise TotalClaimAmount and TotalClaim?

SELECT
    CASE
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) < 18 THEN 'Child (<18)'
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) BETWEEN 36 AND 55 THEN 'Adult (36-55)'
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) > 55 THEN 'Senior (55+)'
        
    END AS AgeGroup,
    SUM(c.total_paid_amount) AS TotalClaimPaid,
    COUNT(c.claim_id) AS TotalClaims
FROM Refinsed_patients AS p
LEFT JOIN Refinsed_claims AS c
    ON p.patient_id = c.claim_id
WHERE p.date_of_birth IS NOT NULL
GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) < 18 THEN 'Child (<18)'
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) BETWEEN 36 AND 55 THEN 'Adult (36-55)'
        WHEN DATEDIFF(YEAR, p.date_of_birth, GETDATE()) > 55 THEN 'Senior (55+)'       
    END;

-- KPI 10) How has the average inpatient stay duration (from admission to discharge) varied year over year, and what is the percentage increase or decrease compared to the previous year?				


-- KPI 11) How much have total paid claim amount changed compared to the previous year, and what is the year-over-year percentage growth in insurance claim payments? 			

WITH YearlyClaims AS (
    SELECT
        YEAR(admit_date) AS ClaimYear,
        SUM(total_paid_amount) AS TotalPaidAmount
    FROM Refinsed_claims
    WHERE admit_date IS NOT NULL
    GROUP BY YEAR(admit_date)
),
WithPreviousYear AS (
    SELECT
        yc.ClaimYear,
        yc.TotalPaidAmount,
        LAG(yc.TotalPaidAmount) OVER (ORDER BY yc.ClaimYear) AS PrevYearPaidAmount
    FROM YearlyClaims AS yc
)
SELECT
    ClaimYear,
    TotalPaidAmount,
    PrevYearPaidAmount,
    ROUND(
        CASE 
            WHEN PrevYearPaidAmount IS NULL THEN NULL
            ELSE ((TotalPaidAmount - PrevYearPaidAmount) * 100.0 / PrevYearPaidAmount)
        END, 2
    ) AS YoYChangePercent
FROM WithPreviousYear
ORDER BY ClaimYear;

/* SELECT 
    YEAR(admit_date) AS AdmitYear,
    SUM(total_paid_amount) AS TotalPaidAmount,
    SUM(CASE 
        WHEN YEAR(admit_date) = YEAR(admit_date) THEN total_paid_amount
        WHEN YEAR(admit_date) = YEAR(admit_date) - 1 THEN total_paid_amount
        WHEN YEAR(admit_date) = YEAR(admit_date) - 1 THEN total_paid_amount
        WHEN YEAR(admit_date) = YEAR(admit_date) - 1 THEN total_paid_amount
        WHEN YEAR(admit_date) = YEAR(admit_date) - 1 THEN total_paid_amount
        WHEN YEAR(admit_date) = YEAR(admit_date) - 1 THEN total_paid_amount

        ELSE 0
    END) AS PaidLastYear
FROM Refinsed_claims
GROUP BY YEAR(admit_date)
order by AdmitYear;
 */
 
