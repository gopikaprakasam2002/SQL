#1))..weekday vs weekend(order_purchase_timestamp) payment statistics
select
  case
     when dayofweek(o.order_purchase_timestamp) in (1,7)  then 'weekend'
  else 'weekday'
  end as day_type,
SUM(pd.payment_value) as totalpayment,
round(AVG(pd.payment_value))as average_value
 from olist_orders_dataset as o
join
olist_order_payments_dataset  pd on o.order_id=pd.order_id 
group by day_type;

#2)number of order with review score5 and payment type as credit card
select 
count(*) as totalorder
from olist_order_payments_dataset as pd
join olist_order_reviews_dataset r on pd.order_id=r.order_id
where r.review_score=5 and pd.payment_type='credit_card';
  #or)) ii)
  
WITH avg_price AS (SELECT ROUND(AVG(item.price)) AS avg_item_price
FROM olist_order_items_dataset item
JOIN olist_orders_dataset ord 
ON item.order_id = ord.order_id
JOIN olist_customers_dataset cust 
ON ord.customer_id = cust.customer_id
WHERE cust.customer_city = "Sao Paulo"),
avg_payment AS (SELECT ROUND(AVG(pmt.payment_value)) AS avg_payment_value
FROM olist_order_payments_dataset pmt
JOIN olist_orders_dataset ord 
ON pmt.order_id = ord.order_id
JOIN olist_customers_dataset cust 
ON ord.customer_id = cust.customer_id
WHERE cust.customer_city = "Sao Paulo")
SELECT 
(SELECT avg_item_price FROM avg_price) AS avg_price,
(SELECT avg_payment_value FROM avg_payment) AS avg_payment_value;


#3)average number of days taken for order delivered for pet shop
select
pd.product_category_name as productname,
round(avg(datediff(od.order_delivered_customer_date,order_purchase_timestamp))) as avgdays
from olist_orders_dataset as od
join olist_order_items_dataset as i on i.order_id=od.order_id
join olist_products_dataset as pd on pd. product_id=i.product_id
where product_category_name='pet_shop' ;

#4)average price and average value from customer of sao paulo city
select
c.customer_city as CITY,
round(avg(i.price)) as AVERAGE_PRICE,
round(avg(p.payment_value)) as AVERAGE_VALUE
from olist_customers_dataset as c
join olist_orders_dataset as o on c.customer_id=o.customer_id
join olist_order_items_dataset as i on o.order_id=i.order_id
join olist_order_payments_dataset as p on o.order_id=p.order_id
where c.customer_city='sao paulo';

#5)relationship between shipping days  vs review score
select 
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)))as SHIPPING_DATE,review_score
FROM olist_orders_dataset AS od
join olist_order_reviews_dataset as r on od.order_id=r.order_id
group by r.review_score order by review_score;
   
#6) TOP 5 PRODUCT AND SALES
SELECT
round(sum(i.price)) as PRICE,
P.product_category_name as PRODUCT_NAME
 from 
 olist_products_dataset AS p 
 JOIN olist_order_items_dataset AS i on p.product_id=i.product_id
 group by p.product_category_name order by price desc limit 5;
 
 #7) bottom 5 PRODUCT AND SALES
SELECT
round(sum(i.price)) as PRICE,
P.product_category_name as PRODUCT_NAME
 from 
 olist_products_dataset AS p 
 JOIN olist_order_items_dataset AS i on p.product_id=i.product_id
 group by p.product_category_name order by price asc limit 5;




