CREATE DATABASE Dev_HealthConnect_Refined;

--- Refined Layer Created Tables ---

CREATE TABLE Refinsed_patients(
patient_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50)NOT NULL,
gender VARCHAR(10) NOT NULL CHECK(gender in('M','F','O')), 
date_of_birth date,
state_code CHAR(2),
city VARCHAR(50) NOT NULL,
phone BIGINT,
LoadDate DATETIME, 
Last_Modified_Date DATETIME DEFAULT GETDATE()
);


CREATE TABLE Refinsed_payers(
payer_id INT PRIMARY KEY,
payer_name VARCHAR(100),
LoadDate DATETIME,
Last_Modified_Date DATEtime DEFAULT GETDATE()
);

CREATE TABLE Refinsed_providers(
provider_id INT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
specialty VARCHAR(100) NOT NULL,
npi VARCHAR(20) NOT NULL,
LoadDate DATETIME,
Last_Modified_Date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Refinsed_encounters(
encounter_id INT PRIMARY KEY,
patient_id INT NOT NULL,
provider_id INT NOT NULL, 
encounter_type VARCHAR(50) NOT NULL,
encounter_start date,
encounter_end date,
height_cm VARCHAR(50) NOT NULL, 
weight_kg VARCHAR(50) NOT NULL,
systolic_bp INT NOT NULL,
diastolic_bp INT,
LoadDate DATETIME,
Last_Modified_Date DATETIME DEFAULT GETDATE()
);


CREATE TABLE Refinsed_claims(
claim_id  INT PRIMARY KEY,
encounter_id INT NOT NULL,
payer_id INT NOT NULL, 
admit_date DATE NOT NULL,
discharge_date DATE NOT NULL,
total_billed_amount	float NOT NULL,
total_allowed_amount float NOT NULL,
total_paid_amount float NOT NULL,	
claim_status  VARCHAR(100) NOT NULL,
LoadDate DATETIME,
Last_Modified_Date DATETIME DEFAULT GETDATE()
);


CREATE TABLE Refinsed_diagnoses(
diagnosis_id INT PRIMARY KEY,
encounter_id INT NOT NULL ,
diagnosis_description VARCHAR(100) NOT NULL,
is_primary BIT NOT NULL,
LoadDate DATETIME,
Last_Modified_Date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Refinsed_medications(
medication_id INT PRIMARY KEY,
encounter_id INT NOT NULL,
drug_name VARCHAR(50) NOT NULL,
route VARCHAR(50) NOT NULL,
dose VARCHAR(50) NOT NULL,
frequency VARCHAR(50) NOT NULL,
days_supply INT NOT NULL,
LoadDate DATETIME,
Last_Modified_Date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Refinsed_procedures(
procedure_id INT PRIMARY KEY, 
encounter_id INT ,
procedure_description VARCHAR(100) NOT NULL,
LoadDate DATETIME,
Last_Modified_Date DATETIME DEFAULT GETDATE()
);
