/* Query1 - query used for Q1 */

WITH tab_1 AS
(SELECT *
FROM film
JOIN film_category
ON film.film_id = film_category.film_id
JOIN category
ON category.category_id = film_category.category_id
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
WHERE name = 'Animation' OR name = 'Children' OR name = 'Comedy' OR name = 'Family' OR name = 'Classics' OR name = 'Music')

SELECT
    tab_1.title AS film_title,
    tab_1.name AS category_name,
    COUNT(tab_1.title)
FROM tab_1
GROUP BY 1, 2
ORDER BY category_name, film_title;


/* Query 2 - query used for Q2 */
WITH tab_1 AS
(SELECT *
FROM film
JOIN film_category
ON film.film_id = film_category.film_id
JOIN category
ON category.category_id = film_category.category_id
WHERE name = 'Animation' OR name = 'Children' OR name = 'Comedy' OR name = 'Family' OR name = 'Classics' OR name = 'Music')

SELECT
	tab_1.title,
    tab_1.name,
    tab_1.rental_duration,
    NTILE(4) OVER (ORDER BY tab_1.rental_duration) AS standard_quartile
FROM tab_1
ORDER BY standard_quartile;


/* Query 3 - query used for Q3 */

WITH tab_1 AS
(SELECT 
 	category.name,
	NTILE(4) OVER (ORDER BY film.rental_duration) AS standard_quartile
 
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film.film_id = film_category.film_id
WHERE category.name = 'Animation' OR category.name = 'Children' OR category.name = 'Comedy' OR category.name = 'Family' OR category.name = 'Classics' OR category.name = 'Music'
ORDER BY name, standard_quartile)

SELECT 
    tab_1.name, 
    tab_1.standard_quartile, 
    COUNT(*)
FROM tab_1
GROUP BY 1,2
ORDER BY name, standard_quartile;


/* Query 4 - query used for Q4 */

WITH tab_1 AS
(SELECT 
 	DATE_PART('month', rental_date) as month, 		DATE_PART('year', rental_date) as year, 		store_id, 
 	COUNT (film_id) OVER (PARTITION BY DATE_TRUNC('month', rental_date) ORDER BY store_id) as count_rentals
FROM rental
JOIN inventory
ON inventory.inventory_id = rental.inventory_id)

SELECT 
	tab_1.month rental_month, 
    tab_1.year rental_year, 
    tab_1.store_id,
    COUNT(count_rentals) AS count_rentals
FROM tab_1
GROUP BY 1, 2, 3
ORDER BY count_rentals DESC
