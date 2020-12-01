USE voorhees;
GO
DROP PROCEDURE IF EXISTS ins_vote_history_insert;
GO


CREATE PROCEDURE dbo.ins_vote_history_insert
(
    @input_vote_item INT
   ,@input_vote_item_type INT
   ,@input_voter VARCHAR(MAX)
   ,@input_vote INT
)
AS
BEGIN
    BEGIN
        INSERT INTO dbo.vote_history
        (
            vote_item
           ,vote_item_type
           ,voter
           ,vote
        )
        SELECT  @input_vote_item
               ,@input_vote_item_type
               ,@input_voter
               ,@input_vote;

    END;
END;
GO


