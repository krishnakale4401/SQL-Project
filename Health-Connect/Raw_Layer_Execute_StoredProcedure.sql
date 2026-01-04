CREATE OR ALTER PROCEDURE Proc_HealthConnect_RawLoad
AS
BEGIN
    PRINT 'TRUNCATING ALL PAST DATA FROM RAW LAYER....';
    PRINT 'LOADING DATA SOURCE TO RAW LAYER.... ';
    PRINT '';

    DECLARE @yesterday VARCHAR(100);  -- yesterday date validation
    SET @yesterday = CONVERT(VARCHAR(8), DATEADD(DAY, -1, GETDATE()), 112);

    -- declare variables 

    DECLARE @claims varchar(max)
    DECLARE @payers varchar(max)
    DECLARE @diagnoses varchar(max)
    DECLARE @encounters varchar(max)
    DECLARE @medications varchar(max)
    DECLARE @patients varchar(max)
    DECLARE @procedures varchar(max)
    DECLARE @providers varchar(max)

    -- access file path and then  called the varable

    SET @claims ='D:\HealthConnect\InboundFiles\claims_' + @yesterday +'.csv';
    SET @payers ='D:\HealthConnect\InboundFiles\payers_' + @yesterday +'.csv';
    SET @diagnoses ='D:\HealthConnect\InboundFiles\diagnoses_' + @yesterday +'.csv';
    SET @encounters ='D:\HealthConnect\InboundFiles\encounters_' + @yesterday +'.csv';
    SET @medications ='D:\HealthConnect\InboundFiles\medications_' + @yesterday +'.csv';
    SET @patients ='D:\HealthConnect\InboundFiles\patients_' + @yesterday +'.csv';
    SET @procedures ='D:\HealthConnect\InboundFiles\procedures_' + @yesterday +'.csv';
    SET @providers ='D:\HealthConnect\InboundFiles\providers_' + @yesterday +'.csv';
    
    -- call the stored procedure help of using database, schema, tablename and varable 
    
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_claims',@claims;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_payers',@payers;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_diagnoses',@diagnoses;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_encounters',@encounters;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_medications',@medications;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_patients',@patients;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_procedures',@procedures;
    EXECUTE Proc_Sp_insert 'dev_HealthConnect_raw','dbo','RAW_providers',@providers;

PRINT ''
PRINT 'RAW LAYER PROCESSED SUCCESSFULY DONE.'
PRINT ''

END;

EXECUTE [dev_HealthConnect_raw].[dbo].[Proc_HealthConnect_RawLoad];

select * from [dev_HealthConnect_raw].[dbo].[RAW_payers]