BULK INSERT dbo.import_general
FROM 'D:\Downloads\test-general.csv'
WITH
(
    FORMAT = 'CSV'
   ,KEEPNULLS
);