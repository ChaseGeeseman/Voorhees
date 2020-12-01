USE voorhees;
GO
DROP FUNCTION IF EXISTS dbo.ins_and_dup_check;
GO
CREATE PROCEDURE dbo.ins_and_dup_check
(
    @last_name_to_check VARCHAR(MAX)
   ,@meeting_id INT
   ,@ins_type INT
   ,@all_aye BIT = NULL             -- bit
   ,@all_naye BIT = NULL            -- bit
   ,@voter_1 VARCHAR(255) = NULL    -- varchar(255)
   ,@voter_1_vote INT = NULL        -- int
   ,@voter_2 VARCHAR(255) = NULL    -- varchar(255)
   ,@voter_2_vote INT = NULL        -- int
   ,@voter_3 VARCHAR(255) = NULL    -- varchar(255)
   ,@voter_3_vote INT = NULL        -- int
   ,@voter_4 VARCHAR(255) = NULL    -- varchar(255)
   ,@voter_4_vote INT = NULL        -- int
   ,@voter_5 VARCHAR(255) = NULL    -- varchar(255)
   ,@voter_5_vote INT = NULL        -- int
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
        --0 = attendance
        IF( @ins_type = 0 )
        BEGIN
            EXEC dbo.ins_attendance_insert @input_meeting_id = @meeting_id  -- int
                                          ,@input_person_id = @input_person_id;
            RETURN 0;
        END;
        --1 = resolution
        IF( @ins_type = 1 )
        BEGIN
            EXEC dbo.ins_vote_history @all_aye = @all_aye       -- bit
                                     ,@all_naye = @all_naye      -- bit
                                     ,@voter_1 = @voter_1         -- varchar(255)
                                     ,@voter_1_vote = @voter_1_vote     -- int
                                     ,@voter_2 = @voter_2        -- varchar(255)
                                     ,@voter_2_vote = @voter_2_vote     -- int
                                     ,@voter_3 = @voter_3         -- varchar(255)
                                     ,@voter_3_vote = @voter_3_vote     -- int
                                     ,@voter_4 = @voter_4         -- varchar(255)
                                     ,@voter_4_vote = @voter_4_vote     -- int
                                     ,@voter_5 = @voter_5         -- varchar(255)
                                     ,@voter_5_vote = @voter_5_vote;    -- int

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