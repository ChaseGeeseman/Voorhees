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





/*
    *   Populate the party table with some default parites.
    */

IF( NOT EXISTS ( SELECT * FROM  dbo.party p ))
BEGIN
    EXEC dbo.ins_party @party_name = 'Democrat';
    EXEC dbo.ins_party @party_name = 'Republican';
    EXEC dbo.ins_party @party_name = 'Independent';
    EXEC dbo.ins_party @party_name = 'Other';
END;



/*
*   Populate the people database with the city council members. This should eventually be changed to 
*   dynamically insert names from imported data.
*/
IF( NOT EXISTS ( SELECT * FROM  dbo.people ppl ))
BEGIN
    /*
    *
    *   Info below is accurate as of 03DEC2020 and will need to be updated if new council / mayor / deputy 
    *   mayor elections are held.
    *
    */
    EXEC dbo.ins_people @first_name = 'Jason'   -- varchar(max)
                       ,@last_name = 'Ravitz'   -- varchar(max)
                       ,@party = 1              -- int
                       ,@active = NULL;         -- bit
    EXEC dbo.ins_people @first_name = 'Michelle'   -- varchar(max)
                       ,@last_name = 'Nocito'   -- varchar(max)
                       ,@party = 1              -- int
                       ,@active = NULL;         -- bit
    EXEC dbo.ins_people @first_name = 'Michael'   -- varchar(max)
                       ,@last_name = 'Friedman'   -- varchar(max)
                       ,@party = 1              -- int
                       ,@active = NULL;         -- bit
    EXEC dbo.ins_people @first_name = 'Harry'   -- varchar(max)
                       ,@last_name = 'Platt'   -- varchar(max)
                       ,@party = 1              -- int
                       ,@active = NULL;         -- bit
    EXEC dbo.ins_people @first_name = 'Jason'   -- varchar(max)
                       ,@last_name = 'Ravitz'   -- varchar(max)
                       ,@party = 1              -- int
                       ,@active = NULL;         -- bit
    EXEC dbo.ins_people @first_name = 'Michael'   -- varchar(max)
                       ,@last_name = 'Mignogna'   -- varchar(max)
                       ,@party = 1              -- int
                       ,@active = NULL;         -- bit

END;