USE voorhees;
SET XACT_ABORT ON;
GO

/*
note import_20201109_general_general is here for testing only, if you have a real import
be sure to update the name appropriatly!
*/



--If the import table exists, drop it. This should really never drop a table in prod
DROP TABLE IF EXISTS dbo.import_20201109_general;
GO

--Create our import table 
CREATE TABLE dbo.import_20201109_general
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
BULK INSERT dbo.import_20201109_general
FROM 'D:\Downloads\test-general.csv'
WITH
(
    FORMAT = 'CSV'
   ,KEEPNULLS
);

/*
cleanup header row. import order is an imported value, not assigned by SQL.
*/
DELETE  FROM dbo.import_20201109_general
WHERE   import_order = 1;


/*
Loop through the imported results and insert into the appropriate tables
*/
DECLARE @last_row           INT =
        (
            SELECT  MAX(i.import_order)FROM dbo.import_20201109_general i
        )
       ,@current_row        INT = 2
        --Needed for ins_meeting
       ,@date_to_insert     DATE
       ,@sunshine_to_insert VARCHAR(MAX)
        --Needed for ins_attendance
       ,@meeting_id         INT;

WHILE( @current_row <= @last_row )
BEGIN


    --Import meeting date and sunshine statement
    --Import order is the table Primary Key so it will always only return 1 number.
    SET @date_to_insert =
    (
        SELECT  i.meeting_date
        FROM    dbo.import_20201109_general i
        WHERE   i.import_order = @current_row
    );
    SET @sunshine_to_insert =
    (
        SELECT  i.sunshine
        FROM    dbo.import_20201109_general i
        WHERE   i.import_order = @current_row
    );
    EXEC dbo.ins_meeting @ins_meeting_date = @date_to_insert
                        ,@ins_sunshine_statement = @sunshine_to_insert;

    --We have checks in place to prevent more than one meeting occuring a day so this returns 1 value
    SET @meeting_id =
    (
        SELECT  m.meeting_id
        FROM    dbo.meeting m
        WHERE   m.meeting_date = @date_to_insert
    );

    DECLARE @roll1 VARCHAR(MAX) =
            (
                SELECT  dbo.fun_format_name(i.roll_call_1)
                FROM    dbo.import_20201109_general i
                WHERE   i.import_order = @current_row
            )
           ,@roll2 VARCHAR(MAX) =
            (
                SELECT  dbo.fun_format_name(i.roll_call_2)
                FROM    dbo.import_20201109_general i
                WHERE   i.import_order = @current_row
            )
           ,@roll3 VARCHAR(MAX) =
            (
                SELECT  dbo.fun_format_name(i.roll_call_3)
                FROM    dbo.import_20201109_general i
                WHERE   i.import_order = @current_row
            )
           ,@roll4 VARCHAR(MAX) =
            (
                SELECT  dbo.fun_format_name(i.roll_call_4)
                FROM    dbo.import_20201109_general i
                WHERE   i.import_order = @current_row
            )
           ,@roll5 VARCHAR(MAX) =
            (
                SELECT  dbo.fun_format_name(i.roll_call_5)
                FROM    dbo.import_20201109_general i
                WHERE   i.import_order = @current_row
            );
    EXEC dbo.ins_attendance @input_meeting_id = @meeting_id -- int
                           ,@input_roll_1 = @roll1
                           ,@input_roll_2 = @roll2
                           ,@input_roll_3 = @roll3
                           ,@input_roll_4 = @roll4
                           ,@input_roll_5 = @roll5;
    SET @current_row = @current_row + 1;


END;


DROP TABLE IF EXISTS dbo.import_20201109_res;
GO

CREATE TABLE dbo.import_20201109_res
(
    import_order INT PRIMARY KEY
   ,res_meeting_id INT NOT NULL
        CONSTRAINT fk_import_20201109_res
        FOREIGN KEY( res_meeting_id )REFERENCES dbo.meeting( meeting_id )
   ,res_meeting_order VARCHAR(MAX) NOT NULL
   ,res_reading VARCHAR(MAX) NULL
   ,res_number VARCHAR(MAX) NULL
   ,res_title VARCHAR(MAX) NULL
   ,where_as VARCHAR(MAX) NULL
   ,now_therefore VARCHAR(MAX) NULL
   ,dated VARCHAR(MAX) NOT NULL
   ,all_aye VARCHAR(MAX) NULL
   ,all_naye VARCHAR(MAX) NULL
   ,voter_1 VARCHAR(MAX) NULL
   ,voter_1_vote VARCHAR(MAX) NULL
   ,voter_2 VARCHAR(MAX) NULL
   ,voter_2_vote VARCHAR(MAX) NULL
   ,voter_3 VARCHAR(MAX) NULL
   ,voter_3_vote VARCHAR(MAX) NULL
   ,voter_4 VARCHAR(MAX) NULL
   ,voter_4_vote VARCHAR(MAX) NULL
   ,voter_5 VARCHAR(MAX) NULL
   ,voter_5_vote VARCHAR(MAX) NULL
);


--Insert our imported data
BULK INSERT dbo.import_20201109_res
FROM 'D:\Downloads\test-res.csv'
WITH
(
    FORMAT = 'CSV'
   ,KEEPNULLS
);

/*
cleanup header row. import order is an imported value, not assigned by SQL.
*/
DELETE  FROM dbo.import_20201109_res
WHERE   import_order = 1;



/*
Loop through the imported results and insert into the appropriate tables
*/
DECLARE @last_row             INT =
        (
            SELECT  MAX(i.import_order)FROM dbo.import_20201109_res i
        )
       ,@current_row          INT = 2
        --Needed for ins_resolution
       ,@input_res_meeting_id INT
       ,@input_res_reading    VARCHAR(MAX)
       ,@input_res_number     VARCHAR(MAX)
       ,@input_res_title      VARCHAR(MAX)
       ,@input_where_as       VARCHAR(MAX)
       ,@input_now_therefore  VARCHAR(MAX)
       ,@input_dated          DATE;

WHILE( @current_row <= @last_row )
BEGIN

    SET @input_res_meeting_id =
    (
        SELECT  ir.res_meeting_id
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );
    SET @input_res_reading =
    (
        SELECT  ir.res_reading
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );
    SET @input_res_number =
    (
        SELECT  ir.res_number
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );
    SET @input_res_title =
    (
        SELECT  ir.res_title
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );
    SET @input_where_as =
    (
        SELECT  ir.where_as
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );
    SET @input_now_therefore =
    (
        SELECT  ir.now_therefore
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );
    SET @input_dated =
    (
        SELECT  ir.dated
        FROM    dbo.import_20201109_res ir
        WHERE   ir.import_order = @current_row
    );

    EXEC dbo.ins_resolution @res_meeting_id = @input_res_meeting_id
                           ,@res_reading = @input_res_reading
                           ,@res_number = @input_res_number
                           ,@res_title = @input_res_title
                           ,@where_as = @input_where_as
                           ,@now_therefore = @input_now_therefore
                           ,@dated = @input_dated;

    SET @current_row = @current_row + 1;

END;
