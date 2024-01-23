 -- 1.List the names of the boys from District HHM if there exists at least one female in HHM.

select fullname,
dcode ,sex
from student s1
where dcode = "HHM" and sex= "m" and  exists(select 1 from student s2 where s1.dcode = s2.DCode
 and sex = "f");

select * from student;

/*2.Fetch all the students from class 1A if there exists a student in class 1A who plays a
musical instrument.*/

select fullname
from student s1
where exists(select 1 from student s2 inner join music m 
on s2.id = m.id
where class = "1A"
and s1.id= s2.id );



/*3. List of students from District HHM if everyone has scored more
than 80*/

select FullName
from student s1
where exists(select 1 from student s2
where MTest > 80 and DCode = "HHM"
and s1.FullName = s2.FullName);

/*4.Find the names that are
unique using exists or not exists.*/

select fullname
from student s1
where exists(select FullName,count(*) from student s2
where s1.FullName = s2.FullName
group by FullName
having count(*) = 1
);

/*5.Find the names that are
repeating using exists or not exists*/

select s1.id,s1.fullname
from student  s1
where  
exists(select s2.id,s2.fullname from student 
s2 where s2.id<>s1.id and s2.FullName = s1.fullname );

/*6. List the students who
have scored lesser among the same named students*/

select s1.id,s1.fullname,s1.mtest
from student s1 
where  exists(select s2.id,s2.fullname from student s2 
where s2.id<>s1.id and s2.fullname = s1.fullname
and s1.mtest < s2.mtest);

-- assign roll number to students

select s1.id,s1.fullname,(select count(*) from student s2
where s1.fullname>s2.fullname and s1.id <> s2.id )+1  as roll_no
from student s1
order by s1.FullName;

/*1. **Employees with Orders:**
   Find the names of employees who have placed orders.*/

select employeeid,employeename
from employee
where exists(select *  from orders where employee.id = orders.id);

/*2. **Unemployed Managers:**
   Retrieve the details of all managers who are not assigned to any department.*/

select managerid
from manager m
where not exists(select d.managerid from department d where m.managerid = d.department);

/*3. **Product with No Sales:**
   Get the list of products that have not been sold yet.*/

select *
from product
where not exists(select 1 from sales where sales.productid = product.productid)
;
/*4. **Customers with No Orders:**
   Find the names of customers who have not placed any orders.*/

select * from  customers
where not exists(select 1 from orders where orders.customerid = customers.customerid);

/*5. **Orders without Products:**
   List the order IDs for orders where no products have been associated.*/

select * from orders
where not exists(select 1 from orderdetails where orderdetails.orderid = orders.orderid );

/*6. **Managers with Subordinates:**
   Retrieve the names of managers who have at least one subordinate.*/

select managerid
from managers
where exists(select 1 from employees e where employee.managerid=manager.managerid );

/*7. **Categories with No Products:**
   Show the names of categories that do not have any products.*/

select id
from categories
where  not exists(select 1 from products where category.id= product.categoryid);

/*8. **Students with No Grades:**
   Display the names of students who have not received any grades.*/

select id
from students
where not exists(select 1 from grade where student.id= grade.id);

/*9. **Projects without Team Members:**
   List the projects that do not have any team members assigned.*/

select id
from projects
where not exists(select 1 from members where project.memberid = member.id);

/*10. **Suppliers with No Products:**
    Find the names of suppliers who do not supply any products.*/

select id
from suppliers
where not exists(select 1 from product where product.supplierid = supplier.id);

/*1. **Employees with Specific Skills:**
   Find the names of employees who possess all of the required skills for 
   a particular project.*/
   
select employeeid,employeename
from employee e 
where exists(
select 1 from skills s
inner join projects p on s.skills = p.skills
where p.projectid = 100 and e.employeeid = s.employeeid);

select employeename
from employees e
where exists(
select 1 from skills s
where s.employeeid = e.employeeid
and exists(
select projectid
from projects p
where p.skills = s.skills and p.projectid = 100));

select e.employeename
from employees e inner join skills s 
on e.EmployeeID = s.EmployeeID 
inner join projects p 
on p.skills = s.skills 
where p.projectid = 100;

/*2. **Products in Stock:**
   List the products that are currently in stock and have never been out of stock.*/

CREATE TABLE products (
    productid INT PRIMARY KEY,
    productname VARCHAR(50)
);

