USE voorhees;
GO
/*
note import_20201109 is here for testing only, if you have a real import
be sure to update the name appropriatly!
*/



--If the import table exists, drop it. This should really never drop a table in prod
DROP TABLE IF EXISTS dbo.import_20201109;
GO

--Create our import table 
CREATE TABLE dbo.import_20201109
(
    import_order INT PRIMARY KEY
   ,meeting_date VARCHAR(255) NOT NULL
   ,meeting_time VARCHAR(12) NOT NULL
   ,meeting_type VARCHAR(25) NOT NULL
   ,roll_call_1 VARCHAR(MAX) NULL
   ,roll_call_2 VARCHAR(MAX) NULL
   ,roll_call_3 VARCHAR(MAX) NULL
   ,roll_call_4 VARCHAR(MAX) NULL
   ,roll_call_5 VARCHAR(MAX) NULL
   ,sunshine VARCHAR(MAX) NULL
);

--Insert our imported data
BULK INSERT dbo.import_20201109
FROM '\\path\\to\\csv'
WITH
(
    FORMAT = 'CSV'
   ,KEEPNULLS
);

/*
cleanup header row. import order is an imported value, not assigned by SQL.
*/
DELETE  FROM dbo.import_20201109
WHERE   import_order = 1;

