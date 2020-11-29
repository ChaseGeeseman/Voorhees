USE voorhees;
GO
/*
*   Contains meeting attattendance information
*/
DROP TABLE IF EXISTS dbo.attendance;
GO
CREATE TABLE dbo.attendance
(
    primary_key INT IDENTITY(1, 1) PRIMARY KEY
   ,meeting_id INT NOT NULL
   ,CONSTRAINT fk_attendance_meeting_id
        FOREIGN KEY( meeting_id )
        REFERENCES dbo.meeting( meeting_id )
   ,person_id INT NOT NULL
   ,CONSTRAINT attendance_fk_person_id
        FOREIGN KEY( person_id )
        REFERENCES dbo.people( person_id ),
);