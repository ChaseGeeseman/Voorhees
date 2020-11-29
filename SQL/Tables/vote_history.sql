USE voorhees;
GO
DROP TABLE IF EXISTS dbo.vote_history;
GO
CREATE TABLE dbo.vote_history
(
    vote_history_pk INT IDENTITY(1, 1) PRIMARY KEY
   ,vote_item INT NOT NULL
   ,voter INT NOT NULL
   ,CONSTRAINT vote_history_fk_voter
        FOREIGN KEY( voter )
        REFERENCES dbo.people( person_id )
);
