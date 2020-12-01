USE voorhees;
GO

DROP PROCEDURE IF EXISTS dbo.ins_resolution;
GO
CREATE PROCEDURE ins_resolution
(
    @res_meeting_id INT = NULL
   ,@res_reading VARCHAR(MAX) = NULL
   ,@res_number VARCHAR(MAX) = NULL
   ,@res_title VARCHAR(MAX) = NULL
   ,@where_as VARCHAR(MAX) = NULL
   ,@now_therefore VARCHAR(MAX) = NULL
   ,@dated DATE = NULL
)
AS
BEGIN
    BEGIN TRY

        IF(( @res_meeting_id IS NULL OR @res_title IS NULL ))
            RAISERROR(   '@res_meeting_id AND @res_title are both required.'    -- Message text.  
                        ,16                                                     -- Severity.  
                        ,1                                                      -- State.
                     );

        INSERT INTO dbo.resolution
        (
            res_meeting_id
           ,res_reading
           ,res_number
           ,res_title
           ,where_as
           ,now_therefore
           ,dated
        )
        SELECT  @res_meeting_id -- res_meeting_id - int
               ,@res_reading    -- res_reading - tinyint
               ,@res_number     -- res_number - varchar(255)
               ,@res_title      -- res_title - varchar(max)
               ,@where_as       -- where_as - varchar(max)
               ,@now_therefore  -- now_therefore - varchar(max)
               ,@dated          -- dated - date

        WHERE   NOT EXISTS
        (
            SELECT  r.primary_key
            FROM    dbo.resolution r
            WHERE   r.res_meeting_id = @res_meeting_id
                    AND r.res_title = @res_title
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