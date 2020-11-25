/*
If DB not present run this line by itself


DROP DATABASE IF EXISTS voorhees
GO
CREATE DATABASE voorhees;


*/
USE voorhees


/*
*   Contains basic information on people who have ran for office.
*/
CREATE TABLE people(
    person_id int IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    --TO DO: Create a party table and change this to reference the coded value
    current_party VARCHAR(MAX),
    /*
    *   1 = serving activly
    *   0 = not serving
    */ 
    active BIT DEFAULT 0
)

/*
*   Contains basic election history information
*/
CREATE TABLE election_history(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
	person_id INT,
    /*
    *   Anyone who participates in an election , should have an entry in the "people"
    *   table listed above.
    */
    CONSTRAINT election_history_fk_person_id
        FOREIGN KEY (person_id)
            REFERENCES people(person_id),
    --TO DO: Create a party table and change this to reference the coded value
    election_party VARCHAR(MAX),
    vote_count INT,
    vote_percent FLOAT,
    election_year DATE
)


CREATE TABLE resolution(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
    res_number VARCHAR(7),
    where_as VARCHAR(MAX),
	now_therefore VARCHAR(MAX)
)

CREATE TABLE ordinance(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
    ord_number VARCHAR(7),
    ord_title VARCHAR(MAX),
    where_as VARCHAR(MAX),
	now_therefore VARCHAR(MAX),
    source VARCHAR(MAX)
)

CREATE TABLE meeting(
     meeting_id INT IDENTITY(1,1) PRIMARY KEY,
     meeting_date DATE,
     sunshine_statement VARCHAR(MAX)
)

CREATE TABLE attendance(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
    meeting_id INT,
        CONSTRAINT fk_attendance_meeting_id
            FOREIGN KEY (meeting_id)
                REFERENCES meetings(meeting_id),
    person_id INT,
        CONSTRAINT fk_attendance_person_id
            FOREIGN KEY (person_id)
                REFERENCES people(person_id),
)

/*
*   To track where various data is pulled from
*/
CREATE TABLE source_reference(
    source_reference_pk INT IDENTITY(1,1) PRIMARY KEY,
    source_link VARCHAR(MAX),
    source_name VARCHAR(MAX),
    source_comment VARCHAR(MAX)
)