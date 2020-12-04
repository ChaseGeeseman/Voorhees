CREATE TABLE dbo.source_reference
(
    source_reference_pk INT IDENTITY(1, 1) PRIMARY KEY
   ,source_info_pk INT NOT NULL
   ,CONSTRAINT source_reference_fk_source_info_pk
        FOREIGN KEY( source_info_pk )
        REFERENCES dbo.source_info( source_info_pk )
    --25NOV2020 currently this can only be resolution or ordinance.
   ,item_type INT NOT NULL
   ,CONSTRAINT source_reference_fk_item_type
        FOREIGN KEY( item_type )
        REFERENCES dbo.item_info( item_info_pk )
    --Reference the primary key of an ordinance or resolution
   ,item_id INT NOT NULL
);