--ex1
SELECT
ROUND(SUM(CASE WHEN customer_pref_delivery_date = order_date THEN 1 ELSE 0 END) / COUNT(DISTINCT customer_id) * 100, 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
SELECT customer_id, MIN(order_date) AS first_order_date
FROM Delivery
GROUP BY customer_id
);
--ex2
select round(sum(a)/count(distinct(player_id)),2) as fraction from 
(select player_id,DATEDIFF(event_date, MIN(event_date) OVER(PARTITION BY player_id))=1 as a from Activity) as b
--ex3
--ex4
--ex5
--ex6
with cte as (
select dp.name as Department,em.name as Employee,em.salary as Salary
,dense_rank() Over (Partition by dp.Name Order by em.salary desc) as rnk
from Employee em
right join Department dp on dp.id = em.departmentId)

select Department, Employee, Salary
from cte
where rnk < 4
order by Department, Salary DESC
--ex7
with cte as (
select *, 
sum(weight) over (
order by turn) as totalweight
from Queue
order by turn)

select person_name from cte 
where totalweight<=1000
order by totalweight desc
limit 1
--ex8
