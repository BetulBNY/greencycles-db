-- FUNCTIONS
-- TRANSACTIONS : Unit of work (A unit can include one or multiple operations)
-- ROLLBACK: Undo everything in the current transaction that has not been commited yet.
-- SAVEPOINT: Sometimes we have a lot of operations and we dont really want to rollback everything because maybe 
-- at one point we have made a mistake and this why we can luckly also use called savepoint.
-- RELEASE SAVEPOINT: Deleting savepoint.
-- STORED PROCEDURE

--=========================== FUNCTIONS ===========================
-- SAMPLE 1: Create a function that is calculating a counting the number of films that are within a specific
-- range for the rental rate.
-- parameters: min and max rental rate 
-- number of movies within this range should be returned

CREATE FUNCTION count_rr(min_r decimal(4,2), max_r decimal(4,2))
RETURNS INT
LANGUAGE plpgsql
-- body of function
AS 
$$
DECLARE -- Start with declaring variable
movie_count INT;
BEGIN 
SELECT COUNT(*)
INTO movie_count  -- Always write before FROM
FROM film
WHERE rental_rate BETWEEN min_r AND max_r;
RETURN movie_count;
END;
$$

SELECT count_rr(3,6);

-- WITHOUT FUNCTION
SELECT
COUNT(*) FROM film
WHERE rental_rate BETWEEN 3 AND 6;

-- SAMPLE 2: Create a function that expects the customer's first and last name and returns the total amount of 
-- payments this customer has made. 

CREATE FUNCTION name_search (c_name VARCHAR(45), s_name VARCHAR(45))
RETURNS decimal(6,2)
LANGUAGE plpgsql
AS
$$
DECLARE
amount_payment decimal(6,2);
BEGIN
SELECT 
SUM(amount)
INTO amount_payment
FROM payment AS p
LEFT JOIN customer AS c
	ON p.customer_id = c.customer_id
WHERE c.first_name = c_name AND c.last_name = s_name;
RETURN amount_payment;
END;
$$

SELECT name_search('PATRICIA','JOHNSON');
SELECT name_search('AMY','LOPEZ');

SELECT
first_name,
last_name,
name_search(first_name, last_name)
FROM customer;

--=========================== TRANSACTIONS ===========================
-- SAMPLE 1: Send 100 from Tim's account to Sandras' acoount.
/*
"id"	"first_name"	"last_name"		"amount"
1		"Tim"			"Brown"			2500.00
2		"Sandra"		"Miller"		1600.00
*/
SELECT * FROM acc_balance;

BEGIN;
UPDATE acc_balance
SET amount = amount - 100
WHERE id = 1;
UPDATE acc_balance
SET amount = amount + 100
WHERE id = 2;
COMMIT;

ROLLBACK;

-- SAMPLE 2: The two employees Miller McQuarter and Christalle McKenny have agreed to swap their positions incl. their salary.
SELECT * FROM employees
ORDER BY emp_id;

BEGIN;
UPDATE employees
SET position_title = 'Head of Sales',salary = 12587
WHERE emp_id = 2;
UPDATE employees
SET position_title = 'Head of BI', salary = 14614
WHERE emp_id = 3;
COMMIT;

--=========================== STORED PROCEDURE ===========================
-- SAMPLE 1:
CREATE OR REPLACE PROCEDURE sp_transfer (tr_amount INT, sender INT, recepient INT)
LANGUAGE plpgsql
AS
$$
BEGIN
-- add balacne 
UPDATE acc_balance 
SET amount = amount + tr_amount
WHERE id = recepient;
-- subtract balacne 
UPDATE acc_balance 
SET amount = amount - tr_amount
WHERE id = sender;
COMMIT;
END;
$$

CALL sp_transfer(500,1,2);
SELECT * FROM acc_balance;


-- SAMPLE 2: Create a stored procedure called emp_swap that accepts two parameters emp1 and emp2 as input and swaps the two employees' position and salary. 
-- Test the stored procedure with emp_id 2 and 3.
SELECT * FROM employees;


CREATE OR REPLACE PROCEDURE emp_swap(emp1 INT, emp2 INT)
LANGUAGE plpgsql
AS
$$
DECLARE -- declaring 4 variables
position_of_emp1 TEXT;
position_of_emp2 TEXT;
salary_emp1 DECIMAL(8,2);
salary_emp2 DECIMAL(8,2);
BEGIN
-- get emp1 position
SELECT position_title 
INTO position_of_emp1
FROM employees 
WHERE emp_id = emp1;

-- get emp2 position
SELECT position_title 
INTO position_of_emp2
FROM employees 
WHERE emp_id = emp2;

-- updating position for emp1
UPDATE employees
SET position_title = position_of_emp2
WHERE emp_id = emp1;

-- updating position for emp2
UPDATE employees
SET position_title = position_of_emp1
WHERE emp_id = emp2;

-- get emp1 salary
SELECT salary
INTO salary_emp1
FROM employees
WHERE emp_id = emp1;

-- get emp2 salary
SELECT salary
INTO salary_emp2
FROM employees
WHERE emp_id = emp2;

-- updating salary for emp1
UPDATE employees
SET salary = salary_emp2
WHERE emp_id = emp1;

-- updating salary for emp2
UPDATE employees
SET salary = salary_emp1
WHERE emp_id = emp2;

COMMIT;
END;
$$

CALL emp_swap(2,3);
SELECT * FROM employees;