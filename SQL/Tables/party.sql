USE voorhees;
GO


/*
*   Decodes political parties
*/
DROP TABLE IF EXISTS dbo.party;
GO
CREATE TABLE dbo.party
(
    party_id INT IDENTITY(1, 1) PRIMARY KEY
   ,party_name VARCHAR(50) NOT NULL
);