-- sql case study 2
create database case_study;

-- viewing tables 
select * from customer;

select * from orders;

-- adding new column for order_date

alter table orders
add column orders_date date;

-- disable set sql safe updates to update value

set sql_safe_updates = 0;

-- inserting data into new orders_date column

update orders
set orders_date = str_to_date(order_date,"%d-%m-%Y");

-- dropping old order_date column

alter table orders
drop column order_date;

/*From the items_ordered table, select a list of all items purchased for customerid 10449.
Display the customerid, item, and price for this customer.*/

select c.customerid,item,price
from customer c inner join orders o
using (customerid)
where customerid = "10449";

-- Select all columns from the items_ordered table for whoever purchased a Tent.

select * from orders
where item = "tent";

/* Select the customerid, order_date, and item values from the items_ordered table for any
items in the item column that start with the letter "S".*/

select customerid,orders_date,item
from orders
where item like "S%";

/*Select the distinct items in the items_ordered table. In other words, display a listing of each
of the unique items from the items_ordered table.*/

select distinct item 
from orders;

/*Select the maximum price of any item ordered in the items_ordered table. Hint: Select the
maximum price only.*/

select max(price)
from orders
group by item;

-- if you want to see the item also

select item,price from orders
where price in (select max(price)from orders);

/*Select the average price of all of the items ordered that were purchased 
in the month of Dec.*/

select avg(price)
from orders
where monthname(orders_date)="december";

-- What are the total number of rows in the items_ordered table?

select count(*)
from orders;

/*For all of the tents that were ordered in the items_ordered table, 
what is the price of the lowest
tent? Hint: Your query should return the price only.*/

select min(price)
from orders
where item = "tent";

/*How many people are in each unique state in the customers table? 
Select the state and display
the number of people in each. 
Hint: count is used to count rows in a column, sum works on
numeric data only.*/

select state, count(customerid) as total_people
from customer
group by state;

/*From the items_ordered table, select the item, maximum price,
and minimum price for each
specific item in the table. 
Hint: The items will need to be broken up into separate groups.*/

select item,min(price),max(price)
from orders
group by item;

/*How many orders did each customer make?
Use the items_ordered table. Select the
customerid, number of orders they made,
and the sum of their orders. Click the Group By
answers link below if you have any problems.*/

select c.customerid,count(o.customerid)
from customer c inner join orders o
using (customerid)
group by c.customerid;

/*How many people are in each unique state in the customers table 
that have more than one
person in the state? Select the state and 
display the number of how many people are in each if
it's greater than 1.*/

select state,count(customerid)
from customer
group by state
having count(customerid)>1;

/*From the items_ordered table, select the item, maximum price, 
and minimum price for each
specific item in the table. 
Only display the results if the maximum price for one of the items is
greater than 190.00.*/

select item,max(price),min(price)
from orders
group by item 
having max(price) > 190;

/*How many orders did each customer make? Use the items_ordered table. 
Select the customerid, number of orders they made,
and the sum of their orders if they purchased more
than 1 item.*/

select customerid,count(customerid) total_order,sum(price)
from orders
group by customerid
having count(customerid)>1;

/*Select the lastname, firstname, and city for all customers in the customers table.
Display the results in Ascending Order based on the lastname.*/

select firstname,lastname,city
from customer
order by lastname;

/*From the items_ordered table, select a list of all items purchased for customerid 10449.
Display the customerid, item, and price for this customer.
display the results in Descending order.
*/
select customerid,item,price
from orders
where customerid = 10449
order by price desc;

#Select all columns from the items_ordered table for whoever purchased a Tent.

select * from orders
where item = "tent"
order by quantity desc;

/*Select the customerid, order_date, and 
item values from the items_ordered table for any
items in the item column that start with the letter "S".*/

select customerid,orders_date,item
from orders
having item like "s%"
order by orders_date desc;

/*select the distinct items in the items_ordered table.
In other words, display a listing of each
of the unique items from the items_ordered table.*/

select distinct item
from orders
order by item desc;

/*Select the item and price for all of the items in the items_ordered table 
that the price is greater
than 10.00. Display the results in Ascending order based on the price.*/

select item,price
from orders
where price > 10
order by price asc;

/*Select the customerid, order_date, and 
item from the items_ordered table for all items unless
they are 'Snow Shoes' or if they are 'Ear Muffs'.
Display the rows as long as they are not either of
these two items.*/

select customerid,orders_date,item
from orders
where item not in ("snow shoes","ear muffs");

#Select the item and price of all items that start with the letters 'S', 'P', or 'F'.

select item,price
from orders
where item like "s%" or item like "p%" or item like "f%";

#solved with regular expression

select item,price
from orders
where item regexp "^[spf]";

