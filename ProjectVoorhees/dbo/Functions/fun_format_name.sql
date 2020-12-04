/*
*Formats the names of imported people
*/
CREATE FUNCTION dbo.fun_format_name
(
    @input_name VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
BEGIN
    DECLARE @output_name VARCHAR(MAX);
    SET @output_name =
    (
        SELECT  REPLACE(   REPLACE(   REPLACE(   REPLACE(   @input_name
                                                           ,'Committeewoman '
                                                           ,''
                                                        )
                                                ,'Committeeman '
                                                ,''
                                             )
                                     ,'Deputy Mayor '
                                     ,''
                                  )
                          ,'Mayor '
                          ,''
                       )
    );
    RETURN @output_name;
END;