--ex4
select p.page_id
from pages p
left join page_likes pl
on p.page_id = pl.page_id
where pl.page_id is null
order by pl.page_id
--ex5
  em ko co hieu cau nay @@
--ex6
select date_format(trans_date, '%Y-%m')  as month,
country,
count(id) as trans_count,
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' THEN amount else 0 end ) AS approved_total_amount
from Transactions
group by month,country;
--ex7
with mintable AS (
select product_id, min(year) as min_year
from sales
group by product_id)

select s.product_id, s.year as first_year, quantity, price
from sales s
join mintable m ON s.product_id = m.product_id and s.year = m.min_year
--ex8
select customer_id from Customer
group by customer_id
having count(distinct product_key) = (select count(distinct product_key) 
from product)
--ex9
select e.employee_id
from employees e
where e.salary < 30000 and e.manager_id not in(select employee_id from employees)
order by employee_id 
--ex10
with job as (
  select company_id
  from job_listings
  group by company_id, title, description
  having count(job_id) > 1
)
select count(*) AS duplicate_companies
from job
