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
   ,res_meeting_id INT NOT NULL
   ,res_reading TINYINT NULL
   ,res_number VARCHAR(MAX) NULL
   ,res_title VARCHAR(MAX) NOT NULL
   ,where_as VARCHAR(MAX) NULL
   ,now_therefore VARCHAR(MAX) NULL
   ,dated DATE NOT NULL
);