/*Select the date, item, and price from the items_ordered table for all of 
the rows that have a
price value ranging from 10.00 to 80.00.*/

select item,price,orders_date
from orders
where price between 10 and 80;

/*Select the firstname, city, and state from the customers table 
for all of the rows where the state
value is either: Arizona, Washington, Oklahoma, Colorado, or Hawaii.*/

select firstname,city,state
from customer
where state  in("arizona","washington","oklahoma","colorado","hawaii");

/*Select the item and per unit price for each item in the items_ordered table. 
Hint: Divide the
price by the quantity.*/

select item,price,quantity,(price/quantity) as priceperquantity
from orders;

/*Write a query using a join to determine which items were ordered 
by each of the customers in
the customers table. Select the customerid, firstname, lastname, order_date, 
item, and price for
everything each customer purchased in the items_ordered table.*/

select c.customerid,firstname,lastname,orders_date,item,price
from customer c inner join orders o
using(customerid)
;

#kantar case study

# adding column for composite key in data 1

alter table kantar_data1
add column composite_key text;


set sql_safe_updates = 0;

#renaming column for using convenience

alter table kantar_data1
rename column `order id` to orderid;

alter table kantar_data1
rename column `product id` to productid;

# updating composite key value with the combination of orderid and productid

update kantar_data1
set composite_key = concat(orderid,productid);


# adding column for composite key in data 2

alter table kantar_data2
add column composite_key text;

#renaming column for using convenience

alter table kantar_data2
rename column `order id` to orderid;

alter table kantar_data2
rename column `product id` to productid;

# updating composite key value with the combination of orderid and productid

update kantar_data2
set composite_key = concat(orderid,productid);


/*How to identify the Records (Order ID + Product ID combination) present in data1 
but missing in data2 (Specify the number of records missing in your answer)*/

select d1.composite_key as data1compositekey,d2.composite_key as data2compositekey
from kantar_data1 d1 left join kantar_data2 d2
using (composite_key)
where d2.composite_key is null;

/*How to identify the Records (Order ID + Product ID combination) missing in data1 
but present in data2 (Specify the number of records missing in your answer)*/

select d1.orderid as d1orderid ,d1.productid as d1productid,d2.orderid as d2orderid,d2.productid as d2productid
from kantar_data1 d1 right join kantar_data2 d2
on d1.orderid = d2.orderid and d1.productid = d2.productid
where d1.orderid is null and d1.productid is null; 

#Find the Sum of the total Qty of Records missing in data1 but present in data2

select sum(d2.qty)
from kantar_data1 as d1 right join kantar_data2 as d2
using(orderid,productid)
where d1.orderid is null and d1.productid is null;

/*Find the total number of unique records (Order ID + Product ID combination)
present in the combined dataset of data1 and data2*/

select count(*) from(select orderid,productid
from kantar_data1
union
select orderid,productid
from kantar_data2) as totaluniquerecords;

-- taxi for sure case study

/*Find hour of 'pickup' and 'confirmed_at' time, and make a column of weekday 
as "Sun,Mon, etc"next to pickup_datetime*/									

select * from taxi;

alter table taxi
add column n_pickup_datetime datetime;

update taxi
set n_pickup_datetime = str_to_date(pickup_datetime,"%d-%m-%Y %H:%i");

alter table taxi
add column n_confirm_datetime datetime after confirmed_at;

update taxi
set n_confirm_datetime = str_to_date(confirmed_at,"%d-%m-%Y %H:%i");

select timestampdiff(hour,n_confirm_datetime,n_pickup_datetime) as hour
from taxi ;

alter table  taxi
add column daynames varchar(250) after pickup_datetime;

update taxi
set daynames=  dayname(n_pickup_datetime)
;

/*Make a table with count of bookings with booking_type = p2p catgorized 
by booking mode as 'phone', 'online','app',etc*/									

select booking_mode,count(*)
from taxi
where booking_type = "p2p"
group by booking_mode ;

/*Create columns for pickup and drop ZONES 
(using Localities data containing Zone IDs against each area) and 
fill corresponding values against pick-area and drop_area, using Sheet'Localities'*/	

select pickuparea,zone_id 
from taxi inner join localities
on taxi.PickupArea = localities.Area;

alter table taxi
add column pickupzone int after pickuparea;											

update taxi
inner join  localities on taxi.PickupArea = localities.Area
set pickupzone = zone_id;

alter table taxi
add column dropzone int after droparea;

update taxi
inner join localities on taxi.PickupArea = localities.Area
set dropzone = zone_id;

-- Find top 5 drop zones in terms of  average revenue	

select DropArea,dropzone,avg(fare) 
from taxi
group by DropArea,dropzone;	

 -- Find all unique driver numbers grouped by top 5 pickzones					
	
