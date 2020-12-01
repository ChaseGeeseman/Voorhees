USE voorhees;
GO

CREATE PROCEDURE dbo.ins_vote_history_insert
(
    @input_vote_item INT
   ,@input_vote_item_type INT
   ,@input_voter VARCHAR(MAX)
)
AS
BEGIN
    IF( @input_person_id IS NOT NULL )
    BEGIN
        INSERT INTO dbo.vote_history
        (
            vote_item
           ,vote_item_type
           ,voter
        )
        SELECT  0
               ,0
               ,0;

			   
       /* WHERE   NOT EXISTS
        (
           1=1
        );*/
    END;
END;
GO


