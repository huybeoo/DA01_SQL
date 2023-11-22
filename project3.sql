--1
select produc_id as productline,
extract(year from order_date) as year_id,
sum(quantity) as dealsize,
sum(sales)
from sales
group by 1,2
  
--2
with cte as (
select extract(month from order_date) as month_id,
extract(year from order_date) as year_id,
sum(sales) as revanue,
count(order_line)
from sales
group by 1,2
),rank1 as (
select 
month_id,year_id,revanue,
rank() over(partition by year_id order by revanue desc) as rank
from cte
)

select * from rank1
where rank = 1
  
--3
with cte as(
select extract(month from order_date) as month_id,
extract(year from order_date) as year_id,produc_id,sum(sales),
count(order_line) as sl from sales
group by 1,2,3),
rank1 as (
select *,rank() over(order by sl desc) from cte
where month_id = 11
order by sl desc)
select month_id,year_id,produc_id from rank1
where rank = 1

--4
with cte as(
select extract(year from order_date) as year_id,s.order_id,s.produc_id,c.country,
sum(s.sales) as total
from sales s 
join customer c on c.customer_id = s.customer_id
group by 1,2,3,4
order by year_id asc ,total desc),
rank1 as (
select year_id,produc_id,country,total,
rank()over(partition by year_id order by total desc )from cte)

select * from rank1 
where rank = 1
