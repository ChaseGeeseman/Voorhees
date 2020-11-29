USE voorhees;
GO
DROP TABLE IF EXISTS dbo.item_info;
GO
CREATE TABLE dbo.item_info
(
    item_info_pk INT IDENTITY(1, 1) PRIMARY KEY
   ,item_name VARCHAR(MAX) NOT NULL
   ,item_description VARCHAR(MAX) NOT NULL
);