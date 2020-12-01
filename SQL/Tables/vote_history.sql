USE voorhees;
GO
DROP TABLE IF EXISTS dbo.vote_history;
GO
CREATE TABLE dbo.vote_history
(
    vote_item INT NOT NULL
   ,vote_item_type INT NOT NULL
   ,voter INT NOT NULL
   ,CONSTRAINT vote_history_fk_voter
        FOREIGN KEY( voter )
        REFERENCES dbo.people( person_id )
	,vote INT NOT NULL
);
