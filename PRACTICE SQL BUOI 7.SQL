--BAI 1
SELECT name
FROM students
where marks>75
order by  right(name,3), ID 
--BAI 2
select user_id,
concat (upper (left(name,1)),lower (right (name, length(name)-1))) as name
from Users 
order by user_id
--BAI 3
SELECT manufacturer, 
concat ('$',round (SUM(total_sales)/1000000,0),' ','million') as sales
FROM pharmacy_sales
group by manufacturer
order by SUM(total_sales) desc, manufacturer
--BAI 4
SELECT 
EXTRACT(month from submit_date) as month,
product_id as product,
round(AVG(stars),2) as avg_stars
FROM reviews
group by EXTRACT(month from submit_date), product
order by month, product_id
--BAI 5
SELECT 
sender_id,
count (message_id) as message_count
FROM messages
where EXTRACT(month from sent_date)='08'
and EXTRACT(year from sent_date)='2022'
group by sender_id
order by count(message_id) DESC
limit 2
--BAI 6
SELECT tweet_id 
from tweets
where length(content)>15
--BAI 8
select
count(id)
from employees
where extract(year from joining_date)='2020'
and extract(month from joining_date) between 1 and 7
--BAI 9
select 
FIRST_NAME,
POSITION ('a'in first_name)
from worker
WHERE FIRST_NAME='Amitah'
--BAI 10
select 
substring(title,length(winery)+2,4) as year
from winemag_p2
where  country ='Macedonia'
