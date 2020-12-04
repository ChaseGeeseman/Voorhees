CREATE TABLE dbo.meeting
(
    meeting_id INT IDENTITY(1, 1) PRIMARY KEY
   ,meeting_date DATE NOT NULL
   ,sunshine_statement VARCHAR(MAX) NULL
);