--BAI 1
SELECT 
EXTRACT (YEAR FROM transaction_date) AS year,
product_id,
spend as curr_year_spend,
lag(spend) over
(partition by product_id order by EXTRACT (YEAR FROM transaction_date) asc)
as prev_year_spend,
round (((spend-lag(spend) over
(partition by product_id order by EXTRACT (YEAR FROM transaction_date) asc))
/lag(spend) over
(partition by product_id order by EXTRACT (YEAR FROM transaction_date) asc))
*100.0,2) as yoy_rate
FROM user_transactions
--
BAI 2
WITH CARD_LAUNCH AS (SELECT 
card_name,
issued_amount,
MAKE_DATE(issue_year, issue_month, 1) AS issue_date,
MIN(MAKE_DATE(issue_year, issue_month, 1)) OVER (
PARTITION BY card_name) AS launch_date
FROM monthly_cards_issued)
SELECT card_name, 
issued_amount
FROM CARD_LAUNCH
WHERE issue_date=launch_date
ORDER BY issued_amount DESC
--BAI 3
WITH RANK AS (SELECT user_id,spend,
transaction_date,
RANK () over (PARTITION BY user_id ORDER BY transaction_date) as rank
FROM transactions)
SELECT user_id,spend,
transaction_date
FROM RANK 
WHERE RANK=3
--BAI 4
WITH latest_transactions AS (
SELECT 
transaction_date, 
user_id, 
product_id, 
RANK() OVER (PARTITION BY user_id 
ORDER BY transaction_date DESC) AS transaction_rank 
FROM user_transactions) 
  
SELECT 
transaction_date, 
user_id,
COUNT(product_id) AS purchase_count
FROM latest_transactions_cte
WHERE transaction_rank = 1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date
--BAI 5
SELECT    
user_id,    
tweet_date,   
ROUND(AVG(tweet_count) OVER (
PARTITION BY user_id     
ORDER BY tweet_date     
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
,2) AS rolling_avg_3d
FROM tweets
--BAI 6
WITH Repeated_payments AS (SELECT
a.transaction_id,
a.merchant_id,
a.credit_card_id,
a.amount,
a.transaction_timestamp,
b.transaction_id AS repeated_transaction_id
FROM transactions as a
JOIN transactions as b
ON a.merchant_id = b.merchant_id
AND a.credit_card_id = b.credit_card_id
AND a.amount = b.amount
AND a.transaction_id < b.transaction_id
AND b.transaction_timestamp BETWEEN a.transaction_timestamp 
AND a.transaction_timestamp + INTERVAL '10 MINUTE')

SELECT
COUNT(DISTINCT repeated_transaction_id) AS payment_count
FROM Repeated_payments

--BAI 7
WITH rank_spending  as(SELECT 
category, 
product, 
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category 
ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

SELECT
category, 
product, 
total_spend 
from rank_spending 
WHERE ranking <= 2 
ORDER BY category, ranking
--BAI 8
WITH top_10 AS (
SELECT 
a.artist_name,
DENSE_RANK() OVER (ORDER BY COUNT(b.song_id) DESC) AS artist_rank
FROM artists as a
JOIN songs as b
ON a.artist_id = b.artist_id
JOIN global_song_rank as c
ON b.song_id = c.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name)

SELECT artist_name, artist_rank
FROM top_10
WHERE artist_rank <= 5
