USE voorhees;
GO
DROP PROCEDURE IF EXISTS dbo.ins_attendance;
GO
CREATE PROCEDURE ins_attendance
(
    @input_meeting_id INT
   ,@input_person_id INT = NULL
   ,@input_last_name VARCHAR(MAX) = NULL
   ,@input_first_name VARCHAR(MAX) = NULL
   ,@input_roll_1 VARCHAR(MAX) = NULL
   ,@input_roll_2 VARCHAR(MAX) = NULL
   ,@input_roll_3 VARCHAR(MAX) = NULL
   ,@input_roll_4 VARCHAR(MAX) = NULL
   ,@input_roll_5 VARCHAR(MAX) = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        DECLARE @duplicate_check INT;

        IF(
              @input_person_id IS NULL
              AND
                (
                    @input_roll_1 IS NULL
                    AND @input_roll_2 IS NULL
                    AND @input_roll_3 IS NULL
                    AND @input_roll_4 IS NULL
                    AND @input_roll_5 IS NULL
                )
          )
        BEGIN
            IF( @input_last_name IS NULL AND @input_first_name IS NULL )
                RAISERROR(
                             '@input_person_id, @input_last_name, and @input_first_name cannot all be null' -- Message text.  
                            ,16                                                                             -- Severity.  
                            ,1                                                                              -- State.  
                         );
            IF( @input_first_name IS NULL )
            BEGIN
                IF( @input_last_name IS NULL )
                    RAISERROR(   '@input_person_id OR @input_last_name is required' -- Message text.  
                                ,16                                                 -- Severity.  
                                ,1                                                  -- State.
                             );
            END;


            --If there's only one match to a first name, we assume that person is a match.
            SET @duplicate_check =
            (
                SELECT  COUNT(*)FROM    dbo.people ppl WHERE   ppl.last_name = @input_last_name
            );
            IF( @duplicate_check > 1 )
                RAISERROR(   '%d people have the last name %s, please provide a first name.'    -- Message text.  
                            ,16                                                                 -- Severity.  
                            ,1                                                                  -- State.  
                            ,@duplicate_check
                            ,@input_last_name
                         );

            SET @input_person_id =
            (
                SELECT  ppl.person_id
                FROM    dbo.people ppl
                WHERE   ppl.last_name = @input_last_name
            );
        END;

        --IF ROLL CALL NOT NULL
        IF(
              @input_roll_1 IS NOT NULL
              OR @input_roll_2 IS NOT NULL
              OR @input_roll_3 IS NOT NULL
              OR @input_roll_4 IS NOT NULL
              OR @input_roll_5 IS NOT NULL
          )
        BEGIN

            --The helper will ignore NULL values, so just pass them all in
            EXEC dbo.ins_attendance_insert @input_meeting_id = @input_meeting_id
                                          ,@input_person_id = @input_roll_1;
            EXEC dbo.ins_attendance_insert @input_meeting_id = @input_meeting_id
                                          ,@input_person_id = @input_roll_2;
            EXEC dbo.ins_attendance_insert @input_meeting_id = @input_meeting_id
                                          ,@input_person_id = @input_roll_3;
            EXEC dbo.ins_attendance_insert @input_meeting_id = @input_meeting_id
                                          ,@input_person_id = @input_roll_4;
            EXEC dbo.ins_attendance_insert @input_meeting_id = @input_meeting_id
                                          ,@input_person_id = @input_roll_5;

            --If we have roll call we don't have first or last names so let's get out of here
            RETURN 0;
        END;
        --IF ROLL CALL NULL
        EXEC dbo.ins_attendance_insert @input_meeting_id = @input_meeting_id
                                      ,@input_person_id = @input_person_id;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

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

