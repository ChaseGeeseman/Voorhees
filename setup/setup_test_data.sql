USE voorhees
--add test data to the people table
exec ins_people 'Michael', 'Mignogna', 1;
exec ins_people 'Jason', 'Ravitz', 1;
exec ins_people 'Harry', 'Platt', 1;
exec ins_people 'Michelle', 'Nocito', 1;
exec ins_people 'Jacklyn', 'Fetbroyt', 1;

--add test data to the meeting table
exec ins_meeting '09NOV2020','TEST'
exec ins_meeting '26OCT2020','TEST';
exec ins_meeting '14SEP2020','TEST';
exec ins_meeting '10AUG2020','TEST';

--add test data to the attendance table
SET @meeting_nov = (
    SELECT meeting_id
    FROM meetings
    WHERE meeting_date='09NOV2020'
    )
SET @meeting_oct = (
    SELECT meeting_id
    FROM meetings
    WHERE meeting_date='26OCT2020'
    )
SET @meeting_sep = (
    SELECT meeting_id
    FROM meetings
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

exec ins_attendance @meeting_nov, @person_id
exec ins_attendance @meeting_oct, @person_id
exec ins_attendance @meeting_sep, @person_id