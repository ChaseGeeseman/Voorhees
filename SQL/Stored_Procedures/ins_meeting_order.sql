USE voorhees;
GO

DROP PROCEDURE IF EXISTS ins_meeting_order;
GO
CREATE PROCEDURE ins_meeting_order
(
    @input_meeting_id INT
   ,@input_item_id INT
   ,@input_item_type INT
   ,@input_meeting_order INT
)
AS
BEGIN
    BEGIN TRY
	/*
        DECLARE @error_example VARCHAR(255) = 'message';
        RAISERROR(   'Example error %s' -- Message text.  
                    ,16                 -- Severity.  
                    ,1                  -- State.
                    ,@error_example     --Example variable insert, %d for INT types
                 );
	*/



        INSERT INTO dbo.meeting_order
        (
            meeting_id
           ,item_id
           ,item_type
           ,meeting_order
        )
        SELECT  @input_meeting_id       -- meeting_id - int
               ,@input_item_id          -- item_id - int
               ,@input_item_type        -- item_type - int
               ,@input_meeting_order    -- meeting_order - int
		--Check if this meeting id / order number have been used already
        WHERE   NOT EXISTS
        (
            SELECT  mo.meeting_id
            FROM    dbo.meeting_order mo
            WHERE   mo.meeting_id = @input_meeting_id
                    AND mo.meeting_order = @input_meeting_order
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