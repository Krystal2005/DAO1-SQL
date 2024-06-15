--bai 1
SELECT B.CONTINENT,
FLOOR (AVG (A.POPULATION) )
FROM CITY AS A
INNER JOIN  COUNTRY AS B
ON A.CountryCode=B.Code
GROUP BY B.CONTINENT
order by B.CONTINENT desc
--BAI 2
SELECT 
ROUND(COUNT(b.email_id)::DECIMAL/COUNT(DISTINCT a.email_id),2) 
AS activation_rate
FROM emails as a
LEFT JOIN texts as b
ON a.email_id = b.email_id
AND b.signup_action = 'Confirmed'
--BAI 3
SELECT 
age_bucket, 
ROUND(100.0*SUM(time_spent) FILTER (WHERE activity_type = 'send') / SUM (time_spent), 2) AS send_perc, 
ROUND(100.0*SUM(time_spent) FILTER (WHERE activity_type = 'open') / SUM (time_spent), 2) AS open_perc
FROM activities
INNER JOIN age_breakdown
USING (user_id)
WHERE activity_type IN ('send', 'open') 
GROUP BY age_bucket
--BAI 4
SELECT A.customer_id
FROM customer_contracts as a
left join products as b
on a.product_id=b.product_id
where product_name like 'Azure%' 
group by A.customer_id
HAVING COUNT(DISTINCT product_category)=3
--BAI 5
SELECT a.employee_id,
a.name AS name,
COUNT(b.employee_id) AS reports_count,
ROUND(AVG(b.age)) AS average_age
FROM
Employees a
JOIN
Employees b ON a.employee_id = b.reports_to
GROUP BY a.employee_id, a.name
ORDER BY a.employee_id
--BAI 6
SELECT
a.product_name,
SUM(b.unit) AS unit
FROM
Products as a
JOIN
Orders as b ON a.product_id = b.product_id
WHERE
b.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY a.product_id, a.product_name
HAVING SUM(b.unit) >= 100
--BAI 7
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as b
on a.page_id=b.page_id
where b.liked_date is NULL
order by a.page_id




