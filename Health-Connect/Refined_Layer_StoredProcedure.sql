--- REFINED PROCEDURE -- 

CREATE OR ALTER PROCEDURE Proc_HealthConnect_Cleansed_To_Refined_Load
AS 
BEGIN
    SET NOCOUNT ON;

    PRINT 'LOADING DATA CLEANSED TO REFINSED LAYER....';
    PRINT '';
BEGIN TRY
    DECLARE @Inserted INT, @Updated INT;

    -- PAYERS TABLE
    
    DECLARE @Refinsed_payers TABLE (ActionType VARCHAR(20));

    MERGE INTO Refinsed_payers AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_payers] AS C
    ON R.payer_id = C.payer_id
    WHEN MATCHED 
        AND (ISNULL(R.payer_name,'') != ISNULL(C.payer_name,''))
    THEN
        UPDATE SET
            R.payer_name = C.payer_name,
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (payer_id, payer_name, LoadDate) 
        VALUES (C.payer_id, C.payer_name, C.LoadDate)
    OUTPUT $action INTO @Refinsed_payers;


    SELECT @Inserted = COUNT(*) FROM @Refinsed_payers WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_payers WHERE ActionType = 'UPDATE';

    PRINT 'Refined_payers Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_payers Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';

    -- PATIENTS TABLE

    DECLARE @Refinsed_patients TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_patients]  AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_patients] AS C
    ON R.patient_id = C.patient_id
    WHEN MATCHED 
        AND (
            ISNULL(R.first_name,'') != ISNULL(C.first_name,'')
            OR ISNULL(R.last_name,'') != ISNULL(C.last_name,'')
            OR ISNULL(R.gender,'') != ISNULL(C.gender,'')
            OR ISNULL(CONVERT(VARCHAR(10),R.date_of_birth,120),'1900-01-01') != ISNULL(CONVERT(VARCHAR(10),C.date_of_birth,120),'1900-01-01')
            OR ISNULL(R.state_code,'') != ISNULL(C.state_code,'')
            OR ISNULL(R.city,'') != ISNULL(C.city,'')
            OR ISNULL(R.phone,'') != ISNULL(C.phone,'')
        )
    THEN
        UPDATE SET
            R.first_name = C.first_name,
            R.last_name = C.last_name,
            R.gender = C.gender,
            R.date_of_birth = C.date_of_birth,
            R.city = C.city,
            R.state_code = C.state_code,
            R.phone = C.phone,
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (patient_id, first_name, last_name, gender, date_of_birth, state_code, city, phone, LoadDate) 
        VALUES (C.patient_id, C.first_name, C.last_name, C.gender, C.date_of_birth, C.state_code, C.city, C.phone, C.LoadDate)
    OUTPUT $action INTO @Refinsed_patients;

    SELECT @Inserted = COUNT(*) FROM @Refinsed_patients WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_patients WHERE ActionType = 'UPDATE';

    PRINT 'Refined_patients Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_patients Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';
  
    -- PROVIDERS TABLE
    
    DECLARE @Refinsed_providers TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_providers] AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_providers] AS C
    ON R.provider_id = C.provider_id
    WHEN MATCHED 
        AND (
            ISNULL(R.first_name,'') != ISNULL(C.first_name,'')
            OR ISNULL(R.last_name,'') != ISNULL(C.last_name,'')
            OR ISNULL(R.specialty,'') != ISNULL(C.specialty,'')
            OR ISNULL(R.npi,'') != ISNULL(C.npi,'')
        )
    THEN
        UPDATE SET 
            R.first_name = C.first_name, 
            R.last_name = C.last_name, 
            R.specialty = C.specialty, 
            R.npi = C.npi, 
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (provider_id, first_name, last_name, specialty, npi, LoadDate) 
        VALUES (C.provider_id, C.first_name, C.last_name, C.specialty, C.npi, C.LoadDate)
    OUTPUT $action INTO @Refinsed_providers;
    -- End MERGE

    SELECT @Inserted = COUNT(*) FROM @Refinsed_providers WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_providers WHERE ActionType = 'UPDATE';

    PRINT 'Refined_providers Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_providers Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';

    
    -- ENCOUNTERS TABLE
    
    DECLARE @Refinsed_encounters TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_encounters] AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_encounters] AS C
    ON R.encounter_id = C.encounter_id
    WHEN MATCHED 
        AND (
            ISNULL(R.encounter_type,'') != ISNULL(C.encounter_type,'')
            OR ISNULL(CONVERT(VARCHAR(30),R.encounter_start,120),'') != ISNULL(CONVERT(VARCHAR(30),C.encounter_start,120),'')
            OR ISNULL(CONVERT(VARCHAR(30),R.encounter_end,120),'') != ISNULL(CONVERT(VARCHAR(30),C.encounter_end,120),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.height_cm),'') != ISNULL(CONVERT(VARCHAR(50),C.height_cm),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.weight_kg),'') != ISNULL(CONVERT(VARCHAR(50),C.weight_kg),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.systolic_bp),'') != ISNULL(CONVERT(VARCHAR(50),C.systolic_bp),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.diastolic_bp),'') != ISNULL(CONVERT(VARCHAR(50),C.diastolic_bp),'')
        )
    THEN
        UPDATE SET 
            R.encounter_type = C.encounter_type, 
            R.encounter_start = C.encounter_start, 
            R.encounter_end = C.encounter_end, 
            R.height_cm = C.height_cm, 
            R.weight_kg = C.weight_kg, 
            R.systolic_bp = C.systolic_bp, 
            R.diastolic_bp = C.diastolic_bp, 
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (encounter_id, patient_id, provider_id, encounter_type, encounter_start, encounter_end, height_cm, weight_kg, systolic_bp, diastolic_bp, LoadDate)
        VALUES (C.encounter_id, C.patient_id, C.provider_id, C.encounter_type, C.encounter_start, C.encounter_end, C.height_cm, C.weight_kg, C.systolic_bp, C.diastolic_bp, C.LoadDate)
    OUTPUT $action INTO @REFINSED_encounters;
    -- End MERGE

    SELECT @Inserted = COUNT(*) FROM @Refinsed_encounters WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_encounters WHERE ActionType = 'UPDATE';

    PRINT 'Refined_encounters Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_encounters Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';

    
    -- DIAGNOSES TABLE
    
    DECLARE @Refinsed_diagnoses TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_diagnoses] AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_diagnoses] AS C
    ON R.diagnosis_id = C.diagnosis_id
    WHEN MATCHED 
        AND (
            ISNULL(R.diagnosis_description,'') != ISNULL(C.diagnosis_description,'')
            OR ISNULL(CONVERT(VARCHAR(10),R.is_primary),'') != ISNULL(CONVERT(VARCHAR(10),C.is_primary),'')
        )
    THEN
        UPDATE SET 
            R.diagnosis_description = C.diagnosis_description,
            R.is_primary = C.is_primary, 
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (diagnosis_id, encounter_id, diagnosis_description, is_primary, LoadDate)
        VALUES (C.diagnosis_id, C.encounter_id, C.diagnosis_description, C.is_primary, C.LoadDate)
    OUTPUT $action INTO @REFINSED_diagnoses;

    SELECT @Inserted = COUNT(*) FROM @Refinsed_diagnoses WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_diagnoses WHERE ActionType = 'UPDATE';

    PRINT 'Refined_diagnoses Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_diagnoses Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';
  
    -- MEDICATIONS TABLE
    
    DECLARE @Refinsed_medications TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_medications] AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_medications] AS C
    ON R.medication_id = C.medication_id
    WHEN MATCHED 
        AND (
            ISNULL(R.drug_name,'') != ISNULL(C.drug_name,'')
            OR ISNULL(R.route,'') != ISNULL(C.route,'')
            OR ISNULL(CONVERT(VARCHAR(50),R.dose),'') != ISNULL(CONVERT(VARCHAR(50),C.dose),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.frequency),'') != ISNULL(CONVERT(VARCHAR(50),C.frequency),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.days_supply),'') != ISNULL(CONVERT(VARCHAR(50),C.days_supply),'')
        )
    THEN
        UPDATE SET
            R.drug_name = C.drug_name, 
            R.route = C.route, 
            R.dose = C.dose, 
            R.frequency = C.frequency, 
            R.days_supply = C.days_supply,   
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (medication_id, encounter_id, drug_name, route, dose, frequency, days_supply, LoadDate)
        VALUES (C.medication_id, C.encounter_id, C.drug_name, C.route, C.dose, C.frequency, C.days_supply, C.LoadDate)
    OUTPUT $action INTO @Refinsed_medications;
    -- End MERGE

    SELECT @Inserted = COUNT(*) FROM @Refinsed_medications WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_medications WHERE ActionType = 'UPDATE';

    PRINT 'Refined_medications Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_medications Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';
    
    -- PROCEDURES TABLE
    
    DECLARE @Refinsed_procedures TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_procedures] AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_procedures] AS C
    ON R.procedure_id = C.procedure_id
    WHEN MATCHED
        AND (ISNULL(R.procedure_description,'') != ISNULL(C.procedure_description,''))
    THEN
        UPDATE SET  
            R.procedure_description = C.procedure_description, 
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (procedure_id, encounter_id, procedure_description, LoadDate)
        VALUES (C.procedure_id, C.encounter_id, C.procedure_description, C.LoadDate)
    OUTPUT $action INTO @REFINSED_procedures;
    -- End MERGE

    SELECT @Inserted = COUNT(*) FROM @Refinsed_procedures WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_procedures WHERE ActionType = 'UPDATE';

    PRINT 'Refined_procedures Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_procedures Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';
 
    -- CLAIMS TABLE
    
    DECLARE @Refinsed_claims TABLE (ActionType VARCHAR(20));

    MERGE INTO [Dev_HealthConnect_Refined].[dbo].[Refinsed_claims]  AS R
    USING [Dev_HealthConnect_Cleansed].[dbo].[Cleansed_claims] AS C
    ON R.claim_id = C.claim_id
    WHEN MATCHED
        AND (
            ISNULL(CONVERT(VARCHAR(30),R.admit_date,120),'') != ISNULL(CONVERT(VARCHAR(30),C.admit_date,120),'')
            OR ISNULL(CONVERT(VARCHAR(30),R.discharge_date,120),'') != ISNULL(CONVERT(VARCHAR(30),C.discharge_date,120),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.total_billed_amount),'') != ISNULL(CONVERT(VARCHAR(50),C.total_billed_amount),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.total_allowed_amount),'') != ISNULL(CONVERT(VARCHAR(50),C.total_allowed_amount),'')
            OR ISNULL(CONVERT(VARCHAR(50),R.total_paid_amount),'') != ISNULL(CONVERT(VARCHAR(50),C.total_paid_amount),'')
            OR ISNULL(R.claim_status,'') != ISNULL(C.claim_status,'')
        )
    THEN
        UPDATE SET 
            R.admit_date = C.admit_date, 
            R.discharge_date = C.discharge_date, 
            R.total_billed_amount = C.total_billed_amount, 
            R.total_allowed_amount = C.total_allowed_amount, 
            R.total_paid_amount = C.total_paid_amount, 
            R.claim_status = C.claim_status, 
            R.Last_Modified_Date = GETDATE()
    WHEN NOT MATCHED THEN 
        INSERT (claim_id, encounter_id, payer_id, admit_date, discharge_date, total_billed_amount, total_allowed_amount, total_paid_amount, claim_status, LoadDate)
        VALUES (C.claim_id, C.encounter_id, C.payer_id, C.admit_date, C.discharge_date, C.total_billed_amount, C.total_allowed_amount, C.total_paid_amount, C.claim_status, C.LoadDate)
    OUTPUT $action INTO @Refinsed_claims;


    SELECT @Inserted = COUNT(*) FROM @Refinsed_claims WHERE ActionType = 'INSERT';
    SELECT @Updated  = COUNT(*) FROM @Refinsed_claims WHERE ActionType = 'UPDATE';

    PRINT 'Refined_claims Inserted Records Successfully: ' + CAST(ISNULL(@Inserted,0) AS VARCHAR(10));
    PRINT 'Refined_claims Updated Records Successfully: '  + CAST(ISNULL(@Updated,0)  AS VARCHAR(10));
    PRINT '';

    PRINT 'REFINED LAYER PROCESSED SUCCESSFULLY DONE.';

    END TRY
    BEGIN CATCH
       if @@RowCount > 0
      
       PRINT 'ERROR while Loading Data From CLEANSED_LAYER To REFINED_LAYER: '
       PRINT 'Error_Line: ' + CAST(ERROR_LINE() AS VARCHAR(30));
       PRINT 'Error Message: ' + ERROR_MESSAGE();
   END CATCH
END;

EXECUTE Dev_HealthConnect_Refined.dbo.Proc_HealthConnect_Cleansed_To_Refined_Load;