CREATE TABLE stocklist (
    stockid INT PRIMARY KEY,
    productid INT,
    status VARCHAR(20),
    -- Additional columns as needed
    FOREIGN KEY (productid) REFERENCES products(productid)
);

-- Sample data for products
INSERT INTO products (productid, productname) VALUES
(1, 'Product A'),
(2, 'Product B'),
(3, 'Product C');

-- Sample data for stocklist
INSERT INTO stocklist (stockid, productid, status) VALUES
(101, 1, 'in_stock'),
(102, 1, 'in_stock'),
(103, 2, 'out_of_stock'),
(104, 3, 'in_stock'),
(105, 3, 'in_stock');

SELECT p.productname 
FROM products p
WHERE  EXISTS (
    SELECT 1
    FROM stocklist s
    WHERE s.productid = p.productid AND s.status <> 'out_of_stock'
);

/*3. **Managers with Top Performers:**
   Retrieve the names of managers who have at least one subordinate with the highest performance rating.*/

select distinct managername
from managers
where (select 1 from employee
where  employee.managerid = manager.managerid
and employee.rating = (select max(employee.rating)
from employee
where managerid = managers.mangerid)
);

--  employees with highest rating within managers
 
select m.managerid,m.managername
from manager m 
inner join employee e 
on e.managerid = m.managerid
where e.rating = (select max(rating) from employee where e.managerid = m.managerid);

/*4. **Customers with High Purchase Frequency:**
   Identify the customers who have made more purchases than the average purchase frequency.*/

select customerid
from customers c
where exists(
select c.customerid,count(*)
from orders o 
where o.customerid = c.customerid
group by customerid,monthname(order_date)
having count(*) > (
select avg(order_count)
from(
select count(*) order_count from orders o 
where c.customerid = o.customerid
group by customerid,monthname(order_date))));

select customerid,customername
from customer c inner join sales s 
on c.customerid = s.customerid






/*5. **Projects with Unique Team Members:**
   List the projects where all team members have unique skill sets.*/

  
  






/*6. **Categories with Diverse Products:**
   Find the names of categories that have products from at least three different suppliers.*/

select categories
from categories_name
where exists(
select product id
from products
where exists (select distinct supplierid
from supplier where product.productid = supplier.productid
group by productid
having count(distinct supplierid)>=3))and category.productid = product.productid;

/*7. **Employees with Varied Roles:**
   Retrieve the names of employees who have worked in different roles across multiple projects.*/

select employeeid
from employees
where exists(
select projectid
from projects
where projects.EmployeeID= employees.EmployeeID and exists(
select 1 from roles
where roles.projectid = projects.projectid
group by projects.EmployeeID
having count(distinct roles.roles_name) > 1)) ;

-- with join

select e.employeeid,e.employeename
from employees e inner join projects p 
on e.EmployeeID = p.EmployeeID
inner join roles r on r.projectid = p.projectid
group by EmployeeID
having count(distinct roles.roles_name) >1;

/*8. **Orders with Expensive Products:**
   Display the order details for orders that contain at least one product with 
   a price higher than a specified threshold.*/
   
select distinct orderid
from orders
where exists(
select 1 from product
where product.productid = orders.productid
and orders.selling_price > product.mrp);

select o.orderid,p.product_name
from orders o inner join products p 
on o.productid = p.productid
where orders.selling_price > p.mrp;

/*9. **Students with Consistent Grades:**
   Find the names of students who have maintained a consistent grade across all subjects.*/
   
select studentid
from students 
where exists (
select m.studentid
from maths m inner join english e on m.studentid = e.studentid
inner join science s on s.studentid = e.studentid 
where s.studentid = student.studentid and
((m.marks+e.marks+s.marks)/3) > 90);

select studentid
from student s
inner join  maths m on s.studentid = m.studentid 
inner join english e on e.studentid = m.studentid
inner join science sc on s.studentid = e.studentid
where ((m.marks+e.marks+s.marks)/3)>90;

/*10. **Suppliers with a Variety of Products:**
    Identify suppliers who provide products in multiple categories.*/
    
select supplierid
from suppliers s
where exists(
select 1 from products p 
inner join category c 
on p.productid = c.productid
where c.supplierid = s.supplierid
group by s.supplierid
having count(distinct categoryid)>1);








