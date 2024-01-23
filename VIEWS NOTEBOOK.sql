Certainly! Here are some practice questions related to views in MySQL that can help you become more acquainted with their creation, usage, and manipulation:

/*1. **Create a Simple View:** Design a view named 'HighSalaryEmployees' that displays the 
`EmployeeID`, `EmployeeName`, and `Salary` of employees earning more than $50,000 
from an 'Employees' table.*/

create view highsalaryemployee as
(select employeeid,employeename,salary
from employee
where salary > 500000);

/*2. **Joining Tables into a View:** Create a view named 'CustomerOrders' by joining 'Customers' 
and 'Orders' tables, displaying the `CustomerID`, `CustomerName`, `OrderID`, and `OrderDate`.*/

create view customerorder as(
select customerid,customername,orderid,orderdate
from customer  inner join orders 
using(custid)
order by orderdate);

/*3. **Aggregated Data in a View:** Design a view called 'MonthlySalesSummary' that summarizes 
total sales amount for each month using the 'Sales' table with columns `Date` and `Amount`.
*/
create view monthlysalessummary as(
select monthname(date) as month,sum(amount)
from sales
group by monthname(date));

-- alternateway

select date_format(date,"%Y-%m"),sum(amount)
from sales
group by date_format(date,"%Y-%m");

/*4. **Filtered View:** Create a view named 'ActiveProducts' that displays product details 
from a 'Products' table, showing only those products that are currently active 
(based on an 'Active' column).*/

create view activeproducts as(
select productsname,active
from products
where active = "yes");

/*5. **Subquery-based View:** Construct a view 'TopPerformers' by using a subquery to 
showcase employees with performance ratings in the top 10% from an 'EmployeePerformance' table.*/

set @maxnumber = (select max(performancenumber) from employeeperformance);

create view topperformer as(
select employeeid
from employeeperformance where performancenumber in (select employeeid
from employeeperformance
where performancenumber>= @maxnumber*0.90
)
order by performancenumber desc);

/*6. **Hierarchical View:** Design a view named 'EmployeeHierarchy' that represents an employee's 
hierarchical structure (EmployeeID, EmployeeName, ManagerID) from an 'Employees' table, 
showing the relationships between employees and their managers.*/













/*7. **Calculations in a View:** Create a view 'InventoryValue' that computes 
the total value of inventory for each product in a 'Products' table by multiplying 
the 'UnitPrice' with 'Quantity'.*/

create view inventoryvalue as 
select productname,(price*quantity) as totalquantity
from products
group by productname
order by productname;

/*8. **Join and Filter

 View:** Build a view 'HighValueOrders' by joining 'Orders' and 'OrderDetails' tables, 
 showing orders with a total value exceeding $1000, displaying OrderID and TotalValue.*/

select o.orderid,totalvalues
from orders o inner join orderdetails od
on o.orderid = od.orderid
where totalvalues > 1000;

-- if totalvalue does not exists

select o.orderid,(price*quantity) as totalvalue
from orders o inner join orderdetails od
using(orderid)
where totalvalue > 1000;
