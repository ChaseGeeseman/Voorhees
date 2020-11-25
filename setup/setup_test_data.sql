USE voorhees
INSERT INTO dbo.people (first_name,last_name,active)
VALUES
	('Michael','Mignogna',1),
	('Jason','Ravitz',1),
	('Harry','Platt',1),
	('Michelle','Nocito',1),
	('Jacklyn','Fetbroyt',1)

INSERT INTO dbo.meetings(meeting_date,sunshine_statement)
VALUES
    ('09NOV2020','TEST'),
    ('26OCT2020','TEST'),
    ('14SEP2020','TEST'),
    ('10AUG2020','TEST')

INSERT INTO dbo.attendance(meeting_id,person_id)
VALUES
    (
        ( SELECT mt.meeting_id FROM meetings mt WHERE mt.meeting_id = 1 ),
        ( SELECT pp.person_id FROM people pp WHERE pp.person_id = 1)
    ),
        (
        ( SELECT mt.meeting_id FROM meetings mt WHERE mt.meeting_id = 1 ),
        ( SELECT pp.person_id FROM people pp WHERE pp.person_id = 2)
    ),
        (
        ( SELECT mt.meeting_id FROM meetings mt WHERE mt.meeting_id = 1 ),
        ( SELECT pp.person_id FROM people pp WHERE pp.person_id = 3)
    ),
        (
        ( SELECT mt.meeting_id FROM meetings mt WHERE mt.meeting_id = 1 ),
        ( SELECT pp.person_id FROM people pp WHERE pp.person_id = 4)
    ),
        (
        ( SELECT mt.meeting_id FROM meetings mt WHERE mt.meeting_id = 1 ),
        ( SELECT pp.person_id FROM people pp WHERE pp.person_id = 5)
    )

