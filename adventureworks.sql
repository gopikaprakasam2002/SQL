create database adventureworks;
use adventureworks;
select * from customer;
select * from product;
select * from dimproductcategory;
select * from dimproductsubcategory;
select * from dimsalesterritory;
select * from factinternetsales;
select * from factinternetsalesnew;
select * from dimdate1;
select * from sales;
-- 0q union 
select * from factinternetsales union
select * from factinternetsalesnew;
-- 1q lookup
select s.productkey,p.EnglishproductName from sales s join product p on s.productkey=p.productkey;
-- 2q lookup
SELECT S.Productkey, p.Unitprice as unitprice,p.englishproductname ,concat(C.Firstname,C.Middlename,C.Lastname) as fullname from Sales S JOIN Customer C ON S.Customerkey = C.Customerkey JOIN Product P
ON S.Productkey = P.Productkey;
-- 3q orderdate key field
alter table sales add column order_date date;
set sql_safe_updates=0;
update sales set order_date=str_to_date(orderdatekey,'%Y%m%d');
select * from sales;
select *,year(order_date) as year,month(order_date) as monthno,monthname(order_date) as monthname,quarter(order_date) as quarter,
dayofweek(order_date) as weekdayno,dayname(order_date) as weekdayname,
month(order_date) as calendarmonth,case when month(order_date)>=4 then month(order_date) -3 else month(order_date) +9 end as financialmonth,
month(order_date) as calendarmonth,case when month(order_date) in (4,5,6) then 'Q1' when month(order_date) in (7,8,9) then 'Q2' when month(order_date) in (10,11,2) then 'Q3'
else 'Q4' end as financialquarter from sales;
-- 4q sales amount
SELECT P.UnitPrice, S.OrderQuantity,S.UnitPriceDiscountPct , (P.UnitPrice * S.OrderQuantity * (1 - S.UnitPriceDiscountPct )) AS SalesAmount  FROM Sales S JOIN Product P
ON S.Productkey = P.Productkey;
-- 5q production cost
SELECT totalproductcost,orderquantity,(totalproductcost * orderquantity) AS productioncost FROM sales;
-- 6q profit
select salesamount,totalproductcost as productioncost, (salesamount-totalproductcost) as profit from sales;
-- 7q month and sales
select month(order_date) as months,sum(Salesamount) as totalsales from sales where year(order_date)=2011 group by month(order_date);-- here i will give different years
-- 8q yearwise sales
select year(order_date) as year,sum(salesamount) as totalsales from sales group by year(order_date);
-- 9q monthwise sales
select month(order_date) as month,sum(salesamount) as totalsales from sales group by month(order_date);
-- 10q quarterwise sales
select quarter(order_date) as quarter,sum(salesamount) as totalsales from sales group by quarter(order_date);
-- 11q combine sales and production
select salesamount,totalproductcost as productioncost from sales;
-- 12 q kpi charts
alter table sales add column region varchar(30);
select * from dimsalesterritory;
update sales s join dimsalesterritory t on s.salesterritorykey=t.salesterritorykey set s.region=t.salesterritoryregion;
-- products
select productkey,count(productkey) as totalnoofproducts from sales group by productkey;
-- customers
select customerkey,count(customerkey) as totalnooforders from sales group by customerkey;
-- region
select region,sum(salesamount)as regionwisesales from sales group by region;


