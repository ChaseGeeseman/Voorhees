CREATE PROCEDURE up_people
(
    @up_person_id INT = NULL
   ,@up_first_name VARCHAR(255) = NULL
   ,@up_last_name VARCHAR(255) = NULL
   ,@up_active BIT = 0
)
AS
BEGIN
    UPDATE  dbo.people
    SET first_name = COALESCE(@up_first_name, first_name)
       ,last_name = COALESCE(@up_last_name, last_name)
       ,active = COALESCE(@up_active, active)
    WHERE   person_id = @up_person_id;
END;