with cte as (select pickupzone,sum(fare) as totalfare
from taxi
where pickupzone is not null
group by pickupzone
order by totalfare desc
limit 5)

select distinct pickupzone,driver_number
from cte c inner join taxi t 
using(pickupzone)
order by 1,2
;


 
 
 
/*Make a list of top 10 driver by driver numbers in terms of fare 
collected where service_status is done, done-issue	*/	

select Driver_number,sum(fare) 
from taxi
where Driver_number is not null and Service_status in ("done","done-issue")
group by Driver_number
order by sum(fare) desc
limit 10;	

/*Make a hourwise table of bookings for week between Nov01-Nov-07 and 
highlight the hours with more than average no.of bookings day wise*/

 alter table taxi
 add column n_time time;
 
update taxi
set n_time = substring_index(n_pickup_datetime," ",-1) ;

select * from taxi;

alter table taxi
add column n_date date;
 
update taxi
set n_date = substring_index(n_pickup_datetime," ",1) ;


select n_date,ifnull(n_time,"total"),count(*)
from taxi
where n_date between "2013-11-01" and "2013-11-07"
group by n_date,n_time with rollup
order by n_date,n_time;

-- digital marketing case study

-- creating product table

create table products(
product_id serial primary key,
product_name varchar(250),
product_category varchar(250),
product_price numeric(10,2)
);

INSERT INTO products (product_name, product_category, product_price)
VALUES ('Product A', 'Category 1', 19.99),
('Product B', 'Category 2', 29.99),
('Product C', 'Category 1', 39.99),
('Product D', 'Category 3', 49.99),
('Product E', 'Category 2', 59.99);

select * from products;


-- cteating inventory table

create table inventory(
product_id int,
inventory_date date,
inventory_level int
);

INSERT INTO inventory (product_id, inventory_date, inventory_level)
VALUES (1, '2022-01-01', 100),
       (2, '2022-01-01', 200),
       (3, '2022-01-01', 150),
       (4, '2022-01-01', 75),
       (5, '2022-01-01', 250),
       (1, '2022-01-02', 80),
       (2, '2022-01-02', 180),
       (3, '2022-01-02', 100),
       (4, '2022-01-02', 60),
       (5, '2022-01-02', 220),
       (1, '2022-01-03', 50),
       (2, '2022-01-03', 150),
       (3, '2022-01-03', 75),
       (4, '2022-01-03', 80),
       (5, '2022-01-03', 200);
       
select * from inventory;

/*Question 1. What are the top 5 products with the highest inventory levels on 
the most recent inventory date?*/

select p.product_name,p.product_id,i.inventory_date,i.inventory_level
from inventory i inner join products p
on i.product_id = p.product_id
where inventory_date in(select max(inventory_date) from inventory)
order by inventory_level desc
limit 5;

/*Question 2. What is the total inventory level for each product category 
on the most recent inventory date?*/

select product_category,sum(inventory_level) as total_inventory_level
from products p inner join inventory i
on p.product_id = i.product_id
where inventory_date = (select max(inventory_date) from inventory)
group by product_category;

/*Question 3. What is the average inventory level for each product category 
for the month of January 2022*/

select product_category,avg(inventory_level) as avg_inventory_level,monthname(inventory_date)
from products p inner join inventory i 
on p.product_id = i.product_id
where monthname(inventory_date) = "january"
group by product_category;

/*Question 4. Which products had a decrease in inventory level from the previous inventory 
date to the current inventory date?*/

with cte as(
select p.product_name,inventory_date,inventory_level,lead(inventory_level) 
over(partition by product_name order by inventory_date) as next_inventory_value
from products p inner join inventory i 
on p.product_id = i.product_id)

select product_name,inventory_date, next_inventory_value - inventory_level as difference
from cte
where next_inventory_value is not null and next_inventory_value - inventory_level < 0;

-- with self join

select i.product_id, p.product_name,i.inventory_level-i2.inventory_level as difference
from inventory i inner join inventory i2
on i.product_id = i2.product_id and i.inventory_date = i2.inventory_date+interval 1 day
inner join products p on p.product_id = i.product_id
where i.inventory_level<i2.inventory_level
order by product_name;


select * from inventory order by product_id;

/**Question 5. What is the overall trend in inventory levels for each product category 
over the month of January 2022?*/

select p.product_category,inventory_date,avg(inventory_level)
from products p inner join inventory i 
on p.product_id = i.product_id
where monthname(inventory_date) = "january"
group by product_category,inventory_date
order by product_category,inventory_date;

-- dannies dinner case study

-- creating sales tables

CREATE TABLE sales (
  customer_id VARCHAR(100),
  order_date DATE,
  product_id INTEGER
);

-- inserting values

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);

