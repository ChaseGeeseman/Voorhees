CREATE TABLE dbo.source_info
(
    source_info_pk INT IDENTITY(1, 1) PRIMARY KEY
   ,source_weblink VARCHAR(MAX) NOT NULL
   ,source_name VARCHAR(MAX) NOT NULL
   ,source_comment VARCHAR(MAX) NULL
);