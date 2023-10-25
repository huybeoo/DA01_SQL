--q1
select distinct(title),replacement_cost from film
order by replacement_cost
limit 1;
--q2
select
sum(case 
	when replacement_cost between 9.99 and 19.99 then 1 else 0 
end) as low,
sum(case 
	when replacement_cost between 20.00 and 24.99 then 1 else 0 
end) as high,
sum(case 
	when replacement_cost between 25.00 and 29.99 then 1 else 0 
end) as medium
from film;
--q3
select f.title,f.length,ct.name from film f
join film_category fc on f.film_id = fc.film_id
join category ct on ct.category_id = fc.category_id
where ct.name in ('Drama','Sports')
order by f.length desc
limit 1
--q4
select count(f.title) as count ,ct.name from film f
join film_category fc on f.film_id = fc.film_id
join category ct on ct.category_id = fc.category_id
group by ct.name
order by count desc
limit 1
--q5
select count(fa.film_id) as soluongphim ,at.first_name ||' '|| at.last_name as nameat from film f
join film_actor fa on f.film_id = fa.film_id
join actor at on fa.actor_id = at.actor_id
group by nameat
order by soluongphim desc
limit 1
--q6
select count(ad.address) filter (where cs.last_name is NULL) from address ad
left join customer cs on ad.address_id = cs.address_id
--q7
select c.city as city,sum(pm.amount) as amount from city c
join address ad on c.city_id = ad.city_id
join customer cs on cs.address_id = ad.address_id
join payment pm on cs.customer_id = pm.customer_id
group by city
order by amount desc
limit 1
--q8
select ct.country ||' , '|| c.city as city,count(pm.amount) as amount from city c
join address ad on c.city_id = ad.city_id
join customer cs on cs.address_id = ad.address_id
join payment pm on cs.customer_id = pm.customer_id
join country ct on c.country_id = ct.country_id
group by ct.country ||' , '|| c.city
order by amount desc