-- create table menu

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);
  
  CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
-- What is the total amount each customer spent at the restaurant?

select customer_id,sum(price)
from sales s inner join menu m
on s.product_id = m.product_id
group by customer_id;

-- How many days has each customer visited the restaurant?

select customer_id,count(distinct order_date)
from sales
group by customer_id;

-- What was the first item from the menu purchased by each customer?

select customer_id,product_name,order_date
from sales s inner join menu m
on s.product_id = m.product_id
group by customer_id
having order_date = min(order_date);

/*What is the most purchased item on the menu and
how many times was it purchased by all customers?*/

select product_name,count(*)
from sales s inner join menu m
on s.product_id = m.product_id
group by product_name
order by count(*) desc
limit 1;

-- Which item was the most popular for each customer?

with cte as(
select customer_id,product_name,
rank() over(partition by customer_id order by count(*) desc) as rnk
from sales s inner join menu m
on s.product_id = m.product_id
group by customer_id,product_name)

select customer_id,product_name
from cte
where rnk = 1
;

-- Which item was purchased first by the customer after they became a member?

with cte as (
select s.customer_id,p.product_name,order_date,
rank() over(partition by customer_id order by order_date) as order_day
from  sales s inner join  members m 
on s.customer_id = m.customer_id
inner join products p on p.product_id = s.product_id
where order_date > m.join_date
)

select * from cte
where order_day = 1;

-- Which item was purchased just before the customer became a member?

with cte as(
select  s.customer_id,product_name,order_date,
rank() over(partition by customer_id order by order_date desc) as rnk
from sales s inner join members m 
on s.customer_id = m.customer_id inner join products p on p.product_id = s.product_id
where order_date <  m.join_date
group by s.customer_id,order_date
order by order_date )

select customer_id,product_name
from cte 
where rnk = 1;

-- What is the total items and amount spent for each member before they became a member?

select s.customer_id,count(*),sum(price)
from sales s inner join menu m 
on s.product_id = m.product_id inner join members ms
on ms.customer_id = s.customer_id
where ms.join_date > s.order_date
group by s.customer_id;

/*If each $1 spent equates to 10 points and 
sushi has a 2x points multiplier - how many points would each customer have?*/

with cte as(
select customer_id,product_name,sum(price),
case when product_name = "sushi"
then sum(price)*2
else sum(price)*1
end as points
from  sales s inner join menu m 
on s.product_id = m.product_id
group by customer_id,product_name)

select customer_id,sum(points) as total_points
from cte
group by customer_id
;

/*In the first week after a customer joins the program (including their join date) 
they earn 2x points on all items, not just sushi - how many points do customer A and B 
have at the end of January?*/
create view p1 as(
select s.customer_id,sum(price) * 2 as points
from  sales s inner join menu m 
on s.product_id = m.product_id inner join members ms
on ms.customer_id = s.customer_id
where  order_date between ms.join_date and ms.join_date+interval 6 day
group by s.customer_id);


create view p2 as(
with cte as(select s.customer_id,product_name,sum(price),
case when product_name = "sushi"
then sum(price) * 2
else
sum(price)*1
end as points
from sales s inner join menu m 
on s.product_id = m.product_id
inner join members ms
on ms.customer_id = s.customer_id
where order_date > ms.join_date and 
order_date not between ms.join_date and ms.join_date+ interval 6 day  
and monthname(order_date) ="january"
group by s.customer_id,product_name
)

select customer_id,sum(points) as points
from cte
group by customer_id);

with cte as(
select customer_id,points
from p1
union
select customer_id,points
from p2)
select customer_id,sum(points)
from cte
group by customer_id
;

-- Join All The Things

select s.customer_id,s.order_date,m.product_name,m.price,
	case
		when s.customer_id in(select customer_id from members )  and 
        s.order_date >(select join_date from members where customer_id = s.customer_id)
        then "Y"
        else 
        "N" 
	end as "member"
from sales s inner join menu m 
on s.product_id = m.product_id;

/*Danny also requires further information about the ranking of customer products, 
but he purposely does 
not need the ranking for non-member purchases so he expects null ranking values for the records 
when customers are not yet part of the loyalty program.*/

create temporary table temp_table as(
select s.customer_id,s.order_date,m.product_name,m.price,
	case
		when s.customer_id in(select customer_id from members )  and 
        s.order_date >=(select join_date from members where customer_id = s.customer_id)
        then "Y"
        else 
        "N" 
	end as "member"
from sales s inner join menu m 
on s.product_id = m.product_id);

select customer_id,order_date,product_name,price,member,
		case 
			when member = "n" 
            then null
            else
            dense_rank() over(partition by customer_id,member order by order_date )
		end  as ranking
from temp_table
;


