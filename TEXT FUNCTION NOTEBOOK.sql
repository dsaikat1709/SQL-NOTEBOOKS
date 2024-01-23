-- SHOW THE FIRST NAME OF THE STUDENT

select fullname,left(fullname,locate(" ",fullname)-1) as firstname
from student;

-- show the first name and if there is no space show the fullname

select fullname,if(locate(" ",fullname,1)>0,left(fullname,locate(" ",fullname)-1),fullname)
from student;

 -- extract the last name using mid
 
select fullname,mid(fullname,locate(" ",fullname)+1,length(fullname))
from student;

-- show the last name using right

select fullname,right(fullname,length(fullname)-locate(" ",fullname))
from student;

set sql_safe_updates = 0;

-- replace all "A" with "a"

update student
set fullname = replace(fullname,"A","a");

select fullname from student;

-- find custoners who have "a" in their name

select name,locate("a",name) from cc_profile_data;

-- show the fullname except the last word

select fullname,left(fullname,locate(" ",fullname)-2)
from student;

-- extract the last two characters

select right(name,2) from cc_profile_data;

-- show the names which have single e
select name
from cc_profile_data
where name like "%e%" and name not like "%e%e%";

 -- List the first initial of all the students coming from YMT

select left(name,1) from student2
where dcode = "YMT";

-- Find the position of second “e” in fullnames

select fullname,locate("e",fullname,locate("e",fullname,1)+1)
from student;

-- find the length of the firstname

select length(left(fullname,locate(" ",fullname,1)-1))
from student;

/*Find the position of first "a"*/

select name,locate("a",name,1)
from student2;

/*Find the position of Second "a"*/

select name,locate("a",name,locate("a",name,1)+1)
from student2;

/*Replace "a" with "#"*/

select name,replace(lower(name),"a","")
from student2;

/*How many "a"s are there in each FullName*/

select name,length(name)-length(replace(name,"a","")) as no_of_a
from student2;

/*Show the fullnames that contain single "e"*/

select name 
from student2
where name like "%e%" and name not like "%e%e%";

/*Using locate()*/

select name 
from student2
where locate("e",name)>0 and locate("e",name,locate("e",name,1)+1) =0;

/*Last name using Right*/

select fullname,right(fullname,length(fullname)-locate(" ",fullname))
from student;

/*How to find the number of spaces in a string
Hint: replace space with Null char (""). 
Find the length of original string - length of replaced string.*/

select fullname,length(fullname)-length(replace(fullname," ",""))
from student;

-- 	find the position the first space

select locate(" ",fullname)
from student;

-- find the postion of the second space

select locate(" ",fullname,locate(" ",fullname,1)+1)
from student;

-- find the position of second "a"

select fullname,locate("a",fullname,locate("a",fullname)+1)
from student;

/*Total characters in name*/

select length(name)
from student2;

/*List the students who contain a single e*/

select name,if(length(name) - 
length(replace(name,"e",""))=1,name,"")
from student2;

-- date 22-12-23

/*1. **Uppercase Conversion:**
   Write a query to retrieve the names of all customers in uppercase from a table named `customers`.*/

select upper(names) from customer;

/*2. **Lowercase Conversion:**
   Create a query to select the product names in lowercase from a table named `products`.*/
   
select lower(product_name) from products;   
   
/*3. **Concatenation:**
   Combine the first name and last name columns to create a full name in a 
   query for the `employees` table.*/
   
  select concat_ws(" ",firstname,lastname) 
  from employees;
   
/*4. **Substring Extraction:**
   Write a query to extract the first three characters from the `description` 
   column in a table named `items`.*/
   
  select substr(description ,1,3)
  from items;
   
/*5. **Character Length:**
   Retrieve the length of each product name in the `products` table using the `LENGTH` function.
*/
select product_name,length(product_name)
from products
group by products_name ;

/*6. **Trimming Whitespace:**
   Create a query to select names from a table named `contacts` 
   after removing leading and trailing spaces.*/
   
select trim(names)  from contacts;

/*7. **String Replacement:**
   Replace all occurrences of 'old_value' with 'new_value' in the `notes` 
   column of a table named `documents`.*/
   
 select replace(notes,"old_values","new_values") 
 from documents;
   
/*8. **String Reversal:**
   Write a query to reverse the characters of the `password` column in the `users` table.*/
   
 select reverse(password)  
 from users;
 
-- date 23-12-2023 
   
/*9. **String Comparison:**
   Compare two email addresses in a query from a table named `registrations` 
   to check if they are the same.*/
   
 select r.name,r.email_id
 from registration r
 join registration re 
 where r.Email_id = re.emailid;

/*10. **Extract Domain from Email:**
    Create a query to extract the domain from email addresses stored in a column named `email` 
    in the `users` table.*/
    
-- using substring_index

select substring_index(email,"@",-1)
from users;

-- using right function

-- select right("dsaikat1709@gmail.com",length("dsaikat1709@gmail.com")-locate("@","dsaikat1709@gmail.com",1))

select right(email,length(email)-locate("@",email,1))
from users;

-- using mid function

/*select mid("dsaikat1709@gmail.com",locate("@","dsaikat1709@gmail.com",1)+1,
length("dsaikat1709@gmail.com")-locate("@","dsaikat1709@gmail.com",1))*/

select mid(email,locate("@",email,1)+1,length(email)-locate(email));
