USE voorhees;
GO
DROP PROCEDURE IF EXISTS dbo.ins_attendance;
GO
CREATE PROCEDURE ins_attendance
(
    @meeting_id INT
   ,@person_id INT
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.attendance
    (
        meeting_id
       ,person_id
    )
    SELECT  @meeting_id
           ,@person_id
    WHERE   NOT EXISTS
    (
        SELECT  @meeting_id
        FROM    dbo.attendance AS a
        WHERE   a.meeting_id = @meeting_id
                AND a.person_id = @person_id
    );
END;
GO