USE voorhees;
GO

DROP PROCEDURE IF EXISTS dbo.view_election_history;
GO
CREATE PROCEDURE view_election_history
(
    @person_id INT = NULL
   ,@election_year DATE = NULL
   ,@election_party VARCHAR(MAX) = NULL
)
AS
BEGIN
    SELECT  eh.election_year
           ,ppl.first_name
           ,ppl.last_name
           ,eh.election_party
           ,eh.vote_count
           ,eh.vote_percent
    FROM    dbo.election_history AS eh
        JOIN dbo.people          AS ppl
            ON eh.person_id = ppl.person_id
    WHERE   eh.person_id = IIF(@person_id IS NULL
                                --If Null return all values
                              ,eh.person_id
                                --If not null return specific value
                              ,@person_id)
            AND @election_year = IIF(@election_year IS NULL
                                    --If Null return all values
                                    ,eh.election_year
                                    --If not null return specific value
                                    ,@election_year)
            AND @election_party = IIF(@election_party IS NULL
                                        --If Null return all values
                                     ,eh.election_party
                                        --If not null return specific value
                                     ,@election_party)
    ORDER BY eh.election_year
            ,eh.vote_count DESC;
END;
GO