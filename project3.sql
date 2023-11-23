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
--5
select * from customer
select * from sales
select * from segment_score

with rfm as (
select cs.customer_id as id,
current_date - max(sl.order_date) as r,
count(order_id) as f,
sum(sales) as m
from customer cs
join sales sl on cs.customer_id = sl.customer_id
group by 1),
rfmscore as(
select id,
ntile(5) over(order by r desc) as rscore,
ntile(5) over(order by f ) as fscore,
ntile(5) over(order by m ) as mscore
from rfm),
rfm_final as(
select id,cast(rscore as varchar)||cast(fscore as varchar)||cast(mscore as varchar) as rfm
from rfmscore 
)

select id,ss.segment from rfm_final rf
join segment_score ss on ss.scores = rf.rfm
where ss.segment = 'Champions'


