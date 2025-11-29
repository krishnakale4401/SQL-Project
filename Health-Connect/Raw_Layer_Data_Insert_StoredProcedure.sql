CREATE OR ALTER PROCEDURE Proc_Sp_insert
@schema varchar(100),
@dbo varchar(100),
@tablename varchar(100),
@file varchar(1000)

AS
BEGIN
     SET NOCOUNT ON; -- start log process 
     DECLARE @trunc     VARCHAR(200);
     DECLARE @RowCount  INT;
     DECLARE @FileName VARCHAR(500)

BEGIN TRY
     ---- Truncate All Prewise Data ----
     SET @trunc='truncate table'+QUOTENAME(@schema)+'.'+QUOTENAME(@dbo)+'.'+QUOTENAME(@tablename)
     EXECUTE (@trunc); 

     ---- Load Data Source To RawLayer Using bluk insert Statement ----
   DECLARE @sql varchar(max)
   SET @sql='bulk insert'+QUOTENAME(@schema)+'.'+QUOTENAME(@dbo)+'.'+QUOTENAME(@tablename)+
   'from'+''''+@file+''''+
   'with(
    fieldterminator='','',  
    rowterminator=''\n'',
   firstrow=2  
   )'
   EXECUTE (@sql);

   SET @RowCount = @@ROWCOUNT;
   SET @FileName = RIGHT(@file, CHARINDEX('\', REVERSE(@file)) - 1);
   PRINT 'File: ' + @FileName + ': ' + CAST(@RowCount AS VARCHAR(10)) + ' rows inserted.';

 END TRY

 BEGIN CATCH
       if @@RowCount > 0
  
       PRINT 'ERROR while Loading Data From RAW_LAYER To CLEANSED_LAYER: ' + @file;
       PRINT 'Error_Line: ' + CAST(ERROR_LINE() AS VARCHAR(30));
       PRINT 'Error Message: ' + ERROR_MESSAGE();
   END CATCH -- end log process

END;