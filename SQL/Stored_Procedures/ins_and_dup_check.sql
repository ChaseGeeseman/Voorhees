USE voorhees;
GO
DROP FUNCTION IF EXISTS dbo.ins_and_dup_check;
GO
CREATE PROCEDURE dbo.ins_and_dup_check
(
    @last_name_to_check VARCHAR(MAX)
   ,@meeting_id INT
   ,@ins_type INT
)
AS
BEGIN
    BEGIN TRY
        DECLARE @duplicate_check INT = 0;
        SET @duplicate_check =
        (
            SELECT  COUNT(*)
            FROM    dbo.people ppl
            WHERE   ppl.last_name = @last_name_to_check
        );
        IF( @duplicate_check > 1 )
        BEGIN
            RAISERROR(   '%d people have the last name %s, please provide a first name.'    -- Message text.  
                        ,16                                                                 -- Severity.  
                        ,1                                                                  -- State.  
                        ,@duplicate_check
                        ,@last_name_to_check
                     );
            --TO DO, look into custom return errors?
            RETURN -1;
        END;


        DECLARE @input_person_id INT =
                (
                    SELECT  ppl2.person_id
                    FROM    dbo.people ppl2
                    WHERE   ppl2.last_name = @last_name_to_check
                );
        IF( @ins_type = 0 )
        BEGIN
            EXEC dbo.ins_attendance_insert @input_meeting_id = @meeting_id  -- int
                                          ,@input_person_id = @input_person_id;
            RETURN 0;
        END;
        IF( @ins_type = 1 )
        BEGIN
            RETURN 0;
        END;
        RETURN 0;


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