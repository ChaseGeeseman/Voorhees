USE voorhees;
GO

DROP PROCEDURE IF EXISTS dbo.ins_resolution;
GO
CREATE PROCEDURE ins_resolution
(
    @res_number VARCHAR(7)
   ,@where_as VARCHAR(MAX)
   ,@now_therefore VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.resolution
    (
        res_number
       ,where_as
       ,now_therefore
    )
    VALUES
    ( @res_number, @where_as, @now_therefore );
END;
GO