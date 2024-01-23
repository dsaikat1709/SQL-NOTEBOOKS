-- List the managers along with the count of employees they manage.

select e2.manager_id ,e1.firstname,e1.lastname,count(e1.employeeid)
from emp e1 inner join emp e2
on e1.employeeid = e2.manager_id
group by manager_id;

-- Find the names of employees who directly report to a specific manager (e.g., Manager with ID 1).

select e1.firstname,e1.lastname,e2.manager_id
from emp e1 inner join emp e2
on e2.manager_id = e1.employeeid
where e2.manager_id= 1;

-- Retrieve the list of all customers and their corresponding orders (if any).

select c.customerid,customername,product,quantity
from customer c left join orders o using(customerid);


-- List the customer names and their total order quantities.

select customername,sum(quantity)
from customer c inner join orders o
using(customerid)
group by customername;

-- Find the customer names who have not placed any orders.

select customername from customer c 
right join orders o using(customerid)
where c.customerid is null;

-- Display the order details (OrderID, OrderDate, Product, Quantity) along with the customer name for each order.

select customername,orderid,orderdate,product,quantity
from orders o inner join customer c using(customerid);

-- Retrieve the total number of orders placed by each customer.

select customerid,sum(orderid)
from customer c inner join orders o 
using(customerid)
group by customerid;

-- List the customers who have placed orders in both the USA and Canada.

select customerid
from customer c inner join orders  o
using (customerid)
where country in("usa","canada")
group by customername
having count(countryname)=2;

-- Find the customer names who have placed orders in the USA but not in the UK.

select customername
from customer c inner join orders o
using (customerid)
where country = "usa" and c.customerid not in(select c.customerid 
from customer c inner join orders o using (customerid)
where country = "uk");

-- Display the order details (OrderID, OrderDate, Product, Quantity) for orders placed by "Customer A."

select customername,orderid,orderdate,product,quantity
from customer c inner join orders o 
using(customerid)
where customername = "customer a ";

-- List the customer names who have placed more than 10 orders in total.

select customername,count(orderid)
from customer c inner join orders o 
using(customerid)
group by customername
having count(orderid) > 10
;

-- Find the customer names who have placed orders for "Product 1."

select customername,productname
from customer c inner join orders o
on c.customerid = o.customerid
where productname = "product1";

-- List the names of employees along with their department names.

select empname,departmentname
from employee e inner join department d
using(departmentid);

-- Find the highest salary among all employees.

select empname,max(salary)
from employee inner join salary
using (employeeid)
group by empname;

-- Display the department names and the average salary of employees in each department.

select departmentname,avg(salary)
from department d inner join employee e 
on d.departmentid = e.departmentid
inner join salary s  on e.employeeid = s.employeeid
group by departmentname;

-- List the employees who have the same salary as their manager. (Hint: Self-join on the "Employees" table)

select e1.empname as employee,e2.empname as manager,salary
from employee e1 inner join employee e2
on e1.managerid = e2.employeeid
where e1.salary = e2.salary;

-- Find the department with the highest average salary.

select departmentname,avg(salary)
from emp e inner join department d 
on e.departmentid = d.departmentid
inner join salary s on e.employeeid=s.employeeid
group by departmentname
order by avg(salary) desc
limit 1;

-- Retrieve the names of employees who do not belong to any department.

select employeename,departmentname
from employee left join department
using (departmentid)
where departmentname is null;

-- Display the department names along with the number of employees in each department.

select departmentname,count(employeeid)
from employee e inner join department d 
using (employeeid)
group by departmentname;

-- List the employees who have a salary greater than the average salary of all employees.

select emplyoeename,salary
from employee inner join salary
using(employeeid)
group by employeename,salary
having salary > avg(salary);

-- Find the names of employees who work in the same department as "John Doe."

select employeename,departmentname
from employee inner join department
using(departmentid)
where departmentid  in (select departmentid 
from  employee 
where employeename = "john doe");

-- Display the department names with the lowest and highest average salary.

select departmentnames
from department d inner join employee  e
using (departmentid)
inner join salary s using(employeeid)
group by departmentname
having avg(salary) in 
(select avg(salary)
from salary
order by avg (salary) desc
limit 1) or 
salary in 
(select avg(salary)
from salary
 order by avg(salary)asc
 limit 1);

#Students learning Phy and Chem both

select p.studentid,p.studentname
from physics p inner join chemistry c 
on p.studentid = c.student.id;

#List of students learning Biology but not physics

select  b.studentid,b.studentname
from biology b left join physics p
using (studentid)
where p.studentid is null;

/*List of all the students from Phy table. In the same
list, show the students who are also present in the
Bio table.*/

select p.studentid,b.studentname
from physics p left join biology b
using (studentid);

/*Create a master list/dataset of students learning
biology, physics, and chemistry*/

select studentname,studentid
from biology
union
select studentname,studentid
from physics
union 
select studentname,studentid
from chemistry
order by id;

/*List the students who are common members of the
Chemistry Club and Biology Club but not of
the Physics Club*/

select c.studentname,b.studentid,p.studentid,p.studentname
from chemistry c inner join biology b 
on c.studentid = b.studentid
left join physics p
on b.studentid = p.studentid
where p.studentid is null;

#Show the number of students gender-wise in biology table

select sex,count(studentid)
from biology
group by sex
order by 1 asc;

/*Show the number of students in each class.
Show only those classes with at least two students*/

select class,count(studentid)
from bio
group by class
having count(studentid) >2;

use assignment;

/*create a list of customers who have deposited money and 
still have highccbalance*/

select d.custid,depositamt,ccbalance
from deposit_amount d inner join highcreditcard c 
on d.custid = c.custid;

#create a list of customers who have either a high cc balance or depositamt or both

select d.custid,depositamt,"" as ccbalance
from deposit_amount d left join highcreditcard l 
on d.custid = l.custid
union 
select l.custid,"",ccbalance
from deposit_amount d right join highcreditcard l
on d.custid = l.custid;

/*create a list of customers who have high credit card balance but 
not deposited any money*/

select h.custid,ccbalance,depositamt
from highcreditcard h left join deposit_amount d 
on h.custid = d.custid
where d.custid is null;
