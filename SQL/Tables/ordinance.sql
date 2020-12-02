/*
*   Contains information about ordinances
*/
DROP TABLE IF EXISTS dbo.ordinance;
GO
CREATE TABLE dbo.ordinance
(
    primary_key INT IDENTITY(1, 1) PRIMARY KEY
   ,ord_number VARCHAR(7) NOT NULL
   ,ord_reading INT NOT NULL
   ,ord_title VARCHAR(MAX) NULL
   ,where_as VARCHAR(MAX) NOT NULL
   ,now_therefore VARCHAR(MAX) NOT NULL
   ,Introduced DATE NOT NULL
   ,Adopted DATE NOT NULL
);