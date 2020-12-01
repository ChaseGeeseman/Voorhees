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
    BEGIN TRY
        IF EXISTS
        (
            SELECT  m.meeting_date
            FROM    dbo.meeting m
            WHERE   m.meeting_date = @ins_meeting_date
        )
        BEGIN
            DECLARE @meeting_var VARCHAR(255) = CAST(@ins_meeting_date AS VARCHAR(255));
            RAISERROR(   'A meeting record for %s already exists'   -- Message text.  
                        ,16                                         -- Severity.  
                        ,1                                          -- State.
                        ,@meeting_var                               --Example variable insert, %d for INT types
                     );
        END;
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
            FROM    dbo.meeting m
            WHERE   m.meeting_date = @ins_meeting_date
        );
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage  NVARCHAR(4000)
               ,@ErrorSeverity INT
               ,@ErrorState    INT;

        SELECT  @ErrorMessage  = ERROR_MESSAGE()
               ,@ErrorSeverity = ERROR_SEVERITY()
               ,@ErrorState    = ERROR_STATE();

        -- Use RAISERROR inside the CATCH block to return error  
        -- information about the original error that caused  
        -- execution to jump to the CATCH block.  
        RAISERROR(   @ErrorMessage  -- Message text.  
                    ,@ErrorSeverity -- Severity.  
                    ,@ErrorState    -- State.  
                 );
    END CATCH;

END;
GO
