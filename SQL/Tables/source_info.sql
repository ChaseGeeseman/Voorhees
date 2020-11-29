USE voorhees;
GO
/*
*   To track where various data is pulled from
*/
DROP TABLE IF EXISTS dbo.source_info;
GO
CREATE TABLE dbo.source_info
(
    source_info_pk INT IDENTITY(1, 1) PRIMARY KEY
   ,source_weblink VARCHAR(MAX) NOT NULL
   ,source_name VARCHAR(MAX) NOT NULL
   ,source_comment VARCHAR(MAX) NULL
);
