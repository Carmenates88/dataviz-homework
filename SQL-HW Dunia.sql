USE Sakila;

#1a.Display the first and last names of all actors from the table actor
SELECT first_name, last_name
FROM actor

#1b. Display the first and last name of each actor in a single column in upper case letters.
# Name the column Actor Name.
SELECT CONCAT(first_name,' ',  last_name)
AS 'Actor Name'
FROM actor

#2a. You need to find the ID number, first name, and last name of an actor, 
# of whom you know only the first name,"Joe." 
# What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
	WHERE first_name= 'Joe'

#2b. Find all actors whose last name contain the letters GEN
SELECT *
FROM actor
	WHERE last_name LIKE ('%GEN%')

#2c. Find all actors whose last names contain the letters LI. 
# This time, order the rows by last name and first name, in that order
SELECT *
FROM actor
	WHERE last_name LIKE ('%LI%')
	ORDER BY last_name, first_name

#2d. Using IN, display the country_id and country columns 
# of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
	WHERE country IN ('Afghanistan', 'Bangladesh', 'China')


#3a.You want to keep a description of each actor. You don't think you will be performing queries on a description,
# so create a column in the table actor named description and use the data type BLOB 
#(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
SELECT * FROM actor;
ALTER TABLE actor
ADD COLUMN  description VARCHAR(50) AFTER first_name;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort.
# Delete the description column.
SELECT * FROM actor;
ALTER TABLE actor
DROP COLUMN description; 


#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name AS 'Last Names', COUNT(*) AS 'Count'
FROM actor
	GROUP BY last_name

#4b. List last names of actors and the number of actors who have that last name,
# but only for names that are shared by at least two actors
SELECT last_name AS 'Last Name', COUNT(*) AS 'Count'
FROM actor
	GROUP BY last_name
	HAVING Count > 2; 


#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
# Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name ='GROUCHO' AND last_name = 'WILLIAMS' 

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name ='HARPO' AND last_name = 'WILLIAMS' 

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE sakila.address

#6a. Use JOIN to display the first and last names, as well as the address, 
#of each staff member. Use the tables staff and address
SELECT s.first_name, s.last_name, a.address 
FROM staff AS s 
JOIN address AS a ON (a.address_id = s.staff_id)

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.
SELECT s.first_name AS 'First Name', s.last_name AS 'Last Name', SUM(p.amount) AS 'Total Amount' 
FROM staff AS s
JOIN payment AS p ON (s.staff_id= p.staff_id)
	WHERE payment_date >= '2005-05-01' AND payment_date <= '2005-05-30'
	GROUP BY s.first_name, s.last_name;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
SELECT 
	f.title AS 'Film', 
	COUNT(DISTINCT a.actor_id) AS 'Number of Actors'
FROM film AS f
	LEFT JOIN film_actor AS a ON (a.film_id =f.film_id)
	GROUP BY f.title


#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title AS 'Film', COUNT(i.film_id) AS 'Number of copies'
FROM film AS f
LEFT JOIN inventory AS i ON (i.film_id =f.film_id)
	WHERE title= 'Hunchback Impossible'


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
# List the customers alphabetically by last name
SELECT 
	c.first_name AS 'First Name', 
	c.last_name AS 'Last Name', 
	SUM(p.amount) AS 'Total Amount Paid'
FROM customer AS c
LEFT JOIN  payment AS p ON (p.customer_id= c.customer_id)
	GROUP BY c.last_name
	ORDER BY c.last_name ASC
    
#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title
FROM film AS f
JOIN language AS l ON (l.language_id= f.language_id)
	WHERE l.name ='English' AND 
    f.title LIKE'K%' OR
    f.title LIKE 'Q%'
    
#7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
JOIN film_actor AS fa ON (fa.actor_id =a.actor_id)
JOIN film AS f ON (f.film_id =fa.film_id)
	WHERE title= 'Alone Trip'
    
   
#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information
SELECT c.first_name,c.last_name, c.email 
FROM customer AS c
INNER JOIN address AS a ON (a.address_id= c.address_id)
INNER JOIN city AS ci ON (ci.city_id= a.city_id)
INNER JOIN country AS co ON (co.country_id= ci.country_id)
	WHERE co.country = 'CANADA'

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
# Identify all movies categorized as family films
SELECT f.title
FROM film AS f 
INNER JOIN film_category AS fc ON (fc.film_id=f.film_id)
INNER JOIN category AS c ON (c.category_id=fc.category_id)
	WHERE c.name= 'family'
    
#7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(i.film_id) AS 'Cant of Movies Rented'
FROM rental AS r
INNER JOIN  inventory  AS i ON(i.inventory_id=r.inventory_id)
INNER JOIN film AS f ON (f.film_id=i.film_id)
	GROUP BY f.title
	ORDER BY COUNT(i.film_id) desc;


#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount)
FROM store AS s
INNER JOIN staff AS st ON (st.store_id= s.store_id)
INNER JOIN payment AS p ON(p.staff_id =st.staff_id)
	GROUP BY s.store_id
        
  
#7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country 
FROM store AS s
INNER JOIN staff AS st ON (st.store_id= s.store_id)
INNER JOIN address AS a ON (a.address_id= st.address_id)
INNER JOIN city AS c ON(c.city_id=a.city_id)
INNER JOIN country AS co ON (co.country_id=c.country_id)
	GROUP BY s.store_id
    
#7h.List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables:category, film_category, inventory, payment, and rental.)    
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category AS c
JOIN film_category AS fc ON (c.category_id=fc.category_id)
JOIN inventory AS i ON (fc.film_id=i.film_id)
JOIN rental AS r ON (i.inventory_id=r.inventory_id)
JOIN payment AS p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing 
#the Top five genres by gross revenue. Use the solution from the problem above 
#to create a view. If you haven't solved 7h, you can substitute another query 
#to create a view.
CREATE VIEW Top_five
AS SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT* FROM Top_Five

#8c. You find that you no longer need the view top_five_genres. 
#Write a query to delete it.
DROP VIEW Top_Five

