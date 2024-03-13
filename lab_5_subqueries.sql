SELECT * FROM inventory;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;


#Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
	f.title, COUNT(i.film_id) as nb_copies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible";

#List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT f.title, f.length
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film);

#Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 	a.first_name, a.last_name, f.title
from actor a
JOIN film_actor fa on a.actor_id = fa.actor_id
JOIN film f on fa.film_id = f.film_id
WHERE f.title = "Alone Trip";

#Sales have been lagging among young families, and you want to target family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT * FROM film_category;
SELECT * FROM category;

SELECT f.film_id, f.title, c.name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = "Family";

#Retrieve the name and email of customers from Canada using both subqueries and joins. 
#To use joins, you will need to identify the relevant tables and their primary and foreign keys.
select * from customer;
select * from address;
select * from city;
select * from country;

select c.first_name, c.last_name, c.email
from customer c
join address a on c.address_id = a.address_id
join city cty on a.city_id = cty.city_id
join country ctry on cty.country_id = ctry.country_id
where ctry.country = "Canada";

#Determine which films were starred by the most prolific actor in the Sakila database. 
#A prolific actor is defined as the actor who has acted in the most number of films. 
#First, you will need to find the most prolific actor and then use that actor_id to find the different 
#films that he or she starred in.
select * from film_actor;

select f.title, a.first_name, a.last_name
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where fa.actor_id = (select fa.actor_id 
					from film_actor fa 
					group by fa.actor_id 
                    order by count(fa.actor_id) desc 
                    limit 1);

#Find the films rented by the most profitable customer in the Sakila database. 
#You can use the customer and payment tables to find the most profitable customer, i.e., 
#the customer who has made the largest sum of payments.
select * from payment;
select * from rental;
select * from customer;
select * from film;
select * from inventory;

select p.customer_id, f.title
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.rental_id
join payment p on r.rental_id = p.rental_id
where p.customer_id = (
						select p.customer_id
						from payment p
						group by p.customer_id
						order by SUM(p.amount) desc
						limit 1);
                        
#Retrieve the client_id and the total_amount_spent of those clients who spent more than 
#the average of the total_amount spent by each client. You can use subqueries to accomplish this.

select c.customer_id, SUM(p.amount) as total_amount_spent
from customer c
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.rental_id
GROUP BY c.customer_id
HAVING total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT c.customer_id, SUM(p.amount) as total_amount_spent
        FROM customer c
        JOIN rental r ON c.customer_id = r.customer_id
        JOIN payment p ON r.rental_id = p.rental_id
        GROUP BY c.customer_id
    ) AS avg_amount_spent
);

						

