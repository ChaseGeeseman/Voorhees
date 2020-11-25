USE voorhees
--add test data to the people table
exec ins_people 'Michael', 'Mignogna', 1;
exec ins_people 'Jason', 'Ravitz', 1;
exec ins_people 'Harry', 'Platt', 1;
exec ins_people 'Michelle', 'Nocito', 1;
exec ins_people 'Jacklyn', 'Fetbroyt', 1;
exec ins_people 'Write-In', 'Write-In', 0;

--add test data to the meeting table
exec ins_meeting '09NOV2020','TEST'
exec ins_meeting '26OCT2020','TEST';
exec ins_meeting '14SEP2020','TEST';
exec ins_meeting '10AUG2020','TEST';

--add test data to the attendance table
SET @meeting_nov = (
    SELECT meeting_id
    FROM meeting
    WHERE meeting_date='09NOV2020'
    )
SET @meeting_oct = (
    SELECT meeting_id
    FROM meeting
    WHERE meeting_date='26OCT2020'
    )
SET @meeting_sep = (
    SELECT meeting_id
    FROM meeting
    WHERE meeting_date='14SEP2020'
    )

SET @person_id = (
    SELECT person_id
    FROM people
    WHERE last_name = 'Nocito'
)

exec ins_attendance @meeting_nov, @person_id
exec ins_attendance @meeting_oct, @person_id
exec ins_attendance @meeting_sep, @person_id

SET @person_id = (
    SELECT person_id
    FROM people
    WHERE last_name = 'Fetbroyt'
)

exec ins_attendance @meeting_nov, @person_id;
exec ins_attendance @meeting_oct, @person_id;
exec ins_attendance @meeting_sep, @person_id;



/*
    Below is actual 2020 Election results source is
    https://www.camdencounty.com/wp-content/elections/general2020/2020-General-Election-Canvasser.pdf
*/


SET @person_id = (
    SELECT ppl.person_id
    FROM people ppl
    WHERE ppl.last_name = 'MIGNOGNA'
)

exec ins_election_history @person_id, '2020','DEM', 12,670, 49.77

SET @person_id = (
    SELECT ppl.person_id
    FROM people ppl
    WHERE ppl.last_name = 'PLATT'
)
exec ins_election_history @person_id, '2020','DEM', 12,514, 49.16

SET @person_id = (
    SELECT ppl.person_id
    FROM people ppl
    WHERE ppl.last_name = 'Write-In'
)
exec ins_election_history @person_id, '2020', NULL, 273, 1.07
