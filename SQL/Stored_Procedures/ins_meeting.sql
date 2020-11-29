USE voorhees;
GO
DROP PROCEDURE IF EXISTS dbo.ins_meeting;
GO
CREATE PROCEDURE ins_meeting
(
    @ins_meeting_date DATE
   ,@ins_sunshine_statement VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.meeting
    (
        meeting_date
       ,sunshine_statement
    )
    SELECT  @ins_meeting_date
           ,@ins_sunshine_statement
    WHERE   NOT EXISTS
    (
        SELECT  @ins_meeting_date
        FROM    dbo.meeting AS m
        WHERE   m.meeting_date = @ins_meeting_date
    );
END;
GO
