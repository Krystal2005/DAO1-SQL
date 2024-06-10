--bai 1
SELECT 
SUM (case 
when device_type='laptop' then 1 else 0
end) AS laptop_views, 
SUM (case 
when device_type in ('tablet', 'phone') then 1 else 0
end) AS mobile_views 
FROM viewership;
--bai 2
select x,y,z,
case 
when x+y>z and x+z>y and y+z>x then 'Yes'
else 'No'
end as 'triangle'
from triangle
--BAI 3
SELECT 
ROUND ((SUM (CASE 
WHEN call_category='n/a'
or call_category is NULL
or call_category=''
then 1 else 0
END) * 100.0)/count (*),1) AS uncategorised_call_pct
FROM callers
--bai 4
SELECT
name 
from customer 
where referee_id=1 or
referee_id is null 
--bai 5
select survived, 
sum (case 
when pclass=1 then 1 ELSE 0 
END) AS First_class, 
sum(case 
when pclass=2 then 1 ELSE 0 
END) AS second_class, 
sum (case 
when pclass=3 then 1 ELSE 0 
END) AS third_class
from titanic
group by survived
