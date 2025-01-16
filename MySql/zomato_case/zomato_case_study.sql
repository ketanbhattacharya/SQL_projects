create	database Zomato;
use Zomato;
create table CountryTable(CountryCode int,	Country varchar(50));
create table Zomato(RestaurantID int,
Res_identify varchar(50),
CountryCode int,
City varchar(50),
Cuisines varchar(50),
Has_Table_booking varchar(5),
Has_Online_delivery varchar(5),
Is_delivering_now varchar(5),
Switch_to_order_menu varchar(5),
Price_range	int,
Votes int,
Average_Cost_for_two int,
Rating decimal(10,2)
);
/*Business Questions: 
1) Help Zomato in identifying the cities with poor Restaurant ratings
2) Mr.roy is looking for a restaurant in kolkata which provides online 
delivery. Help him choose the best restaurant
3) Help Peter in finding the best rated Restraunt for Pizza in New Delhi.
4)Enlist most affordable and highly rated restaurants city wise.
5)Help Zomato in identifying the restaurants with poor offline services
6)Help zomato in identifying those cities which have atleast 3 restaurants with ratings >= 4.9
  In case there are two cities with the same result, sort them in alphabetical order.
7) What are the top 5 countries with most restaurants linked with Zomato?
8) What is the average cost for two across all Zomato listed restaurants? 
9) Group the restaurants basis the average cost for two into: 
Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average. 
Then, find the number of restaurants in each category. 
10) List the two top 5 restaurants with highest rating with maximum votes. 
*/
-- Help Zomato in identifying the cities with poor Restaurant ratings
select avg(rating)
from zomato;

select city,round(Avg(rating),2) as avg_rating
from zomato
group by city
having avg_rating<3.0;

-- 2) Mr.roy is looking for a restaurant in kolkata which provides online delivery. Help him choose the best restaurant
select RestaurantID,city,rating
from zomato
where city = "Kolkata" and Has_online_delivery = 'yes'
order by rating desc
limit 1;

-- 3) Help Peter in finding the best rated Restraunt for Pizza in New Delhi.
select restaurantID,Cuisines,rating
from zomato
where Cuisines="pizza" and City="New Delhi"
order by Rating desc
limit 1;

-- 4)Enlist most affordable and highly rated restaurants city wise.
select avg(price_range)
from zomato;

SELECT city,rating, price_range
FROM zomato
WHERE price_range <= 2
ORDER BY city, rating DESC;

-- 5)Help Zomato in identifying the restaurants with poor offline services
select restaurantID,city,rating
from zomato
where Has_Online_delivery="No" and
rating <3.0;

-- 6)Help zomato in identifying those cities which have atleast 3 restaurants with ratings >= 4.9
SELECT city
FROM zomato
WHERE rating >= 4.9
GROUP BY city
HAVING COUNT(*) >= 3
ORDER BY city;

-- 7) What are the top 5 countries with most restaurants linked with Zomato?

with r as(select c.country,z.Countrycode,z.RestaurantID
from zomato z join countryTable c
on z.countryCode = c.countryCode)
select country,count(*) as 'Total_restaurant' from r
group by country
order by Total_restaurant desc
limit 5;

-- 8) What is the average cost for two across all Zomato listed restaurants? 
select round(Avg(Average_Cost_for_two),2) as Avg_cost_for_two
from zomato;

/*
9) Group the restaurants basis the average cost for two into: 
Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average. 
Then, find the number of restaurants in each category. 
*/
select average_cost_for_two from zomato
order by average_cost_for_two desc;

SELECT
    CASE
        WHEN average_cost_for_two>=500000 and average_cost_for_two<=800000 THEN 'Luxurious Expensive'
        WHEN average_cost_for_two>=400000 and average_cost_for_two<=500000 THEN 'Very Expensive'
        WHEN average_cost_for_two>=100000 and average_cost_for_two<=300000 THEN 'Expensive'
        WHEN average_cost_for_two>=10000 and average_cost_for_two<=90000 THEN 'High'
        WHEN average_cost_for_two>=5000 and average_cost_for_two<=9000 THEN 'Medium High'
        WHEN average_cost_for_two>=1000 and average_cost_for_two<=4000 THEN 'Average'
        else "Mid Average"
    END AS cost_category,
    COUNT(*) AS restaurant_count
FROM zomato
GROUP BY cost_category
ORDER BY restaurant_count DESC;

-- 10) List the two top 5 restaurants with highest rating with maximum votes. 
WITH C AS(SELECT restaurantid,rating,votes
FROM zomato
ORDER BY rating DESC
LIMIT 5)
SELECT * FROM C
order by VOTES DESC
LIMIT 2;




