----------- UNION
/*
UNION combines the results of two or more SELECT queries into a single result set and automatically removes duplicate rows.
Example Usage:
	SELECT first_name, last_name
	FROM customer
	UNION
	SELECT first_name, last_name
	FROM staff;
NOTE: Must be aware of the order in match
NOTE 2: Data type must match!
NOTE 3: Number of columns must match
NOTE 4: If you have duplicated values in a table or with other tables. In the UNION output there will be only 1 value.
In output theer will not be duplicated.
NOTE 5: If you want duplicated use "UNION ALL"
*/

-- SAMPLE 1:
SELECT first_name FROM actor
UNION ALL
SELECT first_name FROM customer
ORDER BY first_name;

-- SAMPLE 2: Add a fixed value to distinguish between the actor and customer names. Then see where values come from.
SELECT first_name, 'actor' FROM actor
UNION ALL
SELECT first_name, 'customer' FROM customer
ORDER BY first_name;

-- SAMPLE 3: Multiple unions.
SELECT first_name, 'actor' as origin FROM actor
UNION 
SELECT first_name, 'customer' as test1 FROM customer
UNION 
SELECT UPPER(first_name), 'staff' as test2 FROM staff
ORDER BY 2 DESC;


----------- SUBQUERIES IN WHERE
/*
Subquery: A subquery is a query nested inside another SQL query and is used to provide a result that the outer query can use.
NOTE 6: In a WHERE clause, a subquery cannot return more than one column.
Example Usage: 
	SELECT first_name, last_name
	FROM customer
	WHERE customer_id IN (
	    SELECT customer_id
	    FROM payment
	    WHERE amount > 10		 
);
*/

-- SAMPLE 4: Return all of the payments where the payment amount is greater then average payment amount.
SELECT AVG(amount) 
FROM payment;
-- Save result: 4.2006673312979002 

SELECT * 
FROM payment
WHERE amount > 4.2006673312979002;

-- But it is not an efficient way because avg can change, every time we can't calculate it manually.
-- I want to use more flexible/dynamic way. So I will use Subqueries

-- Dynamic Solution:
SELECT * 
FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);

-- SAMPLE 5: Get all of the payments of customer called 'ADAM'
SELECT * 
FROM payment
WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = 'ADAM');

-- SAMPLE 6: Get all of the payments of customer name start with 'A'
SELECT * 
FROM payment
WHERE customer_id IN (SELECT customer_id FROM customer WHERE first_name LIKE 'A%');

-- NOTE 7: We can either use 'IN' operator if we have list of multiple values or we can use '=,>,<'
-- if we have just single value ins subqueries.

-- QUESTION 1: Select all of the films where the length is longer than the average of all films.
SELECT * FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- QUESTION 2: Return all the films that are available in the inventory in store 2 more than 3 times.
SELECT * FROM film
WHERE film_id IN 
	(SELECT film_id
	FROM inventory
	WHERE store_id = 2
	GROUP BY film_id
	HAVING COUNT(*) > 3);

-----------HAVING:
/*
HAVING is used to filter grouped results after a GROUP BY clause, usually based on aggregate functions like COUNT, SUM, or AVG.
	SELECT customer_id, COUNT(rental_id)
	FROM rental
	GROUP BY customer_id
	HAVING COUNT(rental_id) > 30;
*/

-- QUESTION 3: Return all customers' first names and last names that have made a payment on '2020-01-25'.
SELECT first_name, last_name 
FROM customer
WHERE customer_id IN
	(SELECT customer_id
	FROM payment
	WHERE DATE(payment_date) = '2020-01-25')
ORDER BY first_name;

-- QUESTION 4: Return all customers' first_names and email addresses that have spent a more than $30.
SELECT first_name, email
FROM customer
WHERE customer_id IN
	(SELECT customer_id 
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 30);

-- QUESTION 5: Return all the customers' first and last names that are from California and have spent more than 100 in total.

-- address --> customer --> payment
SELECT first_name, last_name 
FROM customer
WHERE customer_id IN
	(SELECT c.customer_id FROM address a
	INNER JOIN customer c
	ON a.address_id = c.address_id
	AND district = 'California'
	INNER JOIN payment p
	ON c.customer_id = p.customer_id
	WHERE c.customer_id IN (SELECT customer_id 
						 FROM payment
						 GROUP BY customer_id
						 HAVING SUM(amount) > 100));
-- SOLUTION 2:
SELECT first_name, last_name 
FROM customer
WHERE customer_id IN
	(SELECT customer_id 
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 100)
AND customer_id IN (SELECT customer_id
					FROM customer
					INNER JOIN address
					ON address.address_id = customer.address_id	
					AND district = 'California');
-- SOLUTION 3:
Select first_name, last_name
from customer
Where customer_id IN
	(Select customer_id  from payment
	group by customer_id
	having sum(amount) > 100) 
AND address_id IN 
	(SELECT address_id from address
	where district = 'California');

-----------SUBQUERIES IN FROM

-- SAMPLE 7: Find out the average lifetime spend per customer.
SELECT ROUND(AVG(total_amount),2) as avg_lifetime_spend
FROM
	(SELECT customer_id, SUM(amount) as total_amount  -- alias is mandatory
	FROM payment
	GROUP BY customer_id) as subquery;  -- alias is mandatory

