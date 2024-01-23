# Show the number of customers gender wise

select gender,count(custid)
from cc_profile_data
group by gender;

#show the data marital status wise

select maritalstatus,count(custid)
from cc_profile_data
group by maritalstatus;

#show the marital status for the  gender wise

select maritalstatus,gender,count(*)
from cc_profile_data
group by maritalstatus,gender
order by 2 ;

#show the marital status for the females only

select maritalstatus,count(*)
from cc_profile_data
where gender = "f"
group by maritalstatus;

#alternate way

select maritalstatus,count(*)
from cc_profile_data
group by maritalstatus,gender
having gender = "f";

#show status where count > 300

select maritalstatus,count(*)
from cc_profile_data
group by maritalstatus
having count(*)>300;

-- Show the number of cities in each region.

select region,count(city)
from customers_region
group by region
order by 2;

-- Show the average salary of males and females.

select gender,avg(salary)
from cc_profile_data
group by Gender;

/*3. Show the data in the following format:
Region | Married | Divorced | Never Married
East   | 45      | 66       | 55
West   | 54         | 57       | 33*/

select region,
sum(case when maritalstatus = "married" then 1 else 0 end)as married,
sum(case when maritalstatus = "divorced" then 1 else 0 end) as divorced,
sum(case when maritalstatus = "never married" then 1 else 0 end) as never_married
from cc_profile_data c inner join customers_region r
on c.CustID = r.CustID
group by Region;

/*4. List the total number of females and males with salary > 6000005. */

select gender,count(*)
from cc_profile_data
where salary > 60000
group by gender 
;

/*Show only those cities with at least 400 customers*/

select city,count(*)
from customers_region
group by city 
having count(*) > 400;

-- 7. List the total number Married / Never Married customers.

select maritalstatus,count(*)
from cc_profile_data
group by maritalstatus
having maritalstatus in ("married","never married");

/*8. List the total number of customers by different
fraud levels.*/

select 
 case when salary < 300000 and monthlyccusage = "Medium(<50%)"and age >50
then "highrisk"
when salary < 500000 and monthlyccusage = "Medium(<50%)"and age between 40  and 50 then "moderaterisk"  
else
"lowrisk"
end as fraudlevel,count(*)
from cc_profile_data 
group by fraudlevel
;

/*9.List the avg salary of female customers in different
regions. Hint: Use Avg() function after grouping*/

select region,avg(salary)
from cc_profile_data c inner join customers_region r 
on c.CustID = r.CustID
where gender = "f"
group by Region;

/*Practice Question: Multi-level grouping
10. List the number of customers from each region and city.
Hint: group by region, city*/

select region,city,count(*)
from cc_profile_data c inner join customers_region r
on c.CustID = r.CustID
group by Region,City;

/*Analyze the MonthlyCCUsage of males and females*/

select gender,monthlyccusage,count(*)
from cc_profile_data
group by Gender,MonthlyCCUsage
order by Gender,MonthlyCCUsage;

select * from cc_profile_data;
/*Summarize the data in the following manner:
Gender | Low | Medium | High
F	   | 169 | 346 	  | 376
M	   | 280 | 604    | 725
*/

select gender,
sum(case when monthlyccusage="Low (<25%)" then 1 else 0 end ) as low,
sum(case when monthlyccusage="Medium(<50%)" then 1 else 0 end) as medium,
sum(case when monthlyccusage = "High(<75%)" then 1 else 0 end ) as high
from cc_profile_data
group by gender;

/*List the avg salary of female customers in different 
regions. Show only those regions with at least 530000 as 
avge salary
*/
select region,avg(salary)
from cc_profile_data c inner join customers_region  r
on c.custid = r.custid
where gender ="f"
group by region 
having avg(salary) > 530000;

/*List the total number of female customers in different 
regions. 
Show only those regions that have at least 300 females.*/

select region,count(*) as `total females`
from cc_profile_data c inner join customers_region r
using(custid)
where gender = "f"
group by Region
having count(*) > 300;

-- List the total number of females and males with salary > 600000

select gender,count(*)
from cc_profile_data
where salary > 600000
group by gender
;

 /*show the total number customers in each city of each region. 
Also, show the sub-total region-wise and grand total of all the customers.
*/
select region,ifnull(city,"total"),count(*)
from cc_profile_data c inner join customers_region r
using(custid)
group by region,City with rollup;

/*Show a table with Pass and Fail % for boys and girls*/

select sex,sum(if(mtest>90,1,0))/count(id)*100 as passpercentage,
sum(if(mtest<=90,1,0))/count(id)*100 as failpercentage
from student
group by sex;

-- Certainly! Here are some practice questions related to the `GROUP BY` clause in SQL:

/*1. **Basic GROUP BY**:
   - Given a "Orders" table with columns (OrderID, CustomerID, Product, Quantity, and OrderDate), write a SQL query to find the total quantity of each product ordered.*/

select product,sum(quantity)
from orders
group by products;

/*2. **Grouping and Aggregation**:
   - In a "Sales" table with columns (Product, Category, Price, and QuantitySold), write a query to find the average price and total quantity sold for each product category.*/

select category,avg(price),sum(quantitysold)
from sales
group by category;

/*3. **GROUP BY with HAVING**:
   - Using a "Students" table with columns (StudentID, CourseID, and Grade), find the course(s) with an average grade higher than 90, and list the course name and its average grade.*/

select courseid,avg(grade)
from students
group by courseid
having avg(grade) > 90;

/*4. **Multiple Grouping Columns**:
   - In a "Employees" table with columns (EmployeeID, Department, Salary), find the highest salary in each department.*/

select department,max(salary)
from employees
group by department;


