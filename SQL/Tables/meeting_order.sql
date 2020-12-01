USE voorhees;
GO
/*
*   Contains information about meetings
*/
DROP TABLE IF EXISTS dbo.meeting_order;
GO
CREATE TABLE dbo.meeting_order
(
    meeting_order_pk INT IDENTITY(1, 1) PRIMARY KEY
   ,meeting_id INT NOT NULL
        CONSTRAINT meeting_order_fk
        FOREIGN KEY( meeting_id )REFERENCES dbo.meeting( meeting_id )
	--This will reference the primary key of the resolution or ordinance 
   ,item_id INT NOT NULL
   ,meeting_order INT NOT NULL
);