select case when salary > 700000 then "rich" 
when salary between 500000 and 699999 then "avg"
else "below avg" end  as statues ,count(*)
from cc_profile_data
group by statues;

select region,gender,sum( case when  maritalstatus = "Married" then 1 else 0 end) as married,
sum(case when maritalstatus = "Divorced" then 1 else 0 end) divorced,
sum(case when maritalstatus = "Never Married" then 1 else 0 end) nevermarried
from cc_profile_data c inner join customers_region cr 
using(custid)
where Region  regexp "^[en]"
group by Region,gender;

-- Certainly! Here are some practice questions on the `CASE WHEN` statement in MySQL:

/*1. **Basic CASE WHEN Statement:**
   Write a query to display a column "Result" that categorizes employees' salaries into "Low," "Medium," or "High" based on the following conditions:
   - If the salary is less than 30000, categorize as "Low."
   - If the salary is between 30000 and 50000 (inclusive), categorize as "Medium."
   - If the salary is greater than 50000, categorize as "High."*/
   
   select name,salary,case when salary < 30000 then "low"
   when salary between 30000 and 50000 then "medium"
   else "high" end
   from salary;

/*2. **CASE WHEN with Aggregate Functions:**
   Write a query to calculate the average salary of all employees and display it as "Below Average" for employees with salaries below the average and "Above Average" for those with salaries above or equal to the average.*/

set @avesalary= (select avg(salary) from salary);

select name,salary,case when salary >= @avgsalary then "above average"
else "below average" end
from salary;

 /**Nested CASE WHEN:**
   Create a query that categorizes products into three categories: "High Demand," "Medium Demand," 
   and "Low Demand." If the product's quantity in stock is greater than 100, it's "High Demand." 
   If the quantity is between 50 and 100 (inclusive), it's "Medium Demand." Otherwise, it's "Low Demand."*/

select product,price,quantity,case when quantity > 100 then "high demand"
when quantity >= 50 and quantity <=100 then "medium demand"
else "low demand" end 
from product;

/*4. **CASE WHEN with Dates:**
   Suppose you have a table containing orders with an "OrderDate" column. 
   Write a query to categorize orders as "Recent" if the order was placed within the last 30 days 
   and "Older" if the order was placed more than 30 days ago.*/

select orderid,case when timestampdiff(day,curdate(),orderdate)>30 then "older order"
else "recent" end
from orders
;

-- using date_sub()

select orderid,case when orderdate >=date_sub(curdate(),interval 30 day ) then "recent"
else "older" end
from orders;

/*5. **CASE WHEN with Multiple Conditions:**
   Write a query to categorize products into four categories based on their price and availability
   : "Expensive and In Stock," "Expensive and Out of Stock," "Affordable and In Stock," 
   and "Affordable and Out of Stock." Use the following criteria:
   - Expensive: Price greater than 100.
   - Affordable: Price 100 or less.
   - In Stock: Quantity in stock is greater than 0.
   - Out of Stock: Quantity in stock is 0.*/
   
select productid,productname,case
when price > 100 and quantity > 0 then "expensive and in stock" 
when price > 100 and quantity < 0 then "expensive and out of stock"
when price <= 100 and quantity > 0 then "affordable and in stock"
when price <= 100 and quantity < 0 then "affordable and out of stock"
else "other"
end
from products;
   
/*6. **CASE WHEN in a JOIN:**
   You have two tables, "employees" and "departments." Write a query to list all employees 
   with their names and departments. Include an additional column that categorizes employees 
   as "Management" if they are part of the Management department and "Staff" otherwise.
   */
   select e.employeeid,e.departmentid,d.departmentname,case 
   when d.depeartmentname = "management" then "management department"
   else "staff"
   end employeecategory
   from employee e inner join department d 
   using(departmentid);

/*7. **CASE WHEN with NULL Values:**
   Write a query to categorize products into two categories: "Available" and "Not Available." 
   Consider a product available if the "AvailabilityDate" is specified and not available if it's NULL.*/

select productid,productname,case 
when availabledate is not null then "available"
else "not available" end  
from products;

/*8. **CASE WHEN for Letter Grades:**
   Create a query that calculates students' final grades based on their scores. 
   Use the following grading scale: A (90-100), B (80-89), C (70-79), D (60-69), and F (0-59).*/
   
   select class,studentname,case 
   when  marks >= 90 then "A"
   when marks between 80 and 89 then "B"
   when marks between 70 and 79 then "C"
   when marks between 60 and 69 then "D"
   else "F" end status 
   from student;

/*9. **CASE WHEN for Age Groups:**
   Write a query that categorizes people into age groups. 
   Use the following categories: "Child" (0-12 years), "Teen" (13-19 years), "Adult" (20-59 years), 
   and "Senior" (60 years and above).
   */
  select name,case 
  when age >= 60 then "senior"
  when age >= 20 then "adult"
  when age >= 13 then "teen"
  else "child"
  end from people;

/*10. **CASE WHEN with Subqueries:**
    Retrieve a list of customers who have made at least one purchase in the last 3 months. 
    Use the `CASE WHEN` statement in a subquery to categorize customers as "Active" or "Inactive" 
    based on their recent purchase activity.*/
    
   select customerid,customername, case
   when customerid in 
   (select customerid from customers where orderdate >= date_sub(curdate(),interval 3 month))
   then "active"
   else "not active" end
   from customers;