/*5. **GROUP_CONCAT or STRING_AGG**:
   - Using a "Orders" table with columns (OrderID, CustomerID, and Product), concatenate the names of products ordered by each customer, separating them with commas.*/

select  customerid,group_concat(product)
from orders
group by customerid;

/*6. **GROUP BY with DATE Functions**:
   - In a "Transactions" table with columns (TransactionID, CustomerID, Amount, and TransactionDate), group transactions by month and find the total amount for each month.*/

select date_format(transactiondate,"%Y-%m"),sum(amount)
from transactions
group by date_format(transactiondate,"%Y-%m");

/*7. **Subqueries and GROUP BY**:
   - Using a "Sales" table with columns (Product, Category, Price, and QuantitySold), find the products that have a price higher than the average price of their respective categories.*/

select category,product,price
from sales s1 join(
select category,avg(price)
from sales
group by category
) as s2
where s1.category = s2.category
and s1.price > s2.price;


/*8. **COUNT and NULL Values**:
   - In an "Employees" table with columns (EmployeeID, Department, and ManagerID), find the number of employees in each department, including departments with no employees.*/

select d.department,count(e.employeeid)
from (select distinct department
from employees) as d
left join employee e 
using (department)
group by d.department;

/*9. **GROUP BY with Joins**:
   - Given a "Customers" table (CustomerID, CustomerName) and an "Orders" table (OrderID, CustomerID, OrderDate), find the number of orders placed by each customer.*/

select c.customerid,count(orderid)
from customers c inner join orders o
using(customerid)
group by customerid;

/*10. **Advanced GROUP BY**:
    - In a "Products" table with columns (ProductID, Category, Price, and StockQuantity), find the product(s) with the highest price in each category.*/

select productid,category,price
from products 
where (category,price) in (select category,max(price)
from products group by category);

-- List the number of girls of each district.

select dcode,count(*)
from student2
where sex = "f"
group by dcode;

-- List the max. and min. test score of Class 1 students of each district.

select dcode,class,max(mtest),min(mtest)
from student2
where class like "1%"
group by dcode;

/*List the average Math test score of the boys in each class. 
The list should not contain
class with less than 3 boys.*/

select class,avg(mtest)
from student2
where sex = "m"
group by class
having count(*) > 3;

-- List the boys of class 1A, sorted by their names.

select sex,class,name
from  student2
where sex = "m" and class = "1a"
order by name;

-- List the top 10% scoring girls students in Maths

set @max_number = (select max(mtest) from student2);

select name,sex,mtest
from student2
where mtest >= @max_number*0.90 and sex = "f";

-- Print the name of the second highest scorer in Maths Test

select name,mtest
from student2
where mtest < 84
order by 2 desc
limit 1  ;

-- Print the name of the second highest scorer in Maths Test

select name,mtest
from student2
where mtest < (select max(mtest) from student2)
order by 2 desc
limit 1;

-- How many students have unique names?

select count(distinct name)
from student2;

/*How many dumbs and scholar students are there in the table 
(Scholar Criteria – Mtest &gt; 80.
Everyone else is dumb).*/

select sum(case when mtest > 80 then 1 else 0 end) as scholar,
sum(case when mtest < 80 then 1 else 0 end) as dumb
from student2;

-- Find the 4th lowest scorer in Maths and Phy test scores combined.

select fullname,(mtest+ptest)
from student
order by 2
limit 1 offset 3 ;

-- alternate way

with cte as (select fullname,(mtest+ptest) total,row_number() over(order by (mtest+ptest))	as ranks
from student)

select * from cte where ranks = 4
;

/*Assign a roll number to each student after sorting their name alphabetically 
within each class.*/

select name,class,rank() over(partition by  class order by name )
from student2;

/*Categorize the students into 3 categories: 
Scholars - Students who have scored more than 95 in Maths
Average - Students who have scored between 90 and 94 in Maths
Dumbs - Students who have scored less than 90 */

select name,mtest,
case when mtest > 80 then 'scholar'
when mtest > 60 then 'average'
else 
'dumb'
end as status
from student2;

/*Use user defined variable to find the total number of girls in the student table. 
Then, show 10% of total no. of girls.*/

set @totalnumberofgirls = (select count(*) from student2 where sex = "f");

with cte as (select name,sex,row_number() over( order by name) as rnk
from student2 where sex = 'f')

select * from cte
where rnk <= ceil(@totalnumberofgirls*0.10)
;

/*Please refer to the table below as reference and do the questions listed as 1 and 2: 
	FullName	Mtest	Ptest	Higher of Mtest / Ptest 
	Kaushal	93	96	96	
	Prateek	99	92	99	
					
1	Higher of Mtest and Ptest for each student
2	Among the higher values, find the highest scorer */

select fullname,mtest,ptest,
case
when mtest > ptest then mtest else ptest end as `higher marks`
from student;

-- alternate way

select fullname, mtest, ptest, 
 greatest(mtest,ptest) as HigherScore
 from student;

create temporary table temp_table as (select fullname,mtest,ptest,
case
when mtest > ptest then mtest else ptest end as `higher marks`
from student);

select fullname,`higher marks` from temp_table
order by  `higher marks` desc
limit 1;

-- Find average age of all boys students

select dob from student2;

set sql_safe_updates = 0 ;

alter table student2
add column d_o_b date;

update student2
set d_o_b = str_to_date(dob,"%d-%m-%Y");

select avg(floor(datediff(now(),d_o_b)/365 ))as avgage
from student2
where sex = "m";

-- Create a monthly birthday frequency table

select monthname(d_o_b),count(*)
from student2
group by monthname(d_o_b)
order by 1;