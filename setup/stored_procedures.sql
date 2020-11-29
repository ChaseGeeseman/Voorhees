USE voorhees;
GO

------------- people -----------------
/*
TODO: Update this to add a default party if none is provided.
*/

CREATE PROCEDURE ins_people
(
    @first_name VARCHAR(MAX)
   ,@last_name VARCHAR(MAX)
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
    )
    VALUES
    ( @first_name, @last_name, @active );
END;
GO


------------- meeting -----------------

CREATE PROCEDURE ins_meeting
(
    @meeting_date DATE
   ,@sunshine_statement VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.meeting
    (
        meeting_date
       ,sunshine_statement
    )
    VALUES
    ( @meeting_date, @sunshine_statement );
END;
GO




------------- attendance -----------------

CREATE PROCEDURE ins_attendance
(
    @meeting_id INT
   ,@person_id INT
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.attendance
    (
        meeting_id
       ,person_id
    )
    VALUES
    ( @meeting_id, @person_id );
END;
GO

------------- resolutions -----------------

CREATE PROCEDURE ins_resolution
(
    @res_number VARCHAR(7)
   ,@where_as VARCHAR(MAX)
   ,@now_therefore VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.resolution
    (
        res_number
       ,where_as
       ,now_therefore
    )
    VALUES
    ( @res_number, @where_as, @now_therefore );
END;
GO

------------- election_history -----------------

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
    FROM    election_history AS eh
        JOIN people          AS ppl
            ON eh.person_id = ppl.person_id
    WHERE   eh.person_id = IIF(@person_id IS NULL
                                --If Null return all values
                              ,eh.person_id
                                --If not null return specific value
                              ,@person_id)
    ORDER BY eh.election_year
            ,eh.vote_count DESC;
END;
GO



------------- party -----------------
CREATE PROCEDURE ins_party
( @party_name VARCHAR(MAX))
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO party
    (
        party_name
    )
    SELECT  @party_name
    WHERE   NOT EXISTS
    (
        SELECT  @party_name FROM    party WHERE party.party_name = party_name
    );
END;
GO
