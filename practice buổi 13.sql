--bai 1
WITH new_job_listings as
(SELECT company_id, title,description,
count(job_id) as job_count
FROM job_listings
group by company_id, title,description)
SELECT 
count(company_id) as duplicate_companies from new_job_listings 
WHERE job_count>1
--bai 2
with appliance as (SELECT category,
product,
sum(spend) as total_spend
FROM product_spend
where category='appliance' and EXTRACT(YEAR FROM transaction_date) = 2022
group by category,product
order by category asc, total_spend desc
limit 2),
electronics as (SELECT category,
product,
sum(spend) as total_spend
FROM product_spend
where category='electronics' and EXTRACT(YEAR FROM transaction_date) = 2022
group by category,product
order by category asc, total_spend desc
limit 2)
select category,	product	,a. total_spend
from appliance as a
UNION
select category,	product	,b.total_spend
from electronics as b
ORDER BY CATEGORY ASC, TOTAL_SPEND DESC
--bai 3
 WITH a AS (select policy_holder_id
FROM callers
GROUP BY policy_holder_id
having count(case_id) >=3)
SELECT count(policy_holder_id)
as policy_holder_count
FROM a
--bai 4
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as b
on a.page_id=b.page_id
where b.liked_date is NULL
order by a.page_id
--bai 5
WITH june_active AS 
(SELECT DISTINCT user_id
FROM user_actions
WHERE event_date >= '2022-06-01' AND event_date < '2022-07-01')
,
july_active AS 
(SELECT DISTINCT user_id
FROM user_actions
WHERE event_date >= '2022-07-01' AND event_date < '2022-08-01')

SELECT
7 AS month,
COUNT(*) AS monthly_active_users
FROM july_active
WHERE
user_id IN (SELECT user_id FROM june_active)

--bai 6
SELECT
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country
ORDER BY
trans_total_amount desc
--bai 7
with firstyearsale as 
(select  product_id, min(year) as first_year from sales
group by product_id)
SELECT a.product_id, b. first_year , a.quantity,  a.price FROM SALES a
join firstyearsale as b
on a.product_id=b.product_id
and a.year= b. first_year
--bai 8
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)
--bai 9
select employee_id from Employees as a
where salary<30000 
and manager_id is not null 
and not exists (select 1 from employees as b 
where b.employee_id=a.manager_id)
--bai 10
WITH new_job_listings as
(SELECT company_id, title,description,
count(job_id) as job_count
FROM job_listings
group by company_id, title,description)
SELECT 
count(company_id) as duplicate_companies from new_job_listings 
WHERE job_count>1
--bai 11
with topuser as(with user_rating_count as (select a.user_id, count(a.rating) as rating_count,
b.name
from MovieRating as a
join Users as b
on a.user_id=b.user_id
group by user_id,name)
select name as results from user_rating_count 
order by name asc, rating_count desc 
limit 1),
topavgmovie as(with average_movie_rating as(select a.movie_id, avg(a.rating) as avgrating, b.title from
MovieRating as a join Movies as b
on a.movie_id=b.movie_id
where DATE_FORMAT(created_at, '%Y-%m')='2020-02'
group by movie_id
order by avg(a.rating) desc)
select title as results from average_movie_rating 
limit 1)
select results
from topuser
union 
select results 
from topavgmovie

--bai 12
with friendcounts as(select requester_id as id,
count(distinct accepter_id) as num
from RequestAccepted
group by requester_id
union 
select accepter_id as id,
count(requester_id) as num 
from RequestAccepted
group by accepter_id),
total_friends as (select id,
(sum(num)) as totalfriends from friendcounts
group by id
order by (sum(num)) desc)

select id, max(totalfriends) as num 
from total_friends
