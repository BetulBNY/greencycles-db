-- CREATE DATABASE
CREATE DATABASE Company_X;

-- MORE PARAMETERS FOR CREATING DB
CREATE DATABASE Company_X
	WITH encoding = 'UTF-8';

-- ADDING COMMENT 
CREATE DATABASE Company_X
COMMENT ON DATABASE Company_X IS 'That is my database';


SELECT COUNT(*)
FROM film
WHERE 'Behind the Scenes' = ANY(special_features);

----------------------------------------------------------------------------------------
-- CREATE TABLE
CREATE TABLE director 
(director_id SERIAL PRIMARY KEY,
director_account_name VARCHAR (20) UNIQUE,
first_name VARCHAR (50),
last_name VARCHAR (50) DEFAULT 'Not specified',
date_of_birth DATE,
address_id INT REFERENCES address (address_id))

SELECT * FROM director;
-- CHALLENGE:
/*
1. director_account_name to VARCHAR (30)
2. drop the default on last_name
3. add the constraint not null to last name
4. add the column email of data type VARCHAR(40) 
5. rename the director_account_name to account_name 
6. rename the table from director to directors*/

ALTER TABLE director
-- 1)
ALTER COLUMN director_account_name TYPE VARCHAR(30),
-- 2)
ALTER COLUMN last_name DROP DEFAULT,
-- 3)
ALTER COLUMN last_name SET NOT NULL,
-- 4) 
ADD email VARCHAR(40)

SELECT * FROM director;

--5) RENAME TABLE seperated from others
ALTER TABLE director
RENAME COLUMN director_account_name TO account_name
-- 6)
ALTER TABLE director
RENAME TO directors

SELECT * FROM directors;











