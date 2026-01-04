CREATE OR ALTER PROCEDURE Proc_HealthConnect_Package
AS
BEGIN

EXECUTE [dev_HealthConnect_raw].[dbo].[Proc_HealthConnect_RawLoad];
EXECUTE [Dev_HealthConnect_Cleansed].[dbo].[Proc_HealthConnect_Raw_To_Cleansed_Load];
EXECUTE [Dev_HealthConnect_Refined].[dbo].[Proc_HealthConnect_Cleansed_To_Refined_Load];

END;
EXECUTE Proc_HealthConnect_Package;