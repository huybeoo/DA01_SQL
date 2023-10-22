--ex1
select country.continent, Floor(AVG(city.population)) from city ct 
INNER JOIN country ctr ON ct.countrycode=ctr.code 
group BY ctr.continent;
--ex2
SELECT 
ROUND(SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 ELSE 0 END)*1.0 / COUNT(t.signup_action),2)
FROM emails e LEFT JOIN texts t  
ON e.email_id  = t.email_id
--ex3
em chua hieu cau nay
--ex4
SELECT C.customer_id FROM customer_contracts C , products P
where C.product_id = P.product_id
group by C.customer_id
having COUNT(DISTINCT p.product_category) >= 3;
--ex5
select 
em2.employee_id, em2.name,count(*) as reports_count,
round(avg(em1.age)) as average_age
from 
employees em1 inner join employees em2 on em1.reports_to = em2.employee_id 
group by em2.employee_id, em2.name
order by em2.employee_id
--ex6
SELECT p.product_name,SUM(o.unit) AS unit
FROM Products p JOIN Orders o ON p.product_id = o.product_id
AND o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100
--ex7
SELECT t1.page_id FROM pages t1
LEFT JOIN page_likes t2 ON t1.page_id = t2.page_id
WHERE t2.page_id IS NULL 
ORDER BY t2.page_id
