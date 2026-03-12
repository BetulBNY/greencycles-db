-- Mathematical Functions and operators
--https://www.postgresql.org/docs/9.5/functions-math.html
-- CASE-WHEN :
	/*	
	CASE
	WHEN condition1 THEN resulti
	WHEN condition2 THEN result
	WHEN conditionN THEN resultN
	ELSE result
	END
	*/

/*
QUESTION 1:
Your manager is thinking about increasing the prices for films that are more expensive to replace.
For that reason, you should create a list of the films including the relation of
rental rate / replacement cost where the rental rate is less than 4% of the replacement cost.
Create a list of that film_ids together with the percentage rounded to 2 decimal places. For example 3.54 (=3.54%).
*/

SELECT 
film_id,
rental_rate,
replacement_cost,
ROUND((rental_rate / replacement_cost) * 100,2) AS rate_percentage
FROM film
Where rental_rate < (replacement_cost*4)/100
ORDER BY rate_percentage ASC;

/*
QUESTION 2: 
You want to create a tier list in the following way:
1. Rating is 'PG' or 'PG-13' or length is more then 210 min:
'Great rating or long (tier 1)
2. Description contains 'Drama' and length is more than 90min:
'Long drama (tier 2)'
Description contains 'Drama' and length is not more than 90min:
'Short drama (tier 3)"
4. Rental_rate less than $1:
'Very cheap (tier 4)"
If one movie can be in multiple categories it gets the higher tier assigned.
How can you filter to only those movies that appear in one of these 4 tiers?
*/

SELECT
title,
CASE
WHEN rating='PG' OR rating = 'PG-13' OR length >210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' AND length < 90 THEN 'Short drama (tier 3)'
WHEN rental_rate < 1 THEN 'Very cheap (tier 4)'
END as tier_list
FROM film
-- For just bringing not null values
-- WHERE tier_list IS NOT NULL  // This is not works because in "where" filtering we cannot use alias.
-- So we make it longer:
WHERE CASE
WHEN rating='PG' OR rating = 'PG-13' OR length >210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' AND length < 90 THEN 'Short drama (tier 3)'
WHEN rental_rate < 1 THEN 'Very cheap (tier 4)'
END is not null;

/*
// CASE WHEN & SUM
QUESTION 3 : Get sum of PG and G ratings.
*/
SELECT
SUM(CASE
WHEN rating IN ('PG', 'G') THEN 1
ELSE 0
END) AS no_of_ratings_with_g_or_pg
FROM film;


/*
// Pivot
QUESTION 4 : Pivot rating table.
*/
SELECT
SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS "G",
SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS "R",
SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS "NC-17",
SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS "PG-13",
SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS "PG"
FROM film;

/*
// COALESCE & CAST
QUESTION 5 : Replace null areas inside return_date with value 'not Return'
*/
SELECT
rental_date,
COALESCE(CAST(return_date AS VARCHAR), 'not Return')
FROM rental
ORDER BY rental_date;

