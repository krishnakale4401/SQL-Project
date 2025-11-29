CREATE DATABASE dev_HealthConnect_raw;

CREATE TABLE RAW_claims(
claim_id  INT ,
encounter_id INT,
payer_id INT, 
admit_date DATE,
discharge_date DATE,
total_billed_amount	float,
total_allowed_amount float,
total_paid_amount float,	
claim_status  VARCHAR(50)

);

CREATE TABLE RAW_payers(
payer_id INT,
payer_name VARCHAR(100)
);

CREATE TABLE RAW_diagnoses(
diagnosis_id int ,
encounter_id int,
diagnosis_description VARCHAR(100),
is_primary bit

);

CREATE TABLE RAW_encounters(
encounter_id INT,
patient_id INT,
provider_id INT, 
encounter_type VARCHAR(50),
encounter_start date,
encounter_end date,
height_cm VARCHAR(50), 
weight_kg VARCHAR(50),
systolic_bp INT,
diastolic_bp INT,
);

CREATE TABLE RAW_medications(
medication_id INT,
encounter_id INT,
drug_name VARCHAR(50),
route VARCHAR(50),
dose VARCHAR(50),
frequency VARCHAR(50),
days_supply INT 

);

CREATE TABLE RAW_patients(
patient_id INT ,
first_name VARCHAR(50),
last_name VARCHAR(50),
gender VARCHAR(10), 
date_of_birth DATE,
state_code CHAR(2),
city VARCHAR(50),
phone BIGINT

);

CREATE TABLE RAW_procedures(
procedure_id INT , 
encounter_id INT,
procedure_description VARCHAR(100)
);

CREATE TABLE RAW_providers(
provider_id INT,
first_name VARCHAR(100),
last_name VARCHAR(100),
specialty VARCHAR(100),
npi VARCHAR(20)
);

