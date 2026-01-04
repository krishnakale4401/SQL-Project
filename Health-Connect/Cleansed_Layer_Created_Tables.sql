CREATE DATABASE Dev_HealthConnect_Cleansed;

-- CLEANSED CREATED TABLES 

CREATE TABLE Cleansed_patients(
patient_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50)NOT NULL,
gender VARCHAR(10) NOT NULL, 
date_of_birth DATE,
state_code CHAR(2),
city VARCHAR(50) NOT NULL,
phone BIGINT,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_payers(
payer_id INT PRIMARY KEY,
payer_name VARCHAR(100),
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_providers(
provider_id INT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
specialty VARCHAR(100) NOT NULL,
npi VARCHAR(20) NOT NULL,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_encounters(
encounter_id INT PRIMARY KEY,
patient_id INT NOT NULL,
provider_id INT NOT NULL, 
encounter_type VARCHAR(50) NOT NULL,
encounter_start date,
encounter_end date,
height_cm FLOAT NOT NULL, 
weight_kg FLOAT NOT NULL,
systolic_bp INT,
diastolic_bp INT,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_claims(
claim_id  INT PRIMARY KEY,
encounter_id INT NOT NULL,
payer_id INT NOT NULL, 
admit_date DATE NOT NULL,
discharge_date DATE NOT NULL,
total_billed_amount	float NOT NULL,
total_allowed_amount float NOT NULL,
total_paid_amount float NOT NULL,	
claim_status  VARCHAR(100) NOT NULL,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_diagnoses(
diagnosis_id INT PRIMARY KEY,
encounter_id int NOT NULL ,
diagnosis_description VARCHAR(100) NOT NULL,
is_primary bit NOT NULL,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_medications(
medication_id INT PRIMARY KEY,
encounter_id INT NOT NULL,
drug_name VARCHAR(50) NOT NULL,
route VARCHAR(50) NOT NULL,
dose VARCHAR(50) NOT NULL,
frequency VARCHAR(50) NOT NULL,
days_supply INT NOT NULL,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Cleansed_procedures(
procedure_id INT PRIMARY KEY, 
encounter_id INT,
procedure_description VARCHAR(100) NOT NULL,
LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);