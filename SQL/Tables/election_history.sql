USE voorhees;
GO

/*
*   Contains basic election history information
*/
DROP TABLE IF EXISTS dbo.election_history;
GO
CREATE TABLE dbo.election_history
(
    primary_key INT IDENTITY(1, 1) PRIMARY KEY
   ,person_id INT NOT NULL
    /*
    *   Anyone who participates in an election , should have an entry in the "people"
    *   table listed above.
    */
   ,CONSTRAINT election_history_fk_person_id
        FOREIGN KEY( person_id )
        REFERENCES dbo.people( person_id )
   ,election_party INT NOT NULL
   ,CONSTRAINT election_history_fk_election_party
        FOREIGN KEY( election_party )
        REFERENCES dbo.party( party_id )
   ,vote_count INT NOT NULL
   ,vote_percent DECIMAL(5, 2) NOT NULL
   ,election_year DATE NOT NULL
   ,election_history_source_item_id INT NOT NULL
);