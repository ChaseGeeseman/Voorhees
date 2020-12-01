USE voorhees;
GO

DROP PROCEDURE IF EXISTS dbo.ins_vote_history;
GO

CREATE PROCEDURE dbo.ins_vote_history
(
    @all_aye BIT
   ,@all_naye BIT
   ,@voter_1 VARCHAR(255) = NULL
   ,@voter_1_vote INT
   ,@voter_2 VARCHAR(255) = NULL
   ,@voter_2_vote INT
   ,@voter_3 VARCHAR(255) = NULL
   ,@voter_3_vote INT
   ,@voter_4 VARCHAR(255) = NULL
   ,@voter_4_vote INT
   ,@voter_5 VARCHAR(255) = NULL
   ,@voter_5_vote INT
)
AS
BEGIN
    BEGIN TRY
        DECLARE @error_example VARCHAR(255) = 'message';
        RAISERROR(   'Example error %s' -- Message text.  
                    ,16                 -- Severity.  
                    ,1                  -- State.
                    ,@error_example     --Example variable insert, %d for INT types
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
