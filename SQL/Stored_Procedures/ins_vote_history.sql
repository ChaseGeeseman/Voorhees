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
   ,@input_vote_item INT
   ,@input_vote_item_type INT
)
AS
BEGIN
    BEGIN TRY

        /*
			If everyone voted yes, or no we will grab the list of those who attended that meeting and loop through them
		*/
        IF( @all_aye IS NOT NULL OR @all_naye IS NOT NULL )
        BEGIN
            IF( @input_vote_item_type = 1 )
            BEGIN

                /*
					Create a list of people present at the meeting and store the data in a temp table
				*/
                DECLARE @list_present AS TABLE
                (
                    primary_key INT IDENTITY(1, 1)
                   ,person_id INT NOT NULL
                );

                INSERT INTO @list_present
                (
                    person_id
                )
                SELECT  a.person_id
                FROM    dbo.resolution  r
                    JOIN dbo.attendance a
                        ON a.meeting_id = r.res_meeting_id
                WHERE   r.primary_key = @input_vote_item;


                --Determine the number of records to go through
                DECLARE @last_row       INT =
                        (
                            SELECT  MAX(lp.primary_key)FROM @list_present lp
                        )
                       ,@current_row    INT = 1
                       ,@imported_voter VARCHAR(MAX)
                       ,@imported_vote  INT;

                IF( @all_naye IS NOT NULL )
                BEGIN
                    SET @imported_vote = 0;
                END;
                ELSE
                BEGIN
                    SET @imported_vote = 1;
                END;

                --Start our loop
                WHILE @current_row <= @last_row
                BEGIN
                    SET @imported_voter =
                    (
                        SELECT  lp.person_id
                        FROM    @list_present lp
                        WHERE   lp.primary_key = @current_row
                    );


                    EXEC dbo.ins_vote_history_insert @input_vote_item = @input_vote_item            -- int
                                                    ,@input_vote_item_type = @input_vote_item_type  -- int
                                                    ,@input_voter = @imported_voter                 -- varchar(max)
                                                    ,@input_vote = @imported_vote;
                    SET @current_row = @current_row + 1;
                END;
                RETURN 0;


            END;
        END;
        --Else we need to process each persons name individually
        SET @voter_1 = dbo.fun_format_name(@voter_1);
        SET @voter_2 = dbo.fun_format_name(@voter_2);
        SET @voter_3 = dbo.fun_format_name(@voter_3);
        SET @voter_4 = dbo.fun_format_name(@voter_4);
        SET @voter_5 = dbo.fun_format_name(@voter_5);

    /*
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




        DECLARE @error_example VARCHAR(255) = 'message';
        RAISERROR(   'Example error %s' -- Message text.  
                    ,16                 -- Severity.  
                    ,1                  -- State.
                    ,@error_example     --Example variable insert, %d for INT types
                 );
				 */
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
