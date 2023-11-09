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
