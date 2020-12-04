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