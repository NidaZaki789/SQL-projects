show databases;
create database Ecommerce;
use  Ecommerce;
show tables;
select * from users;
drop table users;
select * from products;
select * from orders;
select * from order_items;
drop table order_items;
drop table orders;

-- Month On Month SALES
SELECT MONTH(created_at) AS month, YEAR(created_at) AS year, SUM(sale_price) AS total_sales_revenue
FROM Order_Items
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

-- YEAR ON YEAR--
# NET REVENUE CHURN--- Revenue loss due to cancellations


CREATE VIEW REVENUE_CHURN AS
SELECT YEAR(created_at) as year, sum(sale_price) as revenue_churn
FROM Order_Items where status='cancelled'
Group By Year(created_at)
order by year;
SELECT * , (revenue_churn-LAG(Revenue_churn,1,0) over (order by year)) AS Net_Revenue_Churn  from REVENUE_CHURN;
# CONSTANTLY INCREASING OVER THE YEARS

-- AVERAGE No. of ORDERS IN A DAY each year--
select year(created_at),round(count(day(created_at))/count(distinct order_id),0) as AVERAGE_No_of_ORDERS_IN_A_DAY  from order_items
group by year(created_at) ;
-- constant

-- ------ INVENTORY ANALYSIS ---------
# Month on month analysis
-- 1) Expected_profit_from_product Each month 
WITH CTE1 AS(
SELECT month(created_at) as month, Year(created_At) as year,sum(cost) as total_inventory_cost , 
sum(product_retail_price) as total_inventory_retail_price 
from inventory_items
group by 1,2 order by 2 desc,1 asc )
SELECT *, (total_inventory_retail_price-total_inventory_cost) as Expected_profit
from CTE1;

select * from inventory_items limit 1;
----- products are categorised into 2 departments inside inventory: men and women
select distinct product_department from inventory_items;

-- Total available inventory in each distribution center
select product_distribution_center_id , count(id) as total_no_of_inventory_items
from inventory_items 
group by product_distribution_center_id
order by 2 desc;






