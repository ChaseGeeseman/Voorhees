CREATE DATABASE voorhees

/*
*   Contains basic information on people who have ran for office.
*/
CREATE TABLE people(
    person_id int IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
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
    primary_key int IDENTITY(1,1) PRIMARY KEY,
    /*
    *   Anyone who participates in an election , should have an entry in the "people"
    *   table listed above.
    */
    CONSTRAINT fk_person_id
        FOREIGN KEY (person_id)
            REFERENCES people(person_id),
    election_year DATE,
)


CREATE TABLE resolutions(
    primary_key int IDENTITY(1,1) PRIMARY KEY,
    res_number VARCHAR(7),
    where_as TEXT(MAX),
    now_therefore TEXT(MAX)
)

CREATE TABLE ordinances(
    primary_key int IDENTITY(1,1) PRIMARY KEY,
    ord_number VARCHAR(7),
    where_as TEXT(MAX),
    now_therefore TEXT(MAX)
)