CREATE TABLE dbo.Table1
(
    Id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
   ,import_order INT NULL
   ,meeting_date VARCHAR(MAX) NULL
   ,meeting_time VARCHAR(MAX) NULL
   ,meeting_type VARCHAR(MAX) NULL
   ,roll_call VARCHAR(MAX) NULL
   ,sunshine_statement VARCHAR(MAX) NULL
   ,comments VARCHAR(MAX) NULL
);
