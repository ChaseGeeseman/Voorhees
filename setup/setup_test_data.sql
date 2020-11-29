USE voorhees;

--add test data to the party table
EXEC dbo.ins_party  @party_name = 'Democrat';
EXEC dbo.ins_party @party_name = 'Republican';
EXEC dbo.ins_party @party_name = 'Other';


--add test data to the people table
EXEC dbo.ins_people @first_name = 'Michael', @last_name = 'Mignogna', @active = 1;
EXEC dbo.ins_people @first_name = 'Jason', @last_name = 'Ravitz', @active = 1;
EXEC dbo.ins_people @first_name = 'Harry', @last_name = 'Platt', @active = 1;
EXEC dbo.ins_people @first_name = 'Michelle', @last_name = 'Nocito', @active = 1;
EXEC dbo.ins_people @first_name = 'Jacklyn', @last_name = 'Fetbroyt', @active = 1;
EXEC dbo.ins_people @first_name = 'Write-In', @last_name = 'Write-In', @active = 0;

--add test data to the meeting table
EXEC dbo.ins_meeting @meeting_date = '09NOV2020', @sunshine_statement = 'TEST';
EXEC dbo.ins_meeting @meeting_date = '26OCT2020', @sunshine_statement = 'TEST';
EXEC dbo.ins_meeting @meeting_date = '14SEP2020', @sunshine_statement = 'TEST';
EXEC dbo.ins_meeting @meeting_date = '10AUG2020', @sunshine_statement = 'TEST';

--add test data to the attendance table
DECLARE @meeting_nov INT =
        (
            SELECT  meeting_id FROM dbo.meeting WHERE   meeting_date = '09NOV2020'
        )
       ,@meeting_oct INT =
        (
            SELECT  meeting_id FROM dbo.meeting WHERE   meeting_date = '26OCT2020'
        )
       ,@meeting_sep INT =
        (
            SELECT  meeting_id FROM dbo.meeting WHERE   meeting_date = '14SEP2020'
        )
       ,@ins_person_id   INT =
        (
            SELECT  person_id FROM  dbo.people WHERE last_name = 'Nocito'
        );

EXEC dbo.ins_attendance @meeting_id = @meeting_nov, @person_id = @ins_person_id;
EXEC dbo.ins_attendance @meeting_id = @meeting_oct, @person_id = @ins_person_id;
EXEC dbo.ins_attendance @meeting_id = @meeting_sep, @person_id = @ins_person_id;

SET @ins_person_id =
(
    SELECT  person_id FROM  dbo.people WHERE last_name = 'Fetbroyt'
);

EXEC dbo.ins_attendance @meeting_id = @meeting_nov, @person_id = @ins_person_id;
EXEC dbo.ins_attendance @meeting_id = @meeting_oct, @person_id = @ins_person_id;
EXEC dbo.ins_attendance @meeting_id = @meeting_sep, @person_id = @ins_person_id;



/*
    Below is actual 2020 Election results source is
    https://www.camdencounty.com/wp-content/elections/general2020/2020-General-Election-Canvasser.pdf
*/


SET @ins_person_id =
(
    SELECT  ppl.person_id
    FROM    dbo.people AS ppl
    WHERE   ppl.last_name = 'MIGNOGNA'
);

EXEC dbo.ins_election_history @person_id = @ins_person_id, @election_year = '2020', @election_party = NULL, @vote_count = 12670, @vote_percent = 49.77;

SET @ins_person_id =
(
    SELECT  ppl.person_id FROM  dbo.people AS ppl WHERE ppl.last_name = 'PLATT'
);
EXEC dbo.ins_election_history @ins_person_id, '2020', NULL, 12514, 49.16;

SET @ins_person_id =
(
    SELECT  ppl.person_id
    FROM    dbo.people AS ppl
    WHERE   ppl.last_name = 'Write-In'
);
EXEC dbo.ins_election_history @ins_person_id, '2020', NULL, 273, 1.07;
