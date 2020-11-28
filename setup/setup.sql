/*
If DB not present run this line by itself


DROP DATABASE IF EXISTS voorhees
GO
CREATE DATABASE voorhees;


*/
USE voorhees

/*
*   Decodes political parties
*/
CREATE TABLE party(
    party_id int IDENTITY(1,1) PRIMARY KEY,
    party_name VARCHAR(MAX)
)

/*
*   Contains basic information on people who have ran for office.
*/
CREATE TABLE people(
    person_id int IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    current_party INT,
        CONSTRAINT people_fk_current_party
            FOREIGN KEY (current_party)
                REFERENCES party(party_id),
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
	person_id INT NOT NULL,
    /*
    *   Anyone who participates in an election , should have an entry in the "people"
    *   table listed above.
    */
    CONSTRAINT election_history_fk_person_id
        FOREIGN KEY (person_id)
            REFERENCES people(person_id),
    election_party INT,
        CONSTRAINT election_history_fk_election_party
            FOREIGN KEY (election_party)
                REFERENCES party(party_id),
    vote_count INT,
    vote_percent DECIMAL(5,2),
    election_year DATE NOT NULL,
    election_history_source_item_id INT
)

/*
*   Contains information about resolutions
*/
CREATE TABLE resolution(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
    res_number VARCHAR(7) NOT NULL,
    res_title VARCHAR(MAX),
    where_as VARCHAR(MAX) NOT NULL,
	now_therefore VARCHAR(MAX) NOT NULL
)


/*
*   Contains information about ordinances
*/
CREATE TABLE ordinance(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
    ord_number VARCHAR(7) NOT NULL,
    ord_title VARCHAR(MAX),
    where_as VARCHAR(MAX) NOT NULL,
	now_therefore VARCHAR(MAX) NOT NULL,
)


/*
*   Contains information about meetings
*/
CREATE TABLE meeting(
     meeting_id INT IDENTITY(1,1) PRIMARY KEY,
     meeting_date DATE NOT NULL,
     sunshine_statement VARCHAR(MAX)
)

/*
*   Contains meeting attattendance information
*/
CREATE TABLE attendance(
    primary_key INT IDENTITY(1,1) PRIMARY KEY,
    meeting_id INT NOT NULL,
        CONSTRAINT fk_attendance_meeting_id
            FOREIGN KEY (meeting_id)
                REFERENCES meetings(meeting_id),
    person_id INT NOT NULL,
        CONSTRAINT attendance_fk_person_id
            FOREIGN KEY (person_id)
                REFERENCES people(person_id),
)

/*
*   To track where various data is pulled from
*/
CREATE TABLE source_info(
    source_info_pk INT IDENTITY(1,1) PRIMARY KEY,
    source_weblink VARCHAR(MAX) NOT NULL,
    source_name VARCHAR(MAX) NOT NULL,
    source_comment VARCHAR(MAX)
)

CREATE TABLE source_reference(
    source_reference_pk INT IDENTITY(1,1) PRIMARY KEY,
    source_info_pk INT NOT NULL,
        CONSTRAINT source_reference_fk_source_info_pk
            FOREIGN KEY (source_info_pk)
                REFERENCES source_info(source_info_pk),
    --25NOV2020 currently this can only be resolution or ordinance.
    item_type INT NOT NULL,
        CONSTRAINT source_reference_fk_item_type
            FOREIGN KEY (item_type)
                REFERENCES item_info(item_info_pk),
    --Reference the primary key of an ordinance or resolution
    item_id INT NOT NULL
)


CREATE TABLE item_info(
    item_info_pk INT IDENTITY(1,1) PRIMARY KEY,
    item_name VARCHAR(MAX) NOT NULL,
    item_description VARCHAR(MAX)
)