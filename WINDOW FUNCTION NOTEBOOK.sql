/*Ranking:
Rank employees based on their salaries in descending order.*/

select empid,salary,dense_rank() over()
from employee
order by salary desc;

/*Partitioned Ranking:
Within each department, rank employees based on their salaries in descending order.*/

with cte as(
select d.departmentname,e.empid,e.employeename,s.salary
from department d inner join employee e on d.departmentid = e.departmentid
inner join salary s on e.employeeid = s.employeeid
order by departmentid)

select empid,employeename,departmentname,salary,
dense_rank() over(partition by department order by salary desc)
from  cte
order by departmentid,salary;

/*Running Total:
Calculate the running total of sales from the 'Sales' table, ordered by date.*/

select date,amount,sum(amount) over(order by date) running_total
from sales;

/*Top N per Group:
Retrieve the top 3 highest-selling products in each category from the 'Products' table.*/

create view tn as(
select c.category,c.categoryid,s.productid,s.productname,count(*) totalsales
from category c inner join sales s on c.categoryid = s.categoryid
group by c.categoryid,s.productid
order by categoryid);

with cte as(
select *,dense_rank() over(partition by categoryid  order by totalsales desc) as ranking
from tn
order by categoryid,ranking)

select * from cte 
where ranking <=3
;

/*Moving Average:
Calculate the 3-day moving average of stock prices from the 'StockPrices' table.*/

set sql_safe_updates = 0;

alter table moving_avg 
add column 	n_date date;

update moving_avg
set n_date = str_to_date(date,"%d-%m-%Y");


select date,amount,monthname(n_date),avg(amount) 
over(partition by monthname(n_date) order by n_date rows between 2 preceding and current row ) m_avg
from moving_avg
order by monthname(n_date);


select * from moving_avg;

/*Percentile Calculation:
Determine the 90th percentile of employee salaries.*/

set @totalnumber = (select count(*) from salary);

with cte as (
select employeeid,employeename,row_number() over(order by salary ) as ranking
from salary
order by salary 
)

select employeename,empid,salary
from salary
where ranking >= round(@totalnumber*90/100)
limit 1;

/*Lag and Lead:

Find the time difference (in days) between the current order date and 
the next order date in the 'Orders' table.*/

with cte as(
select  custid,orderdate,lead(orderdate) over(partition by custid order by orderdate) nextorderdate
from orders
group by custid)

select *,timestampdiff(day,orderdate,nextorderdate) gapebetweenorders
from cte;

/*Dense Rank with Ties:
Rank employees based on their sales performance month wise, considering ties and 
without leaving gaps between ranks.*/

select salesmanid,salesmanname,sum(sales),monthname(date),
dense_rank() over(partition by monthname(date) order by sum(sales) desc)
from sales
group by salesmanid,monthname(date);

/*Window Aggregation with GROUP BY:
Calculate the average salary and the maximum salary within each department in the 'Employees' table.*/

select departmentname,avg(salary) over(partition by departmentname),
max(salary) over(partition by departmentname)
from employees;

/*Pagination:
Implement pagination by retrieving rows 11 to 20 from the 'Products' table, ordered by product name.*/

with cte as(
select productid,productname,row_number() over(order by productname) ranks
from product)

select * from cte 
where ranks between 11 and 20;

-- with limit and offset

select productid,productname
from products
order by productname
limit 10 offset 10;

-- window functions with schooldb

-- running total

select name,class,mtest,sum(mtest) over(partition by class order by mtest desc),
sum(mtest) over(partition by class)
from student2;

-- running percentage

select name,class,mtest,
sum(mtest)over(partition by class order by mtest desc)/sum(mtest) over(partition by class)*100,
sum(mtest) over(partition by class)
from student2;

-- moving average

select name,class,mtest,avg(mtest) over(partition by class order by mtest)
from student2;

-- show data like this
-- Fullname | class| mtest| classavg| highestinclass| lowestinclass

select name,class,mtest, avg(mtest) over(partition by class),
max(mtest) over(partition by class),min(mtest) over(partition by class)
from student2;

-- how much student done as compare to the highest scorer in their class

select name,class,mtest,first_value(mtest) over(partition by class order by mtest desc) as highestscore,
first_value(mtest) over(partition by class order by mtest desc) - mtest
from student2;

-- how much student done as compare to the highest scorer in their class
-- last_value requires a specific range thats why we use unbound here  
 
select name,class,mtest,
last_value(mtest) over(partition by class order by mtest desc rows between unbounded preceding and unbounded following) as lowestscore,

last_value(mtest) over(partition by class order by mtest desc rows between unbounded preceding and unbounded following) - mtest
from student2;

-- check whether two students sitting togetheir had cheated in exam

select id,class,name,mtest,
lag(mtest) over(partition by class order by id) as previous_student_number,
lead(mtest) over(partition by class order by id) as next_student_number,
if(abs(mtest-lag(mtest) over(partition by class order by id)) 
between 0 and 3 
or
abs(mtest-lead(mtest) over(partition by class order by id))between 0 and 3
,"cheated","not cheated")
as status
from student2;

-- just testing 2 preceding as end of the range

select name,class,mtest,
avg(mtest)
over(partition by class order by mtest desc rows between unbounded preceding and 2 preceding)
from student2;

/*Practice queries:
1. Show the students and their maths score if they
are among the top 20% of the students in terms of Maths score.*/

set @twentypercent = (select ceil(count(*)*0.2)
 from student2);

select * from (
select id,name,class,mtest,rank() over(order by mtest desc) rnk
from student2
order by mtest desc) as rnktable
where  rnk <= @twentypercent;

-- alternate way

set @row_counter = 0;

select * from(
select id,name,mtest,@row_counter:=@row_counter+1,rank() over(order by mtest desc) rnk
from student2
order by mtest desc) as rnk_table
 where rnk <= ceil(@row_counter*0.2);

-- find the bottom 10% of girls in mtest

set @bottom_ten=0;

select * from(
select id,name,sex,mtest,rank() over(order by mtest) as rnk,@bottom_ten := @bottom_ten+1
from student2
where sex = "F"
order by mtest
) as rnk_table
where rnk<= ceil(@bottom_ten*.1);



-- top 10% student of total number

set @total_number =(select count(*) from student2);

with cte as(
select id,name,row_number() over(order by id) as rnk
from student2)

select * from cte
where rnk <= round(@total_number*10/100);

-- 2. Divide the students into 3 buckets in terms of their Maths and Physics scores.

select id,fullname,mtest,ptest,ntile(3) over(order by mtest+ptest desc)
from student;

/*3. Create a view and find the 3rd lowest rank holder
in the student table.*/

with cte as(
select id,fullname,MTest,PTest,dense_rank() over( order by mtest+ptest ) as ranks
from student)

select *
from cte
where ranks = 3;