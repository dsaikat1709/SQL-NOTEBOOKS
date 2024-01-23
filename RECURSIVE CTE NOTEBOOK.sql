
/*Hierarchy Display:
Given a table 'Categories' with columns 'CategoryID' and 'ParentCategoryID', 
write a recursive CTE to display the hierarchy of categories.*/

with recursive cte as(
select categoryid,parentcategoryid,categoryname,1 as levels
from categories
where parentcategoryid is null
union
select c.CategoryID,c.ParentCategoryID,c.CategoryName,ct.levels+1 as levels
from categories c join cte ct 
on c.ParentCategoryID = ct.CategoryID)

select CategoryID,ParentCategoryID,levels,concat(repeat(" ",levels),categoryname) categoryname
from cte
order by levels;

/*Employee Supervisors:
Use a recursive CTE on the 'Employees' table (columns: 'EmployeeID', 'ManagerID') 
to list each employee along with their chain of supervisors.
Organization Structure:*/

With recursive cte as(
select empid,emp_name,mngid,1 as levels
from r_cte
where empid = 1
union
select r.empid,r.emp_name,r.mngid, c.levels+1 as levels
from cte c join r_cte r on cte.empid = r_cte.mngid)

select * from cte;


/*Create a recursive CTE to represent the organization structure using a table 'Organization' 
with columns 'EmployeeID' and 'SupervisorID'.
File System Structure:*/ 

with recursive cte as(
select supervisorid,employeeid,1 as levels
from org
where supervisorid is null
union
select o.supervisorid,o.employeeid, employeename,levels+1 as levels
from cte c join org o
on c.employeeid = o.employeeid)

select supervisorid,employeeid,concat(repeat(" ",levels),employeename)
from cte;

/*Assume a table 'FileSystem' with columns 'FileID' and 'ParentFileID'. 
Write a recursive CTE to display the hierarchical structure of a file system.
Comment Replies:*/

with cte as(
select fileid,parentfileid,1 as levels
from filesystem
where parentfileid is null
union select  c.fileid,c.parentfileid,levels+1 as levels
from cte  c join filesystem f
on c.fileid = f.parentfileid)

select * from cte;

/*Consider a table 'Comments' with columns 'CommentID' and 'ParentCommentID'. 
Use a recursive CTE to organize comments and replies into a hierarchical structure.
Product Categories:*/

with recursive cte as(
select commentid,parentcommentid,1 as levels
from comments
where parentid is null
union
select ct.commentid,ct.parentcommentid, ct.levels+1 as levels
from cte ct join comments c
on ct.commentid = c.parentid)

select * from cte;


1. **Employee Hierarchy:**
   Consider an 'Employees' table with columns 'EmployeeID' and 'ManagerID.' Write a recursive CTE to display the hierarchy for a specific employee along with their subordinates.

/*2. **Supervisor Chain Length:**
   Using the 'Employees' table, write a query to find the length of the supervisor 
   chain for each employee. Display the employee name along with the length of their supervisor chain.*/
   
  CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    ManagerID INT,
    EmployeeName NVARCHAR(50)
);

INSERT INTO Employees (EmployeeID, ManagerID, EmployeeName)
VALUES
    (1, NULL, 'CEO'),
    (2, 1, 'Manager1'),
    (3, 2, 'Employee1'),
    (4, 2, 'Employee2'),
    (5, 1, 'Manager2'),
    (6, 5, 'Employee3'),
    (7, 5, 'Employee4'),
    (8, 7, 'Employee5');
 
select  * from employees;
   
with recursive cte as(
select  EmployeeID,managerid,employeename,0 as loc
from employees
where ManagerID is null  
union
select e.EmployeeID,e.ManagerID,e.EmployeeName, c.loc + 1 as length_of_chain
from cte c join employees e 
on c.EmployeeID = e.ManagerID)

select * from cte;



/*3. **Subordinate Count:**
   Extend the 'Employees' table example to include a column 'SubordinateCount' 
   in the final output of your recursive CTE. 
   This column should represent the number of subordinates (direct and indirect) each employee has.*/
   
with recursive cte as (
 select employeeid,employeename,managerid , 0 as 'SubordinateCount' 
 from employees
 where  managerid is null
 union
 select e.employeeid,e.employeename,e.managerid, c.subordinatecount + 1 as 'SubordinateCount'
 from cte c join employees e
 where c.employeeid = e.managerid)
 
 select employeeid,employeename,managerid,subordinatecount
 from cte;
 
/*4. **CEO Subordinates:**
   Write a recursive CTE to find all the employees who directly or indirectly report to the CEO. 
   Display the employee names and their positions.*/
   
with recursive cte as( 
 select  employeeid,employeename,managerid,0 as levels
 from employees 
 where managerid is null
 union
 select e.employeeid,e.employeename,e.managerid,c.levels +1 as levels
 from cte c join employees e 
 on c.employeeid = e.managerid)
 
 select employeename,managerid
 from cte 
 where levels = 1;
   
/*5. **Reverse Hierarchy:**
   Modify the recursive CTE to display the hierarchy in reverse order, 
   starting from employees and moving up to their supervisors.*/
   
