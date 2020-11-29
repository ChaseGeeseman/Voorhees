USE voorhees;
GO
/*
*   Contains information about resolutions
*/
DROP TABLE IF EXISTS dbo.resolution;
GO
CREATE TABLE dbo.resolution
(
    primary_key INT IDENTITY(1, 1) PRIMARY KEY
   ,res_number VARCHAR(7) NOT NULL
   ,res_title VARCHAR(MAX) NULL
   ,where_as VARCHAR(MAX) NOT NULL
   ,now_therefore VARCHAR(MAX) NOT NULL
);