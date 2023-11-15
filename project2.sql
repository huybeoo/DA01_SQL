--1
select EXTRACT(YEAR FROM created_at) || '-' || EXTRACT(MONTH FROM created_at) as month_year
,count(user_id) as total_user,count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete' and created_at between '2019-01-01' and '2022-04-01'
group by created_at,user_id;
--2
select EXTRACT(YEAR FROM created_at) || '-' || EXTRACT(MONTH FROM created_at) as month_year,
count(distinct(user_id)) as distinct_user,sum(sale_price)/count(order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-01' and '2022-04-01'
group by created_at,user_id;
--3
with cte as
(
select first_name,last_name,gender,age,
case
when age = (select min(age) from bigquery-public-data.thelook_ecommerce.users) then 'youngest'
end as tag
 from bigquery-public-data.thelook_ecommerce.users
union
select first_name,last_name,gender,age,
case
when age = (select max(age) from bigquery-public-data.thelook_ecommerce.users) then 'oldest'
end as tag
from bigquery-public-data.thelook_ecommerce.users)

select gender,age,tag, count(*)
from cte
group by gender, age, tag
 
--4
SELECT 
EXTRACT(YEAR FROM t.created_at) || '-' || EXTRACT(MONTH FROM t.created_at) as month_year,
s.id as id,
s.name as name,
sum(s.cost) as cost,
sum(s.retail_price) as price,
sum(s.retail_price) - sum(s.cost) as profit,
dense_rank() over(partition by s.id order by s.retail_price - s.cost desc)
FROM bigquery-public-data.thelook_ecommerce.products s
join bigquery-public-data.thelook_ecommerce.order_items t on s.id = t.product_id
where DATE(t.created_at) BETWEEN '2019-01-01' AND '2022-04-30'
group by 1,s.id,s.name,s.cost,s.retail_price
 
--5
SELECT 
EXTRACT(YEAR FROM t.created_at) || '-' || EXTRACT(MONTH FROM t.created_at) as month_year,
s.category,
sum(t.sale_price)
FROM bigquery-public-data.thelook_ecommerce.products s
join bigquery-public-data.thelook_ecommerce.order_items t on s.id = t.product_id
group by 1,2


