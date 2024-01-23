create database business_analysis;
use business_analysis;
create table Salesman(
salesman_id int,
name varchar(30),
city varchar(15),
commission double(3,2)
);
drop table salesman;
insert into salesman(salesman_id, name , city ,commission ) values 
       ( 5001,'James Hoog','New York',0.15),
        (5002,'Nail Knite','Paris',0.13),
        (5005,'Pit Alex','London',0.11),
        (5006,'Mc Lyon','Paris',0.14),
        (5007,'Paul Adam','Rome',0.13),
        (5003,'Lauson Hen','San Jose',0.12);
describe salesman;
create table customer(
customer_id int,
cust_name varchar(20),
city varchar(20),
grade int,
salesman_id int
);

insert into customer(customer_id, cust_name,city,grade,salesman_id )
values
        (3002  ,'Nick Rimando',  'New York',      100   ,     5001),
        
        (3007,'Brad Davis','New York', 200,5001),
        (3005,'Graham Zusi','California',200,5002),
        (3008,'Julian Green','London',300,5002),
        (3004,'Fabian Johnson','Paris',  300,5006),
		(3009,'Geoff Cameron','Berlin',100,5003),
		(3003,'Jozy Altidor','Moscow',200,5007),
        (3001,'Brad Guzan','London',null,5005);
  select * from 
  customer;      
#1) to find the salespeople and customers who live in the same city. 
-- Return customer name, salesperson name and salesperson city.
select c.cust_name as customer_name, s.name as salesman_name, s.city as mutual_city
from customer c join salesman s on c.salesman_id=s.salesman_id
where c.city=s.city;

SELECT customer.cust_name, salesman.name, salesman.city
-- Specifies the tables from which to retrieve the data (in this case, 'salesman' and 'customer').
FROM salesman, customer
-- Specifies the condition for joining the 'salesman' and 'customer' tables based on the equality of the 'city' columns.
WHERE salesman.city = customer.city;

#2)to locate all the customers and the salesperson who works for them.
-- Return customer name, and salesperson name.
select customer.cust_name,salesman.name from salesman,customer
where salesman.salesman_id=customer.salesman_id;

create table orders(
ord_no      int,
purch_amt   float,
ord_date    date,
customer_id  int,
salesman_id  int);

insert into orders(ord_no,purch_amt,ord_date,customer_id,salesman_id) values
(70001 ,150.5, '2012-10-05',3005,5002),
(70009,270.65,'2012-09-10',3001,5005),
(70002,65.26,'2012-10-05',3002,5001),
(70004,110.5,'2012-08-17',3009, 5003),
(70007       ,948.5   ,    '2012-09-10' , 3005  ,       5002),
(70005      , 2400.6   ,   '2012-07-27' , 3007      ,   5001),
(70008  ,     5760   ,     '2012-09-10' , 3002    ,     5001),
(70010 ,      1983.43,     '2012-10-10' , 3004  ,       5006),
(70003  ,     2480.4   ,   '2012-10-10' , 3009   ,      5003),
(70012  ,     250.45,      '2012-06-27',  3008   ,      5002),
(70011   ,    75.29  ,     '2012-08-17' , 3003    ,     5007),
(70013    ,   3045.6  ,    '2012-04-25'  ,3002     ,    5001);
select * from orders;

#3) to find those salespeople who generated orders for their customers but are not located in the same city.
-- Return ord_no, cust_name, customer_id (orders table), salesman_id (orders table).
select o.ord_no,c.cust_name,o.customer_id,o.salesman_id
from orders o, customer c, salesman s 
where c.city != s.city and o.salesman_id=s.salesman_id and o.customer_id=c.customer_id;

# 4) to locate the orders made by customers. Return order number, customer name.  
select o.ord_no,c.cust_name from orders o,customer c
where o.customer_id=c.customer_id;

