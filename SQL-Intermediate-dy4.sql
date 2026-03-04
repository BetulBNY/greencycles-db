-- Functions--
--LOWER
--UPPER
--LENGTH
--Concate --> "||"

/*
QUESTION 1:
In the email system there was a problem with names where either the first name or the last name is more than 10 characters long.
Find these customers and output the list of these first and last names in all lower case.
Write a SQL query to find out!*/
SELECT 
LOWER(first_name) AS lower_first_name,
LOWER(last_name) AS lower_last_name,
LOWER(email) AS lower_email
FROM customer
WHERE LENGTH(first_name) > 10 OR
	  LENGTH(last_name) > 10;

/*
QUESTION 2:
- Extract the last 5 characters of the email address first.
- The email address always ends with '.org'.
How can you extract just the dot '.' from the email address?
*/

-- 1st:
SELECT 
RIGHT(email,5)
FROM customer;

-- 2nd:
SELECT 
LEFT(RIGHT(email,4),1)
FROM customer;

/*
QUESTION 3:
You need to create an anonymized version of the email addresses. 
MARY.SMITH@sakilacustomer.org    -->   M***@sakilacustomer.org
It should be the first character followed by '***' and then the last part starting with '@'.
Note the email address always ends with '@sakilacustomer.org'.
*/
SELECT 
LEFT(email,1) || '***' || RIGHT(email,19) AS 
FROM customer








	  