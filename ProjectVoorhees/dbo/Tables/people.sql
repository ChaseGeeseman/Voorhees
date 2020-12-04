CREATE TABLE dbo.people
(
    person_id INT IDENTITY(1, 1) PRIMARY KEY
   ,first_name VARCHAR(255) NULL
   ,last_name VARCHAR(255) NULL
   ,current_party INT NOT NULL
   ,CONSTRAINT people_fk_current_party
        FOREIGN KEY( current_party )
        REFERENCES dbo.party( party_id )
    /*
    *   1 = serving activly
    *   0 = not serving
    */
   ,active BIT NOT NULL
        DEFAULT 0
);