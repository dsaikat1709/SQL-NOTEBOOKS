-- Certainly! Here are some practice questions related to Common Table Expressions (CTEs) in MySQL:

/*1. **Basic CTE Creation:**
   Create a CTE that displays the names and ages of employees in a table 'Employees'.*/
with cte as(
select names,age
from employee)
select * from cte;

/*2. **Hierarchical Data:**
   Given a table 'Categories' with columns 'CategoryID' and 'ParentCategoryID', 
   create a CTE to display the category hierarchy.*/
 
with cte as(  
select parentcategoryid,categoryid
from categories
group by parentcategoryid,categoryid
order by 1,2)

select parentcategoryid,categoryid
from categories
;  
   
   
/*3. **Recursive CTE:**
   Using a CTE, display the hierarchy of employees in a table 'Employees', 
   where the table has columns 'EmployeeID' and 'ManagerID' denoting the hierarchical relationship.*/
   
with recursive cte as(
select empid,mngid, 0 as levels
from `recursive cte`
where empid = 1

union all
select e.empid,e.mngid,c.levels+1
from  `recursive cte` e join  cte c
on e.empid = c.mngid
)
select * from cte;

WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Employees who don't manage anyone
    SELECT
        EmpID,
        MngID,
        0 AS Level
    FROM `recursive cte`
        
    WHERE
        MngID IS NULL

    UNION ALL

    -- Recursive member: Employees who are managed by someone
    SELECT
        e.EmpID,
        e.MngID,
        eh.Level + 1 AS Level
    FROM
        `recursive cte` e
    JOIN
        EmployeeHierarchy eh ON e.MngID = eh.EmpID
)
SELECT
    EmpID,
    MngID,
    Level
FROM
    EmployeeHierarchy
ORDER BY
    Level, EmpID;





   
   
   
/*4. **Aggregation with CTE:**
   Write a CTE that calculates the total sales for each product in a table 'Sales'.*/

with cte as(
select product,sum(sales)
from sales
group by product
order by product)

select * from cte;

/*5. **Combining CTEs:**
   Create two CTEs: one that lists customers who made purchases and 
   another that lists products sold. Join the CTEs to display the customer 
   and the product they purchased.*/
   
with customer as(
select  customerid,orderid
from customers
where orderid is not null),

products as(select productid,orderid
from product
where orderid is not null)

select c.customerid,p.productid
from customer c inner join products p
on p.orderid = c.orderid;

/*6. **Performance Optimization:**
   How can CTEs be used to improve the performance of a complex query involving multiple subqueries in MySQL?*/

with cte as(
select z.zoneid,z.zonename,s.stationname,c.cityname,w.weathertype,w.temparature
from zone inner join station on z.zoneid = s.zoneid 
inner join
city on s.stationid = c.stationid
inner join  
weather on c.cityid = w.cityid)

select zoneid,zonename,stationname,cityname,weathertype,temparature,
row_number() over(partition by zoneid  order by temparature desc)
from cte;

/*7. **CTE with Filtering:**
   Write a CTE to find the average salary of employees in a table 'Employees', filtering out salaries above a certain threshold.*/

with cte as(
select employeename,salary
from employee)
select avg(salary)
from cte
where salary > 30000;

/*8. **CTE for Data Modification:**
   Is it possible to use CTEs for data modification in MySQL? If yes, provide an example.*/
   
In MySQL, Common Table Expressions (CTEs) are primarily used in SELECT queries, and they don't support direct modification of data like INSERT, UPDATE, or DELETE operations. However, you can use a CTE in conjunction with an UPDATE or DELETE statement to modify data indirectly.

Here's an example that demonstrates how you might use a CTE in combination with an UPDATE statement to modify data:

Let's assume you have a table named 'Employees' with columns 'EmployeeID' and 'Salary', and you want to give a 10% salary increase to all employees whose salary is below a certain threshold.

