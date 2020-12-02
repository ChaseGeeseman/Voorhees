USE voorhees;
SET XACT_ABORT ON;
SET NOCOUNT ON;
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
    EXEC dbo.ins_and_dup_check @meeting_id = @meeting_id    -- int
                              ,@ins_type = 0
                              ,@roll_1 = @roll1
                              ,@roll_2 = @roll2
                              ,@roll_3 = @roll3
                              ,@roll_4 = @roll4
                              ,@roll_5 = @roll5;
    SET @current_row = @current_row + 1;


END;


DROP TABLE IF EXISTS dbo.import_20201109_res;
GO

CREATE TABLE dbo.import_20201109_res
(
    import_order INT PRIMARY KEY
   ,res_meeting_id INT NOT NULL
        CONSTRAINT fk_import_20201109_res
        FOREIGN KEY( res_meeting_id )REFERENCES dbo.import_20201109_general( import_order )
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
    --ins_resolution
    SET @input_res_meeting_id =
    (
		SELECT m.meeting_id
		FROM dbo.meeting m
		WHERE m.meeting_date =
							(
								SELECT  ig.meeting_date
								FROM    dbo.import_20201109_res ir
									JOIN dbo.import_20201109_general ig
										ON ig.import_order = ir.res_meeting_id
								WHERE   ir.import_order = @current_row
							)
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


    --ins_meeting_order
    DECLARE @res_item_id INT =
            (
                SELECT  r.primary_key
                FROM    dbo.resolution r
                WHERE   r.res_meeting_id = @input_res_meeting_id
                        AND r.res_number = @input_res_number
                        AND COALESCE(   r.res_reading
                                       ,'255'
                                    ) = COALESCE(   COALESCE(   @input_res_reading
                                                               ,r.res_reading
                                                            )
                                                   ,'255'
                                                )
            );

    DECLARE @imported_meeting_order INT =
            (
                SELECT  ir.res_meeting_order
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            );

    EXEC dbo.ins_meeting_order @input_meeting_id = @input_res_meeting_id        -- int
                              ,@input_item_id = @res_item_id                    -- int
                              ,@input_item_type = 1                             -- All resolutions are 1
                              ,@input_meeting_order = @imported_meeting_order;  -- int
    SET @current_row = @current_row + 1;
END;

--Import the vote history for resolutions
BEGIN
    DECLARE @all_aye      BIT          =
            (
                SELECT  ir.all_aye
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@all_naye     BIT          =
            (
                SELECT  ir.all_naye
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_1      VARCHAR(255) =
            (
                SELECT  ir.voter_1
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_1_vote INT          =
            (
                SELECT  ir.voter_1_vote
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_2      VARCHAR(255) =
            (
                SELECT  ir.voter_2
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_2_vote INT          =
            (
                SELECT  ir.voter_2_vote
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_3      VARCHAR(255) =
            (
                SELECT  ir.voter_3
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_3_vote INT          =
            (
                SELECT  ir.voter_3_vote
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_4      VARCHAR(255) =
            (
                SELECT  ir.voter_4
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_4_vote INT          =
            (
                SELECT  ir.voter_4_vote
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_5      VARCHAR(255) =
            (
                SELECT  ir.voter_5
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            )
           ,@voter_5_vote INT          =
            (
                SELECT  ir.voter_5_vote
                FROM    dbo.import_20201109_res ir
                WHERE   ir.import_order = @current_row
            );



    EXEC dbo.ins_vote_history @all_aye = @all_aye               -- bit
                             ,@all_naye = @all_naye             -- bit
                             ,@voter_1 = @voter_1               -- varchar(255)
                             ,@voter_1_vote = @voter_1_vote     -- int
                             ,@voter_2 = @voter_2               -- varchar(255)
                             ,@voter_2_vote = @voter_2_vote     -- int
                             ,@voter_3 = @voter_3               -- varchar(255)
                             ,@voter_3_vote = @voter_3_vote     -- int
                             ,@voter_4 = @voter_4               -- varchar(255)
                             ,@voter_4_vote = @voter_4_vote     -- int
                             ,@voter_5 = @voter_5               -- varchar(255)
                             ,@voter_5_vote = @voter_5_vote     -- int
                             ,@input_vote_item = @res_item_id   -- int
                             ,@input_vote_item_type = 1;        -- int

END;

