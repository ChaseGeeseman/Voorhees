USE voorhees;
GO

DROP PROCEDURE IF EXISTS dbo.ins_ordinance;
GO
CREATE PROCEDURE dbo.ins_ordinance
(
    @ins_ord_meeting_id INT
   ,@ins_ord_reading VARCHAR(MAX) = NULL
   ,@ins_ord_number VARCHAR(MAX) = NULL
   ,@ins_ord_title VARCHAR(MAX)
   ,@ins_where_as VARCHAR(MAX) = NULL
   ,@ins_now_therefore VARCHAR(MAX) = NULL
   ,@ins_introduced DATE NULL
   ,@ins_adopted DATE NULL
)
AS
BEGIN
    BEGIN TRY
        INSERT INTO dbo.ordinance
        (
            ord_number
           ,meeting_id
           ,ord_reading
           ,ord_title
           ,where_as
           ,now_therefore
           ,Introduced
           ,Adopted
        )
        SELECT  @ins_ord_number -- ord_number - varchar(7)
               ,@ins_ord_meeting_id
               ,@ins_ord_reading    -- ord_reading - int
               ,@ins_ord_title      -- ord_title - varchar(max)
               ,@ins_where_as       -- where_as - varchar(max)
               ,@ins_now_therefore  -- now_therefore - varchar(max)
               ,@ins_introduced     -- Introduced - date
               ,@ins_adopted        -- Adopted - date

        WHERE   NOT EXISTS
        (
            SELECT  @ins_ord_meeting_id
            FROM    dbo.ordinance o
            WHERE   o.ord_title = @ins_ord_title
                    AND o.meeting_id = @ins_ord_meeting_id
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