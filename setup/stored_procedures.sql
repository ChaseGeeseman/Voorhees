USE voorhees;
GO

------------- people -----------------
/*
TODO: Update this to add a default party if none is provided.
*/
DROP PROCEDURE IF EXISTS dbo.ins_people;
GO
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
DROP PROCEDURE IF EXISTS dbo.ins_meeting;
GO
CREATE PROCEDURE ins_meeting
(
    @ins_meeting_date DATE
   ,@ins_sunshine_statement VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.meeting
    (
        meeting_date
       ,sunshine_statement
    )
    SELECT  @ins_meeting_date
           ,@ins_sunshine_statement
    WHERE   NOT EXISTS
    (
        SELECT  @ins_meeting_date
        FROM    dbo.meeting AS m
        WHERE   m.meeting_date = @ins_meeting_date
    );
END;
GO


------------- attendance -----------------
DROP PROCEDURE IF EXISTS dbo.ins_attendance;
GO
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
    SELECT  @meeting_id
           ,@person_id
    WHERE   NOT EXISTS
    (
        SELECT  @meeting_id
        FROM    dbo.attendance AS a
        WHERE   a.meeting_id = @meeting_id
                AND a.person_id = @person_id
    );
END;
GO

------------- resolutions -----------------
DROP PROCEDURE IF EXISTS dbo.ins_resolution;
GO
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
            AND @election_party = IIF(@election_year IS NULL
                                        --If Null return all values
                                     ,eh.election_party
                                        --If not null return specific value
                                     ,@election_year)
    ORDER BY eh.election_year
            ,eh.vote_count DESC;
END;
GO



------------- party -----------------
DROP PROCEDURE IF EXISTS dbo.ins_party;
GO
CREATE PROCEDURE ins_party
( @party_name VARCHAR(MAX))
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.party
    (
        party_name
    )
    SELECT  @party_name
    WHERE   NOT EXISTS
    (
        SELECT  @party_name FROM    dbo.party WHERE party.party_name = party_name
    );
END;
GO
