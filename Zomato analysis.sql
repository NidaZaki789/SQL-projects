create database zomato;
use zomato;
show tables;
select * from orders;
select * from food;
select * from users;
select * from order_details;
select * from restaurants;
#1) Customers who have never ordered.
select u.name  from users u where u.user_id not in (select o.user_id from
orders o where o.user_id=u.user_id);

#2) Average Price per dish
Select f_id,f_name,ifnull(avg(amount),0) as 'Average price of each dish' 
from (select od.f_id, f.f_name, o.order_id ,o.amount from orders o join
order_details od on o.order_id = od.order_id
right join food f on f.f_id=od.f_id)dt
group by 1,2;

#3) Find the top restaurants in terms of the number of orders for a given month. 
With cte as
(select monthname(date) as month,r_id,count(order_id) as no_of_orders_from_each_restaurants from
orders group by 1,2)
select dt.month,cte.r_id from 
( select month , max(no_of_orders_from_each_restaurants) as max_no_of_orders
from cte group by 1)dt join cte on cte.no_of_orders_from_each_restaurants=dt.max_no_of_orders
and cte.month=dt.month;

# 4) Restaurants with monthly sales greater than 500.
select distinct dt.r_id, r.r_name from (select r_id,month(date) , sum(amount) as sm from orders group by 1,2 having sm>500)dt join 
restaurants r on r.r_id=dt.r_id ;

# 5) Show all orders with order details for a perticular customer in a perticular date range.
with cte as
(select user_id,order_id from orders o where date between "2022-05-10" and "2022-07-10" group by 1,2)
select * from orders where (user_id,order_id) in (select user_id, order_id from cte)order by user_id;

# 6) Find restaurants with maximum repeated customers.
with cte as (
select r_id,user_id,count(order_id) cn from orders group by 1,2)
select r_id,max(cn) as max_repeated_users from cte group by r_id order by max_repeated_users desc limit 3 ;

# 7) Month over Month revenue growth of zomato
With cte as
(select month(date) as month, sum(amount)as sm from orders where extract(year from date)=2022
group by month(date))
select (month) , sm-lag(sm,1,0) over 
(order by month asc) as revenue_growth from cte order by revenue_growth desc;

#8) Customr wise favorite food
With cte as
(select o.user_id,od.f_id,count(o.order_id) as count_of_orders from orders o join order_details od group by 1,2)
select * from (select *, row_number() over (partition by user_id order by count_of_orders desc) as ranking from cte)dt
where ranking=1;

# 9) Most loyal customers for each restaurant
With cte as 
(select r_id,user_id,count(order_id) max_order_count
from orders o group by 1,2)
select * from (select *,dense_rank() over (partition by r_id order by max_order_count desc) as ranking from cte)dt
where ranking=1;

# 10) Month over Month revenue growth of each restaurant
With cte as
(select r_id,monthname(date) as monthname,month(date) as month, sum(amount) revenue from orders group by 1,2,3)
select r_id,monthname,revenue, revenue-(lag(revenue,1,0) over 
(partition by r_id order by month asc)) as Revenue_growth from cte;

#11) Restaurant with most number of orders
select r_name, order_count from(
select r.r_name,o.r_id,count(o.order_id) as order_count from
restaurants r join orders o on o.r_id=r.r_id
group by r.r_id,r.r_name)dt order by 2 desc limit 1;

# 12) Which restaurant has done most amount of orders
select distinct r.r_name, ifnull(sum(o.amount) over (partition by o.r_id),0) as most_amount_orders
from restaurants r join orders o on o.r_id=r.r_id
order by 2 desc limit 1;

# 13) Monthwise number of orders
select monthname(date)as monthname , count(distinct order_id) as no_of_orders from orders 
group by monthname(date) order by 1 desc;

# 14) Among all the restaurants , among Veg and Non Veg types of pizzas which is preferred more
With cte as
(select 
sum(case when f_name='Pizza' and type='veg' then 1 else 0 end) 
as veg_count,
sum(case when f_name='Pizza' and type='non veg' then 1 else 0 end)
as non_veg_count
from (select o.r_id,f.f_name,f.f_id,f.type from orders o 
join order_details od 
on o.order_id=od.order_id
join food f
on f.f_id=od.f_id)dt)
select if(veg_count>non_veg_count,'veg_pizza','non_veg_pizza') as preference from cte;

# 15) Foos item that has been ordered the most across all restaurants.
select distinct f_name,count(order_id) total_times_ordered from (select f.f_name,o.order_id , o.r_id from
orders o join order_details od on o.order_id=od.order_id
join food f on f.f_id=od.f_id)dt group by f_name
order by 2 desc;

#16) Food item under eah restaurant whose amount is the highest.
with cte as 
(select distinct r_id,f_id,sum(amount) as sum_food_amount
from ( select f.f_name,f.f_id,o.order_id,o.r_id,o.amount from orders o join order_details od on
o.order_id=od.order_id join food f on f.f_id=od.f_id)dt group by 1,2)
select * from (select r.r_id,cte.f_id, dense_rank() over (partition by r.r_id order by cte.sum_food_amount desc)dr
 from cte join restaurants r on cte.r_id=r.r_id)dd where dr=1 ;

select * from (select r_id,f_id, rank() over (partition by r_id order by sales desc) as rk from 
(select r_id,f_id,sum(amount) as sales from ( select f.f_name,f.f_id,o.order_id,o.r_id,o.amount from orders o join order_details od on
o.order_id=od.order_id join food f on f.f_id=od.f_id)dt group by 1,2)dt1)dt2 where rk=1;

# 17) Find a loyal customer for each restaurants.

select r_name,user_id,order_count from(
select *, dense_rank() over (partition by r_name order by order_count desc) as ranking from  
(select r_name,r_id,user_id,count(order_id) as order_count from
(select u.user_id,u.name,o.r_id,r.r_name,o.order_id from
users u join orders o on u.user_id=o.user_id
join restaurants r on r.r_id=o.r_id)dt
group by 2,1,3) dt2)dt3 where ranking=1 ;