with  recursive cte as(
   
 select employeeid ,employeename, managerid,0 as levels
 from employees
 where managerid is null
 union
 select e.employeeid,e.employeename,e.managerid,c.levels+1 as levels
 from cte c join employees e
 on e.managerid = c.EmployeeID)
 
 select employeeid,employeename,managerid,levels
 from cte
 order by levels desc;
   
/*6. **Manager with Most Subordinates:**
   Using the 'Employees' table, find the manager who has the most number of subordinates 
   (both direct and indirect). Display the manager's name along with the count of subordinates.*/

with recursive cte as(
select EmployeeID,ManagerID,1 as levels
from employees
where ManagerID is null
union
select  e.EmployeeID,e.ManagerID, c.levels+1 as levels
from cte c join employees e
on c.EmployeeID = e.ManagerID)

select managerid,levels,count(*) 
from cte
group by managerid;


with recursive cte as(
select managerid,1 as levels
from employees
where ManagerID in(select EmployeeID from employees where ManagerID is null)
union
select e.ManagerID,c.levels+1 as levels
from cte c join employees e
on c.ManagerID<e.managerID
)

select * from cte;
select*from employees;








/*7. **Hierarchy with Level Limit:**
   Modify the recursive CTE to display the hierarchy but limit the depth to 
   a specific level. For example, display up to two levels of the hierarchy for each employee.*/

with recursive cte as(
select employeeid,employeename,managerid,0 as levels
from employees
where managerid is null
union
select e.employeeid,e.employeename,e.managerid,c.levels+1 as levels
from cte c join employees e
on c.employeeid = e.managerid
 )

select employeeid,employeename,managerid,levels
from cte
where levels <= 2;

/*8. **Employee Without Supervisors:**
   Write a query to find employees who do not have any supervisors 
   (those with `NULL` in the 'ManagerID' column).*/
   
 with recursive cte as(
select employeeid,employeename,managerid,0 as levels
from employees
where managerid is null
union
select e.employeeid,e.employeename,e.managerid,c.levels+1 as levels
from cte c join employees e
where c.EmployeeID =e.ManagerID )
select employeeid 
from cte
where levels = 0;
  
/*9. **Supervisor with No Subordinates:**
   Find supervisors who do not have any subordinates in the organization. 
   Display their names and positions.*/
   
   CREATE TABLE Emp2 (
    EmployeeID INT PRIMARY KEY,
    ManagerID INT,
    EmployeeName VARCHAR(250),
    Position VARCHAR(250)
);

INSERT INTO Emp2 (EmployeeID, ManagerID, EmployeeName, Position)
VALUES
    (1, 0, 'CEO', 'Chief Executive Officer'),
    (2, 1, 'Manager1', 'Manager'),
    (3, 2, 'Employee1', 'Software Engineer'),
    (4, 2, 'Employee2', 'Data Analyst'),
    (5, 1, 'Manager2', 'Manager'),
    (6, 5, 'Employee3', 'Graphic Designer'),
    (7, 5, 'Employee4', 'Marketing Specialist'),
    (8, 7, 'Employee5', 'Content Writer'),
    (9, 7, 'Supervisor1', 'Marketing Supervisor'),
    (10, 9, 'Subordinate1', 'Marketing Assistant'),
    (11, 9, 'Supervisor2', 'Marketing Supervisor'),
    (12, 11, 'Subordinate2', 'Marketing Assistant');

WITH RECURSIVE SupervisorHierarchy AS (
    SELECT EmployeeID, ManagerID, EmployeeName, Position
    FROM Emp2
    WHERE ManagerID is null

    UNION ALL

    SELECT e.EmployeeID, e.ManagerID, e.EmployeeName, e.Position
    FROM Emp2 e
    JOIN SupervisorHierarchy sh ON e.ManagerID = sh.EmployeeID
)
SELECT *
FROM SupervisorHierarchy
WHERE EmployeeID IN (
    SELECT ManagerID
    FROM Emp2
    WHERE ManagerID IS NOT NULL
    AND ManagerID NOT IN (SELECT DISTINCT EmployeeID FROM Emp2)
);

/*10. **Organization Chart:**
    Using the 'Employees' table, create a visual representation of the organization chart by 
    displaying each employee's name along with their supervisors and subordinates.*/

with recursive cte as(
select employeeid,employeename,managerid,position,0 as levels
from emp2
where ManagerID = 0 
union
select e.EmployeeID,e.EmployeeName,e.ManagerID,c.levels+1 as levels,e.Position
from cte c join emp2 e 
where c.EmployeeID = e.EmployeeID)

select employeename,concat(repeat(" ",levels),position) as positions
from cte;

















Assume a table 'Tasks' with columns 'TaskID' and 'DependentTaskID'. Create a recursive CTE to show the dependency chain of tasks.
Family Tree:

Use a recursive CTE on a 'FamilyMembers' table with columns 'MemberID' and 'ParentMemberID' to display a family tree.
Location Hierarchy:

Given a table 'Locations' with columns 'LocationID' and 'ParentLocationID', design a recursive CTE to represent the hierarchy of locations.
Course Prerequisites:

Assume a table 'Courses' with columns 'CourseID' and 'PrerequisiteID'. Write a recursive CTE to show the prerequisites chain for each course.




