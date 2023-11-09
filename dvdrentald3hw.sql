SELECT *
FROM staff;

SELECT *
FROM rental;

SELECT first_name, last_name, staff.staff_id, COUNT(staff.staff_id)
FROM staff
FULL JOIN rental
ON staff.staff_id = rental.staff_id
WHERE staff.staff_id IS NOT NULL
GROUP BY staff.staff_id;

SELECT *
FROM actor;

SELECT *
FROM film_actor;

SELECT *
FROM staff;

SELECT *
FROM film;

-- Query for film_id's from the film_actor table and which actors appear with those film_id's
SELECT actor.actor_id, first_name, last_name, film_id
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id;

-- Query to see which actors are in what films
SELECT first_name, last_name, title, description
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id;

--- LEFT JOIN  on the acdtor table film_actor table
SELECT actor.actor_id, first_name, last_name, film_id
FROM actor
LEFT JOIN film_actor
ON actor.actor_id = film_actor.actor_id


--- find all customers who live in the country of Angola
SELECT first_name, last_name, customer.address_id, country.country
FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON country.country_id = city.country_id AND country = 'Angola'

--- same as above
SELECT first_name, last_name, customer.address_id, country.country
FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON country.country_id = city.country_id
WHERE country = 'Angola'

--- sub Queries Query within a Query
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 175
ORDER BY SUM(amount) DESC;

-- Subquery to find the 6 customers that have
-- A total amount of payments greater than 175

SELECT store_id,first_name,last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);



SELECT first_name, last_name, address.address
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id AND country.country = 'United States'
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id, first_name, last_name, address
HAVING SUM(amount) > 175;

--Subquery within the same table 
-- query for amounts paid greater than the average amount paid
SELECT AVG(amount)::NUMERIC(6, 2)
FROM payment;

SELECT payment_id, amount
FROM payment
WHERE amount > 4.20;

-- same as above
-- subquery to find amounts paid greater than the average amount paid
SELECT payment_id, amount
FROM payment
WHERE amount > (
	SELECT AVG(amount) FROM payment
);

-- Basic Subquery 
-- Find all films with a language of 'English'

SELECT first_name, last_name, address_id
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE city = 'Dallas'		
)
);

SELECT * 
FROM category;

-- Grab all movies from the action category
SELECT title, film_id
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN (
		SELECT category_id
		FROM category
		WHERE name = 'Action'
		
	)
)



SELECT *
FROM PAYMENT


************************************** HOME ASSIGMENT*********************************************

-- 1. List all customers who live in Texas (use JOINs)
SELECT *
FROM city;


SELECT first_name, last_name, address.district
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id

WHERE district = 'Texas'


-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT customer.customer_id, customer.customer_id, payment.amount
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment.amount > 6.99;

-- 3. Show all customers names who have made payments over $175(use subqueries)
-- SELECT *
-- FROM customer;

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);

-- 4. List all customers that live in Nepal (use the city table)
SELECT first_name, last_name, customer.address_id, country.country
FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON country.country_id = city.country_id
WHERE country = 'Nepal'

-- 5. Which staff member had the most transactions?
-- SELECT *
-- FROM staff;

SELECT COUNT(staff.staff_id), first_name, last_name
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.staff_id
INNER JOIN rental
ON payment.rental_id = rental.rental_id
GROUP BY staff.staff_id 
ORDER BY COUNT(staff.staff_id) DESC
LIMIT 1;


-- 6. How many movies of each rating are there?

SELECT COUNT(rating), rating
FROM film
GROUP BY rating;

-- 7.Show all customers who have made a single payment
-- above $6.99 (Use Subqueries)

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
 SELECT customer_id
 FROM payment 
 WHERE payment.amount > 6.99
 GROUP BY customer_id
 HAVING COUNT(payment.amount) = 1
);

-- 8. How many free rentals did our stores give away?
SELECT COUNT(rental)
FROM rental
INNER JOIN payment
ON rental.rental_id = payment.rental_id
WHERE amount = 0.00;
