USE voorhees;
GO
/*
*   Contains information about meetings
*/
DROP TABLE IF EXISTS dbo.meeting;
GO
CREATE TABLE dbo.meeting
(
    meeting_id INT IDENTITY(1, 1) PRIMARY KEY
   ,meeting_date DATE NOT NULL
   ,sunshine_statement VARCHAR(MAX) NULL
);