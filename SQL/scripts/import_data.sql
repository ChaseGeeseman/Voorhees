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




/*
Loop through the imported results and insert into the appropriate tables
*/

DECLARE @last_row           INT =
        (
            SELECT  MAX(i.import_order)FROM dbo.import_20201109 AS i
        )
       ,@current_row        INT = 2
        --Needed for ins_meeting
       ,@date_to_insert     DATE
       ,@sunshine_to_insert VARCHAR(MAX);

WHILE( @current_row <= @last_row )
BEGIN
    SELECT  @current_row;
    --Import order is the table Primary Key so it will always only return 1 number.
    SET @date_to_insert =
    (
        SELECT  i.meeting_date
        FROM    dbo.import_20201109 AS i
        WHERE   i.import_order = @current_row
    );
    SET @sunshine_to_insert =
    (
        SELECT  i.sunshine
        FROM    dbo.import_20201109 AS i
        WHERE   i.import_order = @current_row
    );
    EXEC dbo.ins_meeting @meeting_date = @date_to_insert
                        ,@sunshine_statement = @sunshine_to_insert;
    SET @current_row = @current_row + 1;
END;


