USE voorhees;
GO
DROP PROCEDURE IF EXISTS dbo.ins_vote_history_insert;
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
               ,@input_vote
        WHERE   NOT EXISTS
        (
            SELECT  @input_vote_item
            FROM    dbo.vote_history vh
            WHERE   vh.vote_item = @input_vote_item
                    AND vh.voter = @input_vote
					AND vh.vote_item_type = @input_vote_item_type
        );
    END;
END;
GO