sql
Copy code
-- Create a CTE to select employees and calculate the new salary
WITH SalaryUpdateCTE AS (
    SELECT
        EmployeeID,
        Salary,
        Salary * 1.1 AS NewSalary
    FROM
        Employees
    WHERE
        Salary < 50000 -- Threshold for salary increase
)

-- Update the 'Employees' table based on the CTE
UPDATE Employees
SET
    Salary = su.NewSalary
FROM
    SalaryUpdateCTE su
WHERE
    Employees.EmployeeID = su.EmployeeID;
In this example:

The CTE named SalaryUpdateCTE selects employees with salaries below a certain threshold (Salary < 50000) and calculates their new salary with a 10% increase (Salary * 1.1).

The UPDATE statement then uses the CTE to update the 'Employees' table based on the conditions specified in the WHERE clause, linking the records from the CTE to the corresponding records in the 'Employees' table using the EmployeeID.

Remember that the specific syntax for UPDATE with JOIN might vary between different database systems. The example provided above follows a syntax that is more typical for databases like SQL Server. In MySQL, you might use a similar concept but with slightly different syntax.

Always refer to the MySQL documentation for the correct syntax and features supported by your specific MySQL version.

9. **Recursive CTE Limitation:**
   What are the limitations of using recursive CTEs in MySQL? How can these limitations be overcome?
   
 As of my last knowledge update in January 2022, MySQL does support recursive Common Table Expressions (CTEs) starting from version 8.0.1. However, there are certain limitations and considerations associated with using recursive CTEs in MySQL:

MySQL Version:

Recursive CTEs are supported in MySQL 8.0.1 and later versions. If you are using an earlier version, recursive CTEs won't be available.
No Cycle Detection:

MySQL's implementation of recursive CTEs does not provide built-in cycle detection. Therefore, you need to be cautious when working with recursive structures to avoid infinite loops. It's the responsibility of the developer to ensure that there are no cycles in the data, or to use additional techniques to detect and handle cycles.
Performance Considerations:

Recursive CTEs can have performance implications, especially for large datasets or deep recursive structures. It's important to test and optimize queries, and in some cases, alternative approaches like using stored procedures might be more efficient.
Limited Depth of Recursion:

By default, MySQL has a maximum recursion depth of 1000. If your recursive structure exceeds this depth, you may encounter errors. This limit can be adjusted by setting the max_recursion system variable.
sql
Copy code
SET max_recursion = 2000;
Note: Adjusting this variable should be done cautiously, considering the available system resources.

Limited Control Over Sorting in Recursive Query:

In MySQL, the sorting in a recursive query is determined by the ORDER BY clause in the recursive SELECT statement. However, MySQL does not allow using expressions in the ORDER BY clause, limiting the control over the sorting of recursive queries.
To overcome these limitations, you may consider the following:

Upgrade MySQL Version:

Ensure that you are using MySQL version 8.0.1 or later to take advantage of the recursive CTE feature.
Cycle Detection:

Implement additional logic in your queries or application code to detect and handle cycles in the data.
Performance Optimization:

Optimize queries, consider indexing, and test performance for your specific use case.
Adjusting Recursion Depth:

If needed, adjust the max_recursion variable to accommodate deeper recursion. Be cautious about the potential impact on system resources.
Alternative Approaches:

Depending on your use case, you might explore alternative approaches, such as using stored procedures or application logic, especially for complex recursive scenarios.
Always refer to the official MySQL documentation for the version you are using for the most up-to-date information and best practices.

/*10. **CTE and Joins:**
    Using a CTE, perform a self-join to find employees who share the same manager in a table 'Employees'.*/

with cte as(
select e1.employeeid as employee1 ,e2.employeeid as employee2,e1.managerid as manager
from employee e1 inner join employee e2
using(managerid)
where e1.employeeid<e2.employeeid)

select employee1,employee2,manager
from cte;








