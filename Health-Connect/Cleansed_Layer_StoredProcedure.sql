--- CLEANSED  PROCEDURE --
CREATE OR ALTER PROCEDURE Proc_HealthConnect_Raw_To_Cleansed_Load
AS
BEGIN
    --- Truncating all past data ---
    TRUNCATE TABLE Cleansed_payers;
    TRUNCATE TABLE Cleansed_providers;
    TRUNCATE TABLE Cleansed_patients;
    TRUNCATE TABLE Cleansed_encounters;
    TRUNCATE TABLE Cleansed_diagnoses;
    TRUNCATE TABLE Cleansed_medications;
    TRUNCATE TABLE Cleansed_claims;
    TRUNCATE TABLE Cleansed_procedures;

SET NOCOUNT ON;
DECLARE @RowCount INT;

    PRINT 'TRUNCATING ALL PAST DATA FROM CLEANSED LAYER....';
    PRINT 'LOADING DATA SOURCE TO CLEANSED LAYER.... ';
    PRINT '';

    BEGIN TRY
    --- Data cleanning process ---
     -- Cleansed_payers table --
     DECLARE @filepayers VARCHAR(100) = 'Cleansed_payers';

     INSERT INTO Cleansed_payers(payer_id,payer_name)
     SELECT payer_id,
     UPPER(TRIM(payer_name))
     FROM [dev_HealthConnect_raw].[dbo].[RAW_payers];

     SET @RowCount = @@ROWCOUNT;
     PRINT 'File: ' + @filepayers   + ': ' + CAST(@RowCount AS VARCHAR(10)) + ' rows inserted.';

     -- Cleansed_patients table --
     DECLARE @filepatients VARCHAR(100) = 'Cleansed_patients';

     INSERT INTO Cleansed_patients(patient_id,	first_name,	last_name,	gender,	date_of_birth,	state_code,	city,phone)

     SELECT patient_id,
     UPPER(TRIM(first_name)), UPPER(TRIM(last_name)),
     UPPER(TRIM(gender)), 
     date_of_birth, state_code,
     UPPER(TRIM(city)),phone
     FROM [dev_HealthConnect_raw].[dbo].[RAW_patients];

     SET @RowCount = @@ROWCOUNT;
     PRINT 'File: ' + @filepatients   + ': ' + CAST(@RowCount AS VARCHAR(10)) + ' rows inserted.';

     -- Cleansed_providers table -- 
     DECLARE @fileproviders VARCHAR(100) = 'Cleansed_providers';

     INSERT INTO Cleansed_providers
     (provider_id,first_name,last_name,specialty,npi)

     SELECT provider_id,
     UPPER(TRIM(first_name)),
     UPPER(TRIM(last_name)),
     UPPER(TRIM(specialty)),
     npi
     FROM [dev_HealthConnect_raw].[dbo].[RAW_providers];

     SET @RowCount = @@ROWCOUNT;
     PRINT 'File: ' + @fileproviders   + ': ' + CAST(@RowCount AS VARCHAR(500)) + ' rows inserted.';

     -- Cleansed_encounters table --  
     DECLARE @file_encounters VARCHAR(100) = 'Cleansed_encounters';

     INSERT INTO Cleansed_encounters
     (encounter_id,patient_id,provider_id,encounter_type,encounter_start,
     encounter_end,height_cm,weight_kg,systolic_bp,diastolic_bp)

     SELECT encounter_id,patient_id,provider_id,
     UPPER(TRIM(encounter_type)),encounter_start,
     encounter_end,height_cm,weight_kg, systolic_bp,diastolic_bp
     FROM [dev_HealthConnect_raw].[dbo].[RAW_encounters];

     SET @RowCount = @@ROWCOUNT;
     PRINT 'File: ' + @file_encounters   + ': ' + CAST(@RowCount AS VARCHAR(500)) + ' rows inserted.';

     -- Cleansed_claims table --    
     DECLARE @file_claims VARCHAR(100) = 'Cleansed_claims';

     INSERT INTO Cleansed_claims
     (claim_id,encounter_id,payer_id,admit_date,discharge_date,
     total_billed_amount,total_allowed_amount,total_paid_amount,claim_status)

     SELECT claim_id,encounter_id,payer_id, admit_date,discharge_date, 
     total_billed_amount, total_allowed_amount, total_paid_amount,
     UPPER(TRIM(claim_status))
     FROM [dev_HealthConnect_raw].[dbo].[RAW_claims];

     SET @RowCount = @@ROWCOUNT;
     PRINT 'File: ' + @file_claims   + ': ' + CAST(@RowCount AS VARCHAR(500)) + ' rows inserted.';

     -- Cleansed_diagnoses table -- 
     DECLARE @file_diagnoses VARCHAR(100) = 'Cleansed_diagnoses';

      INSERT INTO Cleansed_diagnoses (diagnosis_id,encounter_id,diagnosis_description,is_primary)
      SELECT diagnosis_id,encounter_id,
      UPPER(TRIM(diagnosis_description)),is_primary 
      FROM [dev_HealthConnect_raw].[dbo].[RAW_diagnoses];

      SET @RowCount = @@ROWCOUNT;
      PRINT 'File: ' + @file_diagnoses   + ': ' + CAST(@RowCount AS VARCHAR(500)) + ' rows inserted.';

     -- Cleansed_medication table -- 
     DECLARE @file_medications VARCHAR(100) = 'Cleansed_medications';

      INSERT INTO Cleansed_medications
      (medication_id,encounter_id,drug_name,route,dose,frequency,days_supply)

      SELECT medication_id,encounter_id,
      UPPER(TRIM(drug_name)),
      UPPER(TRIM(route)), 
      dose,
      UPPER(TRIM(frequency)), days_supply
      FROM [dev_HealthConnect_raw].[dbo].[RAW_medications];

      SET @RowCount = @@ROWCOUNT;
      PRINT 'File: ' + @file_medications   + ': ' + CAST(@RowCount AS VARCHAR(500)) + ' rows inserted.';

     -- Cleansed_procedures table -- 
     DECLARE @file_procedures VARCHAR(100) = 'Cleansed_procedures';

      INSERT INTO Cleansed_procedures
      (procedure_id,encounter_id,procedure_description)

      SELECT procedure_id,encounter_id, 
      UPPER(TRIM(procedure_description))
      FROM [dev_HealthConnect_raw].[dbo].[RAW_procedures];  

      SET @RowCount = @@ROWCOUNT;
      PRINT 'File: ' + @file_procedures   + ': ' + CAST(@RowCount AS VARCHAR(500)) + ' rows inserted.';
      END TRY 
      BEGIN CATCH
       if @@RowCount > 0
 
       PRINT 'ERROR while Loading Data From CLEANSED_LAYER To REFINED_LAYER: '+ @filepayers + @filepatients + @fileproviders + @file_encounters + @file_claims + @file_diagnoses + @file_medications + @file_procedures ;
       PRINT 'Error_Line: ' + CAST(ERROR_LINE() AS VARCHAR(30));
       PRINT 'Error Message: ' + ERROR_MESSAGE();
     END CATCH

      PRINT ''
      PRINT ' CLEANSED LAYER PROCESSED SUCCESSFULY DONE.'
      PRINT ''

END;

EXECUTE Proc_HealthConnect_Raw_To_Cleansed_Load;