-- QUESTION 6: What is the average total amount spent per day (average daily revenue)?
SELECT ROUND(AVG(per_day),2)
FROM 
	(SELECT SUM(amount) as per_day
	FROM payment
	GROUP BY DATE(payment_date)) as amount_spent_per_day;

----------- SUBQUERIES IN SELECT
-- It works because there is just 1 value/row output of paranthesis.
SELECT *, (SELECT ROUND(AVG(amount), 2) FROM payment)
FROM payment;

-- It will not work. Because inside paranthesis there are multiple values.
/*
SELECT *, (SELECT amount FROM payment)
FROM payment;
*/
-- How it can run? If I use "Limit 1"
SELECT *, (SELECT amount FROM payment LIMIT 1)
FROM payment;

-- QUESTION 7: Show all the payments together with how much the payment amount is below the maximum payment amount.
SELECT *, 
	(SELECT MAX(amount) FROM payment) - amount as diff_of_payment
FROM payment;

----------- CORRELATED SUBQUERIES IN WHERE
-- Correlated subquery does not work independently because it has other references, it related with outer query.

-- SAMPLE 8: Show only those payments that have the highest amount per customer. 	 	
SELECT customer_id, amount  FROM payment p1
WHERE amount = 
	(SELECT MAX(amount) FROM payment p2
	WHERE p1.customer_id = p2.customer_id
	GROUP BY customer_id)
ORDER BY p1.customer_id ASC;

-- QUESTION 8: Show only those movie titles, their associated film_id and replacement_cost with the 
-- lowest replacement_costs for in each rating category - also show the rating.
SELECT film_id, title, replacement_cost, rating FROM film f1
WHERE replacement_cost = 
	(SELECT MIN(replacement_cost) FROM film f2
	WHERE f1.rating = f2.rating);

-- QUESTION 9: Show only those movie titles, their associated film_id and the length that have the highest length 
-- in each rating category - also show the rating.
SELECT film_id, title, length, rating FROM film f1
WHERE length =  
	(SELECT MAX(length) FROM film f2
	WHERE f1.rating = f2.rating);

----------- CORRELATED SUBQUERIES IN SELECT
-- SAMPLE 9: Show the maximum amount every customer.
SELECT *,
(SELECT MAX(amount) FROM payment p2
WHERE p1.customer_id = p2.customer_id )
FROM payment p1
ORDER BY customer_id;

-- ALTERNATIVE 1 (GROUP BY + JOIN) → higher performance
SELECT p1.*, p2.max_amount
FROM payment p1
JOIN (
    SELECT customer_id, MAX(amount) AS max_amount
    FROM payment
    GROUP BY customer_id
) p2
ON p1.customer_id = p2.customer_id
ORDER BY p1.customer_id;

-- ALTERNATIVE 2 (WINDOW FUNCTION) → the best way
SELECT *,
MAX(amount) OVER (PARTITION BY customer_id) AS max_amount
FROM payment
ORDER BY customer_id;


-- QUESTION 10: Show all the payments plus the total amount for every customer as well as the number of payments of each customer.
SELECT * FROM payment;

-- Correlated Subquery Solution:
SELECT *, 
	(SELECT SUM(amount) FROM payment p2
	WHERE p1.customer_id = p2.customer_id) AS total_amount_of_payment,
	(SELECT COUNT(*) FROM payment p3
	WHERE p1.customer_id = p3.customer_id) AS number_of_payments
FROM payment p1
ORDER BY customer_id, amount DESC;

-- Window Function Solution:
SELECT *,
	SUM(amount) OVER(PARTITION BY customer_id),
	COUNT(*) OVER (PARTITION BY customer_id)
FROM payment
ORDER BY customer_id;

-- QUESTION 11: Show only those films with the highest replacement costs in their rating category plus show the average replacement cost in their rating category.
SELECT film_id, title, rating, replacement_cost,  
	(SELECT MAX(replacement_cost) FROM film f2 WHERE f1.rating = f2.rating) AS max_rep_cost,
	(SELECT ROUND(AVG(replacement_cost),2) FROM film f2 WHERE f1.rating = f2.rating) AS avg_rep_cost
FROM film f1
ORDER BY replacement_cost DESC;

-- Second Solution:
SELECT film_id, title, rating, replacement_cost,  
	(SELECT ROUND(AVG(replacement_cost),2) FROM film f2 WHERE f1.rating = f2.rating) AS avg_rep_cost
FROM film f1
WHERE replacement_cost = (SELECT MAX(replacement_cost) FROM film f2 WHERE f1.rating = f2.rating);

-- QUESTION 12: Show only those payments with the highest payment for each customer's first name - including the payment_id of that payment.
-- How would you solve it if you would not need to see the payment_id?

SELECT first_name, payment_id, amount
FROM customer c
INNER JOIN payment p2
ON c.customer_id = p2.customer_id
WHERE amount = (SELECT MAX(amount) FROM payment p1 WHERE p1.customer_id = c.customer_id );

-- Without payment_id:
SELECT first_name, MAX(amount)
FROM customer c
INNER JOIN payment p2
ON c.customer_id = p2.customer_id
GROUP BY first_name;






















