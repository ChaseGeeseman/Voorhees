USE voorhees;
GO
/*
TODO: Update this to add a default party if none is provided.
*/
DROP PROCEDURE IF EXISTS dbo.ins_people;
GO
CREATE PROCEDURE ins_people
(
    @first_name VARCHAR(MAX)
   ,@last_name VARCHAR(MAX)
   ,@party INT
   ,@active BIT
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.people
    (
        first_name
       ,last_name
       ,active
       ,current_party
    )
    VALUES
    ( @first_name, @last_name, @active, @party );
END;
GO