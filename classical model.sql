# 1) SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

SELECT * FROM EMPLOYEES;
SELECT employeeNumber,firstName,lastName from employees where jobTitle="Sales Rep" and reportsto =1102;

#b.....	Show the unique productline values containing the word cars at the end from the products table
select * from products;
SELECT distinct(PRODUCTLINE) FROM products WHERE productLine like '%cars'; 

#2)CASE STATEMENTS for Segmentation
#a....
     SELECT * FROM customers;
     SELECT CUSTOMERNUMBER,CUSTOMERNAME,
	CASE
                 WHEN COUNTRY= "USA" OR  COUNTRY="CANADA" THEN  "NORTHAMERICA"
                 WHEN COUNTRY= "UK" OR COUNTRY= "FRANCE" OR COUNTRY= "GERMANY" THEN  "EUROPE"
                 ELSE "OTHERS"
	END  AS CUSTOMERSEGMENT FROM CUSTOMERS;
    
    #3)Group By with Aggregation functions and Having clause, Date and Time functions
#a------	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.
SELECT * FROM orderdetails;
SELECT PRODUCTCODE,SUM(QUANTITYORDERED) AS TOTALORDER FROM orderdetails group by productCode order by TOTALORDER DESC LIMIT 10;
#B-------- 
SELECT * FROM payments;
SELECT  MONTHNAME(PAYMENTDATE)  AS MONTH,COUNT(*) AS NUM_PAYMENTS FROM PAYMENTS GROUP BY MONTH HAVING NUM_PAYMENTS>20 order by NUM_PAYMENTS DESC;

# 4)a....	Create a table named Customers to store customer information. Include the following columns:
CREATE DATABASE CUSTOMERS_ORDERS;
USE CUSTOMERS_ORDERS;
CREATE TABLE CUSTOMERS(customer_id int auto_increment,
                       first_name varchar(50),
                       last_name varchar(50),
                       email varchar(255) unique,
                       phone_number varchar(20),
                       primary key(customer_id));
alter table customers modify first_name varchar(50) not null;
alter table customers modify last_name varchar(50) not null;
#b........
create table order1(order_id int primary key auto_increment,
                    order_date date,
                    customer_id int,
                    total_amount decimal(10,2),
                     constraint fkcustomer_id foreign key(customer_id) references customers(customer_id),
                     constraint tot_amt check(total_amount>0));
select * from order1;
select * from customers;

#5)Q5. JOINS a---- List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables)
select * from customers;
select * from orders;
select c.country,count(o.ordernumber) as order_count from customers as c
 join orders as o on c.customerNumber=o.customerNumber
 group by c.country order by order_count desc limit  5;
 
#7)---. Create a table project with below fields.
create table project(employeeID int primary key AUTO_INCREMENT,
                     FULLNAME VARCHAR(50) NOT NULL,
                     GENDER ENUM("MALE","FEMALE"),
                     MANAGERID INT);
INSERT INTO PROJECT VALUES(1,"PRANAYA","MALE",3),
                           (2,"PRIYANKA","FEMALE",1),
                           (3,"PREETY","FEMALE",NULL),
                           (4,"ANURAG","MALE",1),
                           (5,"SAMBIT","MALE",1),
                           (6,"RAJESH","MALE",3),
                           (7,"HINA","FEMALE",3);
SELECT *  FROM PROJECT;
SELECT P2.FULLNAME AS MANAGERNAME,P1.FULLNAME AS EMPLOYEENAME FROM
 PROJECT AS P1
JOIN PROJECT AS P2 ON P2.EMPLOYEEID=P1.MANAGERID;

#7)..ddl comments
create table facility(facility_ID INT,
                      NAME VARCHAR(100),
                      STATE VARCHAR(100),
                      COUNTRY VARCHAR(100));
#A) alter THE TABLE
ALTER TABLE FACILITY MODIFY FACILITY_ID INT PRIMARY KEY auto_increment;
DESC FACILITY;
#B)ADD CITY COLUMN
alter TABLE FACILITY ADD CITY VARCHAR(20) NOT NULL;

#8)---------

SELECT* FROM productlines;
select * from products;
select * from orders;
select * from orderdetails;
create view product_category_sales as select
                                     p1.productline as productline,
									 sum(od.quantityordered * od.priceeach) as total_sales,
									count(distinct o.ordernumber) as number_of_orders
from products as p
join productlines as p1 on p.productline=p1.productline
join orderdetails as od on p.productcode=od.productcode
join orders as o on o.ordernumber=od.ordernumber
group by p1.productline;
select * from product_category_sales;

#9)-----
#Tables: Customers, Payments
select* from customers;
select* from payments;

  DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `assignment9`(in year int, in country varchar(100))
BEGIN
select 
       YEAR(p.paymentDATE) as year,
        C.COUNTRY as country,
        concat(format(sum(p.amount)/1000,0),'k') as total_amount
       from  customers c join payments as p on p.customernumber=c.customernumber
 where
       year(p.paymentdate)=year and 
       c.country=country
group by
         year(p.paymentdate),c.country;
END$$
call classicmodels.assginment9(2003, 'france');

# 10)----Q10. Window functions - Rank, dense_rank, lead and lag
#a) Using customers and orders tables, rank the customers based on their order frequency
select * from orders;
select * from customers;
select c.customername,count(ordernumber)  as order_count ,rank()over(order by count(o.ordernumber)desc) as order_frequency_rnk from customers as c 
join orders as o on c.customernumber=o.customernumber
 group by c.customername order by order_count desc;
#b)---
SELECT 
    YEAR(ORDERDATE) AS "YEAR",
    MONTHNAME(ORDERDATE) AS "MONTH",
    COUNT(ORDERNUMBER) AS totalorders,
  concat(round(((count(ordernumber)-lag(count(ordernumber),1)over())/lag(count(ordernumber),1)over())*100),"%") as "% YOY change" FROM orders
GROUP BY YEAR,MONTH;

#11)---subqueries. 
select * from productlines;
select productline,count(productline) as total from products where buyprice >(select avg(buyprice) from products)
group by productline order by total desc;
select * from products;

#12)----  ERROR HANDLING

create table EMP_EH(empid int primary key,empname varchar (20),emailaddress varchar(20));
select * from emp_eh;
create table emplo_eh(empid int primary key,empname varchar (20),emailaddress varchar(20));
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `error handling`(emp_id int,empname varchar(20),emailaddress varchar(20))
BEGIN
declare exit handler for sqlexception
begin
select "error occurance" as error;
end;
insert into emp_eh (emp_id,empname,emailaddress) values(emp_id,empname,emailaddress);
END $$

call classicmodels.`error handling`(1, 'gopi', 'gpi@gmail.com');

#13)---TRIGGERS
Create  table Emp_BIT( Name VARCHAR(20), Occupation VARCHAR(20), Working_date DATE,Working_hours INT);
INSERT TABLE Emp_BIT VALUES('Robin', 'Scientist', '2020-10-04', 12),  
                           ('Warner', 'Engineer', '2020-10-04', 10),  
                           ('Peter', 'Actor', '2020-10-04', 13),  
                           ('Marco', 'Doctor', '2020-10-04', 14),  
						   ('Brayden', 'Teacher', '2020-10-04', 12),  
                           ('Antonio', 'Business', '2020-10-04', 11);
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
    if new.working_hours < 0 then
        set new.working_hours = abs(new.working_hours);
    end IF;
    END $$
 



















 
 
 



