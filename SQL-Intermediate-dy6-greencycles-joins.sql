-- JOINS
/*
NOTES:
Outer Joinlerde bir taraf "ayrıcalıklıdır" ve her halükarda korunur.
Inner Join'de kimse "ayrıcalıklı" değildir; sadece ortak olanlar (kesişim) kalır. Bu yüzden Inner Join'in sağı-solu yoktur.
*/

-- Inner Join: Sadece her iki tabloda da karşılığı olan (kesişen) satırları getirir; eşleşmeyenleri her iki taraftan da atar.
SELECT * FROM payment;

-- EXAMPLE 1:
SELECT pa.*, first_name, last_name --pa.* means select all columns from payment
FROM payment pa
INNER JOIN staff st
ON pa.staff_id = st.staff_id
WHERE st.staff_id = 1;

-- EXAMPLE 2:
SELECT payment_id, pa.customer_id, amount, first_name, last_name
FROM payment pa
INNER JOIN customer cu
ON cu.customer_id = pa.customer_id
WHERE amount > 8;


-- Left Outer Join: Sol tablodaki tüm satırları getirir; sağda karşılığı olmayan sol satırlar için sağ tarafı NULL ile doldurur, sağdaki eşleşmeyen satırları ise hiç almaz.


-- QUESTION 1: 
-- The company wants to run a phone call campaing on all customers in Texas (=district).
-- What are the customers (first_name, last_name, phone number and their district) from Texas?

SELECT * FROM address;
SELECT * FROM customer;

-- Version 1:
SELECT first_name, last_name, phone, district
FROM customer cu
INNER JOIN address ad
ON ad.address_id = cu.address_id
WHERE ad.district = 'Texas';

-- Version 2: This solution is more performance efficient!
SELECT first_name, last_name, phone, district
FROM customer cu
INNER JOIN address ad
ON ad.address_id = cu.address_id
AND ad.district = 'Texas';

-- QUESTION 2: Are there any (old) addresses that are not related to any customer?
-- With Right Join
SELECT*
FROM customer cu
RIGHT JOIN address ad
ON ad.address_id = cu.address_id
WHERE cu.address_id IS NULL;
-- With Left Join
SELECT*
FROM address ad
LEFT JOIN customer cu
ON ad.address_id = cu.address_id
WHERE cu.address_id IS NULL;

-- QUESTION 3: The company wants customize their campaigns to customers depending on the country they are from.
-- Which customers are from Brazil?
-- Write a query to get first_name, last_name, email and the country from all customers from Brazil.

/*
customer -->  address -->  city -->  country
(address_id) (address_id) 
			 (city_id)    (city_id)  
			 			  (country_id)(country_id)
*/

SELECT first_name, last_name, email, country FROM
customer c
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id
AND country = 'Brazil';

-- QUESTION 4: Which title has GEORGE LINTON rented the most often?

SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM inventory;

-- customer  -->  rental  -->  inventory  -->  film

SELECT title, COUNT(rental_id) FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN film f
ON f.film_id = i.film_id 
WHERE first_name = 'GEORGE' AND last_name = 'LINTON'
GROUP BY title 
ORDER BY COUNT(rental_id) DESC;
