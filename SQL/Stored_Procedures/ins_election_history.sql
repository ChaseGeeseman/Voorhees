USE voorhees;
GO

DROP PROCEDURE IF EXISTS dbo.ins_election_history;
GO
CREATE PROCEDURE ins_election_history
(
    @person_id INT
   ,@election_year DATE
   ,@election_party VARCHAR(MAX)
   ,@vote_count INT
   ,@vote_percent DECIMAL(5, 2)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.election_history
    (
        person_id
       ,election_year
       ,election_party
       ,vote_count
       ,vote_percent
    )
    VALUES
    ( @person_id, @election_year, @election_party, @vote_count, @vote_percent );
END;
GO