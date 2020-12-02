USE voorhees;
GO
DROP PROCEDURE IF EXISTS dbo.ins_and_dup_check;
GO
CREATE PROCEDURE dbo.ins_and_dup_check
(
    @last_name_to_check VARCHAR(255) = NULL
   ,@meeting_id INT
   ,@ins_type INT
   ,@all_aye BIT = NULL         -- bit
   ,@all_naye BIT = NULL        -- bit
   ,@roll_1 VARCHAR(255) = NULL -- varchar(255)
   ,@roll_1_vote INT = NULL     -- int
   ,@roll_2 VARCHAR(255) = NULL -- varchar(255)
   ,@roll_2_vote INT = NULL     -- int
   ,@roll_3 VARCHAR(255) = NULL -- varchar(255)
   ,@roll_3_vote INT = NULL     -- int
   ,@roll_4 VARCHAR(255) = NULL -- varchar(255)
   ,@roll_4_vote INT = NULL     -- int
   ,@roll_5 VARCHAR(255) = NULL -- varchar(255)
   ,@roll_5_vote INT = NULL     -- int
)
AS
BEGIN
    BEGIN TRY
        IF(
              @last_name_to_check IS NOT NULL
              OR @roll_1 IS NOT NULL
              OR @roll_2 IS NOT NULL
              OR @roll_3 IS NOT NULL
              OR @roll_4 IS NOT NULL
              OR @roll_5 IS NOT NULL
          )
        BEGIN

            IF(
                  --Check the name list for duplicates. Note @last_name is expected to be formatted already
                  dbo.fun_dup_check(@last_name_to_check) > 1
                  OR dbo.fun_dup_check(dbo.fun_format_name(@roll_1)) > 1
                  OR dbo.fun_dup_check(dbo.fun_format_name(@roll_2)) > 1
                  OR dbo.fun_dup_check(dbo.fun_format_name(@roll_3)) > 1
                  OR dbo.fun_dup_check(dbo.fun_format_name(@roll_4)) > 1
                  OR dbo.fun_dup_check(dbo.fun_format_name(@roll_5)) > 1
              )
            BEGIN
                RAISERROR(
                             'Multiple people exist with the same last name. Please review data source for errors.' -- Message text.  
                            ,16                                                                                     -- Severity.  
                            ,1                                                                                      -- State.  
                         );
                --TO DO, look into custom return errors?
                RETURN -1;
            END;
        END;








        --0 = attendance
        IF( @ins_type = 0 )
        BEGIN
            DECLARE @input_person_id INT;
            IF( @last_name_to_check IS NOT NULL )
            BEGIN
                SET @input_person_id =
                (
                    SELECT  ppl.person_id
                    FROM    dbo.people ppl
                    WHERE   ppl.last_name = @last_name_to_check
                );
                EXEC dbo.ins_attendance_insert @input_meeting_id = @meeting_id  -- int
                                              ,@input_person_id = @input_person_id;
            END;
            ELSE
            BEGIN
                CREATE TABLE #att_temp
                (
                    primary_key INT IDENTITY(1, 1)
                   ,last_name VARCHAR(255) NULL
                );
                INSERT INTO #att_temp
                (
                    last_name
                )
                SELECT  @roll_1;

                INSERT INTO #att_temp
                (
                    last_name
                )
                SELECT  @roll_2;

                INSERT INTO #att_temp
                (
                    last_name
                )
                SELECT  @roll_3;

                INSERT INTO #att_temp
                (
                    last_name
                )
                SELECT  @roll_4;

                INSERT INTO #att_temp
                (
                    last_name
                )
                SELECT  @roll_5;

                DECLARE @last_row    INT =
                        (
                            SELECT  MAX(att.primary_key)FROM    #att_temp att
                        )
                       ,@current_row INT = 1;

                WHILE @current_row <= @last_row
                BEGIN
                    SET @input_person_id =
                    (
                        SELECT  ppl.person_id
                        FROM    dbo.people ppl
                        WHERE   ppl.last_name =
                        (
                            SELECT  att.last_name
                            FROM    #att_temp att
                            WHERE   att.primary_key = @current_row
                        )
                    );
                    EXEC dbo.ins_attendance_insert @input_meeting_id = @meeting_id  -- int
                                                  ,@input_person_id = @input_person_id;
                END;

            END;


            RETURN 0;
        END;
        --1 = resolution
        IF( @ins_type = 1 )
        BEGIN
            EXEC dbo.ins_vote_history @all_aye = @all_aye           -- bit
                                     ,@all_naye = @all_naye         -- bit
                                     ,@voter_1 = @roll_1            -- varchar(255)
                                     ,@voter_1_vote = @roll_1_vote  -- int
                                     ,@voter_2 = @roll_2            -- varchar(255)
                                     ,@voter_2_vote = @roll_2_vote  -- int
                                     ,@voter_3 = @roll_3            -- varchar(255)
                                     ,@voter_3_vote = @roll_3_vote  -- int
                                     ,@voter_4 = @roll_4            -- varchar(255)
                                     ,@voter_4_vote = @roll_4_vote  -- int
                                     ,@voter_5 = @roll_5            -- varchar(255)
                                     ,@voter_5_vote = @roll_5_vote  -- int
                                     ,@input_vote_item = 1111111
                                     ,@input_vote_item_type = 1;

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