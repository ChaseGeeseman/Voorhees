USE voorhees;

--add test data to the party table
EXEC ins_party 'Democrat';
EXEC ins_party 'Republican';
EXEC ins_party 'Other';


--add test data to the people table
EXEC ins_people 'Michael', 'Mignogna', 1;
EXEC ins_people 'Jason', 'Ravitz', 1;
EXEC ins_people 'Harry', 'Platt', 1;
EXEC ins_people 'Michelle', 'Nocito', 1;
EXEC ins_people 'Jacklyn', 'Fetbroyt', 1;
EXEC ins_people 'Write-In', 'Write-In', 0;

--add test data to the meeting table
EXEC ins_meeting '09NOV2020', 'TEST';
EXEC ins_meeting '26OCT2020', 'TEST';
EXEC ins_meeting '14SEP2020', 'TEST';
EXEC ins_meeting '10AUG2020', 'TEST';

--add test data to the attendance table
DECLARE @meeting_nov INT =
        (
            SELECT  meeting_id FROM meeting WHERE   meeting_date = '09NOV2020'
        )
       ,@meeting_oct INT =
        (
            SELECT  meeting_id FROM meeting WHERE   meeting_date = '26OCT2020'
        )
       ,@meeting_sep INT =
        (
            SELECT  meeting_id FROM meeting WHERE   meeting_date = '14SEP2020'
        )
       ,@person_id   INT =
        (
            SELECT  person_id FROM  people WHERE last_name = 'Nocito'
        );

EXEC ins_attendance @meeting_nov, @person_id;
EXEC ins_attendance @meeting_oct, @person_id;
EXEC ins_attendance @meeting_sep, @person_id;

SET @person_id =
(
    SELECT  person_id FROM  people WHERE last_name = 'Fetbroyt'
);

EXEC ins_attendance @meeting_nov, @person_id;
EXEC ins_attendance @meeting_oct, @person_id;
EXEC ins_attendance @meeting_sep, @person_id;



/*
    Below is actual 2020 Election results source is
    https://www.camdencounty.com/wp-content/elections/general2020/2020-General-Election-Canvasser.pdf
*/


SET @person_id =
        (
            SELECT  ppl.person_id FROM  people AS ppl WHERE ppl.last_name = 'MIGNOGNA'
        );

EXEC ins_election_history @person_id, '2020', NULL, 12670, 49.77;

SET @person_id =
(
    SELECT  ppl.person_id FROM  people AS ppl WHERE ppl.last_name = 'PLATT'
);
EXEC ins_election_history @person_id, '2020', NULL, 12514, 49.16;

SET @person_id =
(
    SELECT  ppl.person_id FROM  people AS ppl WHERE ppl.last_name = 'Write-In'
);
EXEC ins_election_history @person_id, '2020', NULL, 273, 1.07;
