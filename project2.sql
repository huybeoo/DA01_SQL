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
 from bigquery-public-data.thelook_ecommerce.users;
--4
SELECT 
EXTRACT(YEAR FROM t.created_at) || '-' || EXTRACT(MONTH FROM t.created_at) as month_year,
s.id as id,
s.name as name,
s.cost as cost,
s.retail_price as price,
s.retail_price - s.cost as profit,
dense_rank() over(partition by s.id order by s.retail_price - s.cost desc)
 FROM bigquery-public-data.thelook_ecommerce.products s
join bigquery-public-data.thelook_ecommerce.order_items t on s.id = t.product_id
group by 1,s.id,s.name,s.cost,s.retail_price
--5
SELECT 
EXTRACT(YEAR FROM t.created_at) || '-' || EXTRACT(MONTH FROM t.created_at) as month_year,
s.category,
sum(t.sale_price)
FROM bigquery-public-data.thelook_ecommerce.products s
join bigquery-public-data.thelook_ecommerce.order_items t on s.id = t.product_id
group by 1,2


select EXTRACT(YEAR FROM ord.created_at) || '-' || EXTRACT(MONTH FROM ord.created_at)|| '-' || '01' as year,
extract (month from ord.created_at) as month,
sum(ordi.sale_price) as tpv,
count(ordi.order_id) as tpo,
round(100 * (sum(ordi.sale_price) - lag(sum(ordi.sale_price)) over(partition by 1,2 order by 1,2 ))/lag(sum(ordi.sale_price)) over(partition by 1,2 order by 1,2 ),2)||'%' as Revenue_growth,
round(100 * (count(ordi.order_id) -lag(count(ordi.order_id)) over(partition by 1,2 order by 1,2))/lag(count(ordi.order_id)) over(partition by 1,2 order by 1,2),2)||'%' as Order_growth,
sum(pd.cost) as total_cost,
sum(ordi.sale_price) - sum(pd.cost) as total_profit,
sum(ordi.sale_price) / sum(pd.cost) as Profit_to_cost_ratio
from bigquery-public-data.thelook_ecommerce.orders ord
join bigquery-public-data.thelook_ecommerce.order_items ordi
on ord.order_id = ordi.order_id
join bigquery-public-data.thelook_ecommerce.products pd
on ordi.product_id = pd.id
group by 1,2

