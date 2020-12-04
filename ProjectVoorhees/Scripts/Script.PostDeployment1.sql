/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF( NOT EXISTS ( SELECT * FROM  dbo.party p ))
BEGIN
    EXEC dbo.ins_party @party_name = 'Democrat'
    EXEC dbo.ins_party @party_name = 'Republican'
    EXEC dbo.ins_party @party_name = 'Independent'
    EXEC dbo.ins_party @party_name = 'Other'
END;