------------- people -----------------

CREATE PROCEDURE ins_people(
        @first_name VARCHAR(MAX),
        @last_name VARCHAR(MAX), @active BIT
    )
AS
SET NOCOUNT ON
INSERT INTO dbo.people(first_name, last_name,active)
VALUES (@first_name, @last_name, @active)
GO;

------------- meeting -----------------

CREATE PROCEDURE ins_meeting(
        @meeting_date DATE,
        @sunshine_statement VARCHAR(MAX)
    )
AS
SET NOCOUNT ON
INSERT INTO dbo.meetings(meeting_date, sunshine_statement)
VALUES(@meeting_date, @sunshine_statement)
GO;

------------- attendance -----------------

CREATE PROCEDURE ins_attendance(
        @meeting_id INT,
        @person_id INT
    )
AS
SET NOCOUNT ON
INSERT INTO dbo.attendance(meeting_id, person_id)
VALUES(@meeting_id, @person_id)
GO;

------------- resolutions -----------------

CREATE PROCEDURE ins_resolutions(
        @res_number VARCHAR(7),
        @where_as VARCHAR(MAX),
        @now_therefore VARCHAR(MAX) 
    )
AS
SET NOCOUNT ON
INSERT INTO dbo.resolutions(res_number, where_as,now_therefore)
VALUES(@res_number, @where_as, @now_therefore)
GO;

------------- election_history -----------------

CREATE PROCEDURE ins_election_history(
    @person_id INT,
    @election_year DATE,
    @election_party VARCHAR(MAX),
    @vote_count INT,
    @vote_percent FLOAT
)
AS
SET NOCOUNT ON
INSERT INTO dbo.election_history(person_id,election_year,election_party,vote_count,vote_percent,election_year)
VALUES(@person_id,@election_year,@election_party,@vote_count,@vote_percent,@election_year)
GO;

------------- source_reference -----------------

CREATE PROCEDURE ins_source_reference(
    @source_link VARCHAR(MAX),
    @source_name VARCHAR(MAX),
    @source_comment VARCHAR(MAX)
)
AS
SET NOCOUNT ON
INSERT INTO dbo.election_history()
VALUES(   )
GO;






