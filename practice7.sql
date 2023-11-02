--ex1
WITH CTE AS(
SELECT EXTRACT(year FROM transaction_date) AS year,
product_id,spend as curr_year_spend,
LAG(spend)OVER(PARTITION BY product_id) as prev_year_spend
FROM user_transactions)

SELECT * ,
ROUND(100.0*(curr_year_spend-prev_year_spend)/prev_year_spend,2) AS yoy_rate
FROM CTE
  
--ex2
WITH CTE AS (
SELECT card_name, issued_amount, issue_month ,dense_rank() over(partition BY card_name ORDER BY issue_year,issue_month) rnk
FROM monthly_cards_issued
)

SELECT card_name, issued_amount FROM CTE
WHERE rnk =1
ORDER BY issued_amount DESC
--ex3
  WITH CTE AS (
SELECT user_id, spend, transaction_date, 
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS row_num 
FROM transactions)
 
SELECT user_id, spend, transaction_date 
FROM CTE
WHERE row_num = 3;

--ex4
WITH CTE AS (
SELECT 
transaction_date,user_id,count(transaction_date) as purchase_count,
dense_rank() over(PARTITION BY user_id ORDER BY transaction_date desc) AS rnk
FROM user_transactions
GROUP BY transaction_date,user_id
ORDER BY user_id
)

SELECT 
transaction_date,user_id,purchase_count
FROM CTE 
WHERE rnk = 1
ORDER BY transaction_date;

--ex6
WITH CTE AS(
SELECT merchant_id, credit_card_id, amount,
transaction_timestamp - LAG(transaction_timestamp,1) OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) as NEXT_TRANS
FROM TRANSACTIONS
ORDER BY merchant_id, credit_card_id, amount
)

SELECT COUNT(*) AS payment_count
from CTE
WHERE EXTRACT(MINUTE FROM NEXT_TRANS) < 10
  
--ex7
WITH CTE AS (
SELECT category, product, SUM(spend) as total_spend,
DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) as ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product
)
  
SELECT category,product,total_spend FROM CTE
WHERE ranking <=2
ORDER BY category, ranking;

--ex8
WITH cte as (
select a.artist_name,COUNT(gs.rank) as count_rank,
dense_rank() OVER(ORDER BY COUNT(gs.rank) DESC ) as ranking
from artists a
join songs s  on a.artist_id = s.artist_id
join global_song_rank gs on gs.song_id = s.song_id
where rank <=10
GROUP BY a.artist_name
)

SELECT artist_name,ranking as artist_rank
FROM cte 
where ranking <=5