# 5) to find those customers where each customer has a grade and is served by a salesperson 
-- who belongs to a city.
-- Return cust_name as "Customer", grade as "Grade".
 
 -- salesman(salesman_id, name , city ,commission 
-- customer(customer_id, cust_name,city,grade,salesman_id
-- orders(ord_no,purch_amt,ord_date,customer_id,salesman_id
select c.cust_name as Customer, c.grade as Grade from customer c, salesman s, orders o where c.grade is not null and s.city is not null 
and c.customer_id=o.customer_id and s.salesman_id=o.salesman_id;

#6) to find those customers who are served by a salesperson and the salesperson earns commission in the range of 12% to 14% (Begin and end values are included.).
-- Return cust_name AS "Customer", city AS "City".
select  c.cust_name AS Customer, c.city AS City , s.name as salesman, s.commission from customer c, salesman s
where c.salesman_id=s.salesman_id 
and s.commission between 0.12 and 0.14;

# 7) to find all orders executed by the salesperson and ordered by the customer whose grade is greater than or equal to 200. 
-- Compute purch_amt*commission as “Commission”. 
-- Return customer name, commission as “Commission%” and Commission.

-- salesman(salesman_id, name , city ,commission 
-- customer(customer_id, cust_name,city,grade,salesman_id
-- orders(ord_no,purch_amt,ord_date,customer_id,salesman_id

# op-- ord_no	cust_name	Commission%	Commission
select o. ord_no, c.cust_name, s.commission as 'commission%' , s.commission*o.purch_amt from orders o, salesman s, customer c
where o.salesman_id=s.salesman_id and c.salesman_id=s.salesman_id and o.customer_id=c.customer_id
and c.grade>=200;

# 8) to find those customers who placed orders on October 5, 2012.
-- Return customer_id, cust_name, city, grade, salesman_id, ord_no, purch_amt, ord_date, customer_id and salesman_id.
-- OP customer_id	cust_name	city		grade	salesman_id	ord_no	purch_amt	ord_date	customer_id	salesman_id
select c.customer_id, c.cust_name, c.city, c.grade, s.salesman_id,s.name as salesman, o.ord_no, o.purch_amt, o.ord_date
from orders o, salesman s, customer c
where o.salesman_id =s.salesman_id and c.salesman_id=s.salesman_id and o.customer_id=c.customer_id
and o.ord_date='2012-10-5';
-- salesman(salesman_id, name , city ,commission 
-- customer(customer_id, cust_name,city,grade,salesman_id
-- orders(ord_no,purch_amt,ord_date,customer_id,salesman_id

#9) to find the salesperson and customer who reside in the same city. Return Salesman, cust_name and city.
select s.name, c.cust_name, c.city from salesman s join customer c on s.city=c.city;

# 10) to find those orders where the order amount exists between 500 and 2000. Return ord_no, purch_amt, cust_name, city.
select o.ord_no, o.purch_amt, c.cust_name, c.city from customer c right join orders o 
on o.customer_id=c.customer_id where o.purch_amt between 500 and 2000;

#11) to find the salesperson(s) and the customer(s) he represents. Return Customer Name, city, Salesman, commission.
 select c.cust_name as 'Customer Name', c.city, s.name as salesman, s.commission 
 from customer c right join salesman s on s.salesman_id=c.salesman_id;
 
#12) to find salespeople who received commissions of more than 12 percent from the company. Return Customer Name, customer city, Salesman, commission.
select c.cust_name,c.city, s.name as salesman,s.commission from salesman s left join customer c on s.salesman_id=c.salesman_id
where s.commission>0.12;

-- salesman(salesman_id, name , city ,commission 
-- customer(customer_id, cust_name,city,grade,salesman_id
-- orders(ord_no,purch_amt,ord_date,customer_id,salesman_id

#13) to locate those salespeople who do not live in the same city where their customers live and have received a commission of more than 12% from the company. 
-- Return Customer Name, customer city, Salesman, salesman city, commission.
select s.name as salesman,c.cust_name as customer, s.city, s.commission  from salesman s join customer c on s.salesman_id=c.salesman_id
where s.city<> c.city and s.commission>0.12;

#14) to find the details of an order. Return ord_no, ord_date, purch_amt, Customer Name, grade, Salesman, commission.
select o.ord_no, o.ord_date, o.purch_amt, c.cust_name as 'Customer Name', c.grade,s.name as "Salesman", s.commission from
orders o inner join customer c on o.customer_id=c.customer_id inner join salesman s on c.salesman_id=s.salesman_id;

#15) to join the tables salesman, customer and orders so that the same column of each table appears once and only the relational rows are returned.
select * from orders o natural join salesman s natural join customer c ;

# 16) to display the customer name, customer city, grade, salesman, salesman city. The results should be sorted by ascending customer_id.
select c.cust_name,c.city,c.grade,s.name as salesman , s.city from customer c left join salesman s on c.salesman_id=s.salesman_id order by c.customer_id;

# 17)to find those customers with a grade less than 300. Return cust_name, customer city, grade, Salesman, salesmancity. 
-- The result should be ordered by ascending customer_id. 
select c.cust_name,c.city,c.grade,s.name as salesman, s.city as salesman_city from customer c left join salesman s on c.salesman_id=s.salesman_id 
where c.grade<300
order by c.customer_id;

# 18) to make a report with customer name, city, order number, order date, and order amount 
-- in ascending order according to the order date to determine whether any of the existing customers have placed an order or not.
select c.cust_name, c.city,o.ord_no,o.ord_date,o.purch_amt from customer c left join orders o on c.customer_id=o.customer_id
order by o.ord_date;

# 19) to generate a report with customer name, city, order number, order date, order amount, salesperson name, and 
-- commission to determine if any of the existing customers have not placed orders or if they have placed orders through their salesman or by themselves.
select c.cust_name as cutomer,c.city,o.ord_no,o.ord_date,o.purch_amt,s.name as salesman,s.commission from customer c left join orders o on
c.customer_id=o.customer_id left join salesman s on s.salesman_id=c.salesman_id;

# 20) to generate a list in ascending order of salespersons who work either for one or more customers or have not yet joined any of the customers.
select s.name , s.salesman_id, c.cust_name from salesman s left join customer c on s.salesman_id=c.salesman_id ;

# 21) to make a list for the salesmen who either work for one or more customers or yet to join any of the customer. The customer may have placed,
# either one or more orders on or above order amount 2000 and must have a grade, or he may not have placed any order to the associated supplier.
select s.salesman_id,s.name as salesman,c.cust_name,c.customer_id from salesman s left join customer c on s. salesman_id= c.salesman_id 
left join orders o on o.customer_id=c.customer_id
where o.ord_no is not null or o.purch_amt>=2000 and grade is not null;

#22.For those customers from the existing list who put one or more orders, or which orders have been placed by the customer who is not on the list,
# create a report containing the customer name, city, order number, order date, and purchase amount
select c.cust_name as customer,c.city,o.ord_no,o.ord_date,o.purch_amt from customer c left  join orders o on c.customer_id=o.customer_id;

#23. to generate a report with the customer name, city, order no. order date, purchase amount for only those customers on the list who must have a grade
# and placed one or more orders or which order(s) have been placed by the customer who neither is on the list nor has a grade.
select c.cust_name,c.city,o.ord_date,o.purch_amt from customer c join orders o on c.customer_id=o.customer_id where  c.grade is not null and o.ord_no>=1
union
select c.cust_name,c.city,o.ord_date,o.purch_amt from customer c join orders o on c.customer_id=o.customer_id where  c.grade is null ;

# 24. to combine each row of the salesman table with each row of the customer table.
select * from salesman s cross join customer c;

#25. to create a Cartesian product between salesperson and customer, 
# i.e. each salesperson will appear for all customers and vice versa for that salesperson who belongs to that city.
select * from salesman s cross join customer c where s.city=c.city;

#26) to create a Cartesian product between salesperson and customer, i.e. each salesperson will appear for every customer and vice versa for those salesmen who belong to a city and customers who require a grade
select * from salesman s cross join customer c where s.city is not null and c.grade is not null;

# 27- to make a Cartesian product between salesman and customer i.e. each salesman will appear for all customers and vice versa for 
#those salesmen who must belong to a city which is not the same as his customer and the customers should have their own grade.
select * from salesman s cross join customer c where s.city!=c.city and c.grade is not null;

# 28) to find all the orders issued by the salesman 'Paul Adam'. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
select o.ord_no,o.purch_amt,o.ord_date,o.customer_id,o.salesman_id from orders o where salesman_id= (select salesman_id from salesman where 
name='Paul Adam');

#29) to find all orders generated by London-based salespeople. Return ord_no, purch_amt, ord_date, customer_id, salesman_id.
select o.ord_no,o.purch_amt,o.ord_date,o.customer_id,o.salesman_id from orders o where salesman_id= (select salesman_id from salesman where 
city='London');

#30) to find all orders generated by the salespeople who may work for customers whose id is 3007. Return ord_no, purch_amt, ord_date, customer_id, salesman_id.
select o.ord_no,o.purch_amt,o.ord_date,o.customer_id,o.salesman_id from orders o where salesman_id= (select salesman_id from customer where customer_id=3007);

#31) to find the order values greater than the average order value of 10th October 2012. Return ord_no, purch_amt, ord_date, customer_id, salesman_id.
select  o.ord_no,o.purch_amt,o.ord_date,o.customer_id,o.salesman_id from orders o where purch_amt> (select avg(purch_amt) from orders where ord_date='2012-10-10');

#32) to find all the orders generated in New York city. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
select  o.ord_no,o.purch_amt,o.ord_date,o.customer_id,o.salesman_id from orders o where customer_id in (select customer_id from customer where city='New York');

#33) to display all the customers whose ID is 2001 below the salesperson ID of Mc Lyon.
select * from customer where customer_id= ( select salesman_id-2001 from salesman where name='Mc Lyon');

#34) to count the number of customers with grades above the average in New York City. Return grade and count.  
select grade,count(customer_id) from customer where grade> (select avg(grade) from customer where city='New York') group by grade;

# 35) to find those salespeople who earned the maximum commission. Return ord_no, purch_amt, ord_date, and salesman_id.
select o.ord_no,o.purch_amt,o.ord_date,o.salesman_id from orders o where salesman_id in (select salesman_id from salesman where commission= 
(select max(commission) from salesman));

# 36) to find the customers who placed orders on 17th August 2012. Return ord_no, purch_amt, ord_date, customer_id, salesman_id and cust_name.
select o.ord_no,o.purch_amt,o.ord_date,o.salesman_id,c.cust_name,c.customer_id from orders o right join customer c on o.customer_id=c.customer_id where ord_date='2012-08-17';

#37) to find salespeople who had more than one customer. Return salesman_id and name.
select salesman_id,name from salesman where salesman_id in (select salesman_id from (select salesman_id,count(customer_id) from customer group by salesman_id having count(customer_id)>1)dt);

#38) to find those orders, which are higher than the average amount of the orders. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
select o.ord_no,o.purch_amt,o.ord_date,o.salesman_id,o.customer_id from orders o 
where purch_amt> ( select avg(purch_amt) from orders a where a.customer_id=o.customer_id);

# 39) to find those orders that are equal or higher than the average amount of the orders. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
select o.ord_no,o.purch_amt,o.ord_date,o.salesman_id,o.customer_id from orders o 
where purch_amt>= ( select avg(purch_amt) from orders a where a.customer_id=o.customer_id);

#40)  to find the sums of the amounts from the orders table, 
# grouped by date, and eliminate all dates where the sum was not at least 1000.00 above the maximum order amount for that date.
select ord_date,sum(purch_amt) from orders a group by ord_date having sum(purch_amt)> (select 1000+max(purch_amt) from orders b where a.ord_date=b.ord_date );

#41) to extract all data from the customer table if and only if one or more of the customers in the customer table are located in London. 
select * from customer where exists (select * from customer where city='London');

#42) to find salespeople who deal with multiple customers. Return salesman_id, name, city and commission.
select salesman_id, name, city, commission from salesman where salesman_id in (select salesman_id from (select salesman_id,count(customer_id) from customer 
group by salesman_id having 
count(customer_id)>1)dt);

#43) to find salespeople who deal with a single customer. Return salesman_id, name, city and commission.
select salesman_id, name, city, commission from salesman where salesman_id in (select salesman_id from (select salesman_id,count(customer_id) from customer 
group by salesman_id having 
count(customer_id)=1)dt);

#44) to find the salespeople who deal with the customers with more than one order. Return salesman_id, name, city and commission.
select salesman_id, name, city, commission from salesman where salesman_id in (select salesman_id from (select salesman_id,count(ord_no) from orders
group by salesman_id having 
count(ord_no)>1)dt);

# 45) to find the salespeople who deal with those customers who live in the same city. Return salesman_id, name, city and commission.
select salesman_id, name, s.city, commission from salesman s where s.city in ( select c.city from customer c where s.city=c.city);
-- or
select distinct s.salesman_id, s.name, s.city, s.commission from salesman s,customer c where s.city=c.city;

# 46) to find salespeople whose place of residence matches any city where customers live.
select salesman_id, name, s.city, commission from salesman s where s.city =any ( select c.city from customer c );

# 47) to find all those salespeople whose names appear alphabetically lower than the customer’s name. Return salesman_id, name, city, commission.
select * from salesman s where salesman_id in ( select salesman_id from ( select salesman_id, cust_name from customer c where s.name<(c.cust_name))dt);
-- or
SELECT * FROM salesman a WHERE EXISTS (SELECT * FROM CUSTOMER b WHERE  a.name  < b.cust_name);

# 48) to find all those customers with a higher grade than all the customers alphabetically below the city of New York.
-- Return customer_id, cust_name, city, grade, salesman_id.


# 49) to find all those orders whose order amount exceeds at least one of the orders placed on September 10th 2012.
-- Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
 SELECT * FROM orders WHERE purch_amt >any (SELECT purch_amt FROM orders WHERE ord_date='2012-09-10');

# 50) to find orders where the order amount is less than the order amount of a customer residing in London City.
-- Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT * FROM orders WHERE purch_amt < (SELECT MAX (purch_amt) FROM orders a, customer b WHERE  a.customer_id=b.customer_id AND b.city='London');

# 51) to find those orders where every order amount is less than the maximum order amount of a customer who lives in London City.
-- Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT * FROM orders WHERE purch_amt  < (SELECT MAX (purch_amt) FROM orders a, customer b WHERE  a.customer_id=b.customer_id AND b.city='London');


# 52)  to find those customers whose grades are higher than those living in New York City. Return customer_id, cust_name, city, grade and salesman_id.
SELECT * FROM customer WHERE grade > all (SELECT grade FROM customer WHERE city='New York');

# 53) to calculate the total order amount generated by a salesperson. Salespersons should be from the cities where the customers reside.
-- Return salesperson name, city and total order amount.
-- salesman(salesman_id, name , city ,commission 
-- customer(customer_id, cust_name,city,grade,salesman_id
-- orders(ord_no,purch_amt,ord_date,customer_id,salesman_id
 select s.salesman_id,sum(o.purch_amt) from salesman s,orders o
 where s.salesman_id=o.salesman_id and s.city in (select distinct city from customer)  group by s.salesman_id order by s.salesman_id ;

# 54) to find those customers whose grades are not the same as those who live in London City. Return customer_id, cust_name, city, grade and salesman_id.

select customer_id, cust_name, city, grade, salesman_id from customer where grade != all (select grade from customer where city='london' and grade != null);

# 55) to find those customers whose grades are different from those living in Paris. Return customer_id, cust_name, city, grade and salesman_id.

select customer_id, cust_name, city, grade, salesman_id from customer where grade != all (select grade from customer where city='paris');

# 56) to find all those customers who have different grades than any customer who lives in Dallas City. Return customer_id, cust_name,city, grade and salesman_id.

select customer_id, cust_name, city, grade, salesman_id from customer where not grade = any (select grade from customer where city='Dallas city')





























































































































































