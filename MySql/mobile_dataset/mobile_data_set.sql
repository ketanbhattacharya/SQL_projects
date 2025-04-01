create database MobileSets;
use MobileSets;
CREATE TABLE mobiles (
    company_name VARCHAR(255),
    model_name VARCHAR(255),
    mobile_weight VARCHAR(50),
    ram VARCHAR(50),
    front_camera VARCHAR(50),
    back_camera VARCHAR(50),
    processor VARCHAR(255),
    battery_capacity VARCHAR(50),
    screen_size VARCHAR(50),
    launched_price_pakistan VARCHAR(50),
    launched_price_india VARCHAR(50),
    launched_price_china VARCHAR(50),
    launched_price_usa VARCHAR(50),
    launched_price_dubai VARCHAR(50),
    launched_year INT
);
alter table mobiles
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

-- q1 Find the how many types of mobile present
SELECT COUNT(DISTINCT model_name) AS total_mobile_types  
FROM mobiles;

-- q2 show the all companies names
select distinct(company_name) from mobiles;

-- Q3 find the mobiles which has 6gb or more than 4gb
with c as(SELECT model_name,ram,company_name
FROM mobiles  
WHERE CAST(REPLACE(ram, 'GB', '') AS UNSIGNED) >= 6)
select ram,count(*) as total_count
from c
group by ram;


-- Q4 find the mobiles which has weight more than avg mobile weight

select model_name,mobile_weight from mobiles
where mobile_weight >
(select round(avg(mobile_weight),2) as avg_weight
from mobiles);
-- Q5 find how many mobiles has more than avg weight
with c as (select round(avg(mobile_weight),2) as avg_weight
from mobiles)
SELECT count(*) as weight_more_than_avg
FROM mobiles  
WHERE mobile_weight > (SELECT avg_weight FROM c);

-- Q6 find the phones with triple camera in back
select model_name,(back_camera)
from mobiles
where back_camera REGEXP '(\\+.*?){2}';

-- Q7 find the how many sub variant Samsung has (s series)
select company_name,model_name
from mobiles
where company_name = 'Samsung' and model_name regexp '[s]';

select company_name,count(*) as samsung_S_series
from mobiles
where company_name = 'Samsung' and model_name regexp '[s]';

SELECT COUNT(DISTINCT model_name) AS samsung_sub_variants  
FROM mobiles  
WHERE company_name = 'Samsung';

-- Q8 Find how many mobile each company has
select company_name,count(*) as 'number of models'
from mobiles
group by company_name;

-- Q9 find which company has lowest and highest number of mobiles
with c as(select company_name,count(*) as number_of_mod
from mobiles
group by company_name)
(select * from c
order by number_of_mod desc 
limit 1)

UNION ALL
(
select * from c
order by number_of_mod asc
limit 1
);

-- Q10 find the number of mobile has snapdragon processor
select count(*) as no_of_mobile
from mobiles
where processor regexp 'Snap*';

-- Q11 find the mobiles with battery capacity more than 10000mAh
select model_name,battery_capacity
from
mobiles
where CAST(REPLACE(REPLACE(battery_capacity, ' mAh ',''),",","" )AS unsigned) >=10000;
-- Q12 FIND THE MOBILES WITH SCREEN SIZE MORE THAN THE AVG SCREEN SIZE

SELECT model_name, screen_size
FROM mobiles
WHERE CAST(REPLACE(screen_size, '"', '') AS DECIMAL(5,2)) > 
      (SELECT ROUND(AVG(CAST(REPLACE(screen_size, '"', '') AS DECIMAL(5,2))), 2) FROM mobiles);

-- Q13 find the latest released mobiles
select model_name,launched_year from 
mobiles
where launched_year=2025;

-- Q14 find the price of 
-- iPhone 16 Pro Max 128GB
-- iPhone 16 Pro Max 256GB
-- iPhone 16 Pro Max 512GB
select model_name,launched_price_india from
mobiles
where model_name 
in ('iPhone 16 Pro Max 128GB',
'iPhone 16 Pro Max 256GB',
'iPhone 16 Pro Max 512GB');


-- Average Launched Price per Country
SELECT 'India' AS Country, 
       CONCAT(ROUND(AVG(CAST(REPLACE(SUBSTRING(launched_price_india, 5), ',', '') AS UNSIGNED)), 2), " INR") AS launched_price_avg
FROM mobiles
UNION ALL
SELECT 'Pakistan' AS Country, 
       CONCAT(ROUND(AVG(CAST(REPLACE(SUBSTRING(launched_price_pakistan, 5), ',', '') AS UNSIGNED)), 2), " PKR") AS launched_price_avg
FROM mobiles
UNION ALL
SELECT 'China' AS Country, 
       CONCAT(ROUND(AVG(CAST(REPLACE(SUBSTRING(launched_price_china, 5), ',', '') AS UNSIGNED)), 2), " CNY") AS launched_price_avg
FROM mobiles
UNION ALL
SELECT 'USA' AS Country, 
       CONCAT(ROUND(AVG(CAST(REPLACE(SUBSTRING(launched_price_usa, 5), ',', '') AS UNSIGNED)), 2), " USD") AS launched_price_avg
FROM mobiles
UNION ALL
SELECT 'Dubai' AS Country, 
       CONCAT(ROUND(AVG(CAST(REPLACE(SUBSTRING(launched_price_dubai, 5), ',', '') AS UNSIGNED)), 2), " AED") AS launched_price_avg
FROM mobiles;


-- Average RAM and Battery Capacity by Brand
select company_name,round(avg(left(ram,locate("",ram))),0) as avg_ram,
ROUND(AVG(CAST(REPLACE(REPLACE(battery_capacity, ' mAh ',''),",","" )AS unsigned)),0) AS numeric_battery_capacity
from mobiles
group by company_name
order by avg_ram desc;

-- Average Screen Size by Year
select launched_year,round(avg(screen_size),2) as "Avg Screen size"
from mobiles
group by launched_year
order by launched_year;

-- Number of Models Launched Per Year
select launched_year,count(model_name) as number_of_models
from mobiles
group by launched_year
order by launched_year asc;

-- Most Popular Brands by Number of Models Launched
select company_name,count(model_name) as number_of_models
from mobiles
group by company_name;

-- Most Expensive and Cheapest Phones by Brand
SELECT company_name, 
       MIN(CAST(REPLACE(SUBSTRING_INDEX(launched_price_india, ' ', -1), ',', '') AS UNSIGNED)) AS min_price,
       MAX(CAST(REPLACE(SUBSTRING_INDEX(launched_price_india, ' ', -1), ',', '') AS UNSIGNED)) AS max_price
FROM mobiles
GROUP BY company_name
ORDER BY max_price DESC;

-- show the special Edition models
select model_name as special_edition,ram,processor
from mobiles
where model_name regexp 'Edition';
