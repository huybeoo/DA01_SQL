--ex1
SELECT 
sum(CASE 
  WHEN device_type = 'laptop' then 1 ELSE 0
end) as laptop_views,
sum(CASE 
  WHEN device_type in ('tablet','phone') then 1 else 0
end) as mobile_views FROM viewership
;
--ex2
select x,y,z,
case 
    when x + y > z and y + z > x and x + z > y then 'Yes' else 'No' 
end as triangle
from TRIANGLE;
--ex3
SELECT
  ROUND(100.0*
    SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0 END)/COUNT(case_id), 1)
FROM
  callers;
--ex4
SELECT NAME FROM CUSTOMER
WHERE REFEREE_ID != "2" OR REFEREE_ID IS NULL ;
--ex5
SELECT
    SURVIVED,
    SUM(CASE WHEN PCLASS = 1 THEN 1 ELSE 0 END) AS FIRST_CLASS,
    SUM(CASE WHEN PCLASS= 2 THEN 1 ELSE 0 END) AS SECOND_CLASS,
    SUM(CASE WHEN PCLASS = 3 THEN 1 ELSE 0 END) AS THIRD_CLASS
FROM TITANIC
GROUP BY 
    SURVIVED
