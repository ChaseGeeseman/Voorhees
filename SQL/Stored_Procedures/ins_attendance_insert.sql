USE voorhees;
GO

CREATE PROCEDURE dbo.ins_attendance_insert
(
    @input_meeting_id INT
   ,@input_person_id INT = NULL
)
AS
BEGIN
    IF( @input_person_id IS NOT NULL )
    BEGIN
        INSERT INTO dbo.attendance
        (
            meeting_id
           ,person_id
        )
        SELECT  @input_meeting_id
               ,@input_person_id
        WHERE   NOT EXISTS
        (
            SELECT  @input_meeting_id
            FROM    dbo.attendance a
            WHERE   a.meeting_id = @input_meeting_id
                    AND a.person_id = @input_person_id
        );
    END;
END;
GO


