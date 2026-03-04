/*
SELECT
DISTINCT district
FROM address 
*/

/*
SELECT rental_date
FROM rental
ORDER BY rental_date desc
Limit 1
*/

/*
SELECT COUNT(film_id)
FROM film
*/

/*
SELECT COUNT(DISTINCT last_name)
FROM customer 
*/

/*
SELECT COUNT(*)
FROM payment
WHERE customer_id = 100
*/


SELECT first_name,last_name
FROM customer
WHERE first_name = 'ERICA';

/*How Rentals have not been returned yet (return_date is null)*/
SELECT COUNT(*)
FROM rental
WHERE return_date is null;

SELECT payment_id, amount
FROM payment
WHERE amount <= 2;

/* 
QUESTION 1: The support manager asks you about a list of all the payment of the customer 322, 346 and 354 where the amount is either less than $2 or greater than $10.
It should be ordered by the customer first (ascending) and then as second condition order by amount in a descending order.
Write a SQL query to get the answers!*/

SELECT *
FROM payment
WHERE (customer_id = 322 OR
customer_id = 346
OR customer_id = 354) AND
(amount < 2 OR amount > 10)
ORDER BY customer_id ASC, amount DESC;


/*
QUESTION 2: There have been some faulty payments and you need to help to found out how many payments have been affected.
How many payments have been made on January 26th and 27th 2020 with an amount between 1,99 and 3.99?
Write a SQL query to get the answers!
*/
SELECT COUNT(*)
FROM payment
WHERE payment_date >= '2020-01-26'
  AND payment_date <  '2020-01-28'
AND
amount BETWEEN 1.99 AND 3.99;
/*Instead of using BETWEEN in date format, range is better for including seconds*/

/* QUESTION 3: There have been 6 complaints of customers about their payments.
customer_id: 12,25,67,93,124,234
The concerned payments are all the payments of these customers with amounts 4.99, 7.99 and 9.99 in January 2020.
Write a SQL query to get a list of the concerned payments! */

SELECT COUNT(DISTINCT customer_id)
FROM payment
WHERE customer_id IN (12,25,67,93,124,234)
AND amount IN(4.99, 7.99, 9.99)
AND (payment_date >= '2020-01-01' 
	 AND payment_date < '2020-02-01');


/*
// LIKE
QUESTION 4: You need to help the inventory manager to find out:
How many movies are there that contain the "Documentary" in the description?
Write a SQL query to get the answers!
*/

SELECT 
COUNT(*) AS number_of_movies
FROM film
WHERE description LIKE '%Documentary%';


/*
// LIKE
QUESTION 5: How many customers are there with a first name that is
3 letters long and either an 'X' or a 'Y' as the last letter in the last name?
Write a SQL query to get the answers!
*/

SELECT *
FROM customer
WHERE first_name LIKE '___'
	AND
	(last_name LIKE '%X'
	OR last_name LIKE '%Y');


/*
QUESTION 6: How many movies are there that contain 'Saga'
in the description and where the title starts either with 'A' or ends with 'R'?
Use the alias 'no_of_movies'.
*/
SELECT
COUNT(*) AS no_of_movies
FROM film
WHERE description LIKE '%Saga%'
	AND
	  (title LIKE 'A%'
	  OR title LIKE '%R');

/*
QUESTION 7: Create a list of all customers where the first name contains 'ER' and has an 'A' as the second letter.
Order the results by the last name descendingly.
*/
SELECT *
FROM customer
WHERE first_name LIKE '%ER%'
  AND first_name LIKE'_A%'
ORDER BY last_name DESC;				 

/*
QUESTION 8: How many payments are there where the amount is either O or is between 3.99 and 7.99 and in the same time has
happened on 2020-05-01 
*/

SELECT *
FROM payment
WHERE (amount = 0 OR
	  amount BETWEEN 3.99 AND 7.99)
AND payment_date BETWEEN '2020-05-01' AND '2020-05-02';

