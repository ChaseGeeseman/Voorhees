USE voorhees;
GO

DROP FUNCTION IF EXISTS dbo.fun_dup_check;
GO
CREATE FUNCTION dbo.fun_dup_check
(
    @input_name VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
BEGIN
    DECLARE @dupe_count INT;
    SET @dupe_count =
    (
        SELECT  COUNT(*)FROM    dbo.people ppl WHERE   ppl.last_name = @input_name
    );
    RETURN @dupe_count;
END;