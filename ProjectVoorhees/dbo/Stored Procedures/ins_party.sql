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
        SELECT  @party_name FROM    dbo.party WHERE party.party_name = @party_name
    );
END;