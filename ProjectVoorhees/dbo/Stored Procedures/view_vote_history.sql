/*
TO DO:
- update to accept params
- Update to include ords
*/

CREATE PROCEDURE dbo.view_vote_history
( @parameter_name AS INT )
AS
BEGIN


    SELECT  ppl.last_name
           ,r.dated
           ,vh.vote
           ,r.res_number
           ,r.res_title
    FROM    dbo.people           ppl
        JOIN dbo.vote_history    vh
            ON vh.voter = ppl.person_id
        LEFT JOIN dbo.resolution r
            ON r.primary_key = vh.vote_item
               AND  vh.vote_item_type = 1
    ORDER BY r.dated
            ,r.res_number;

END;