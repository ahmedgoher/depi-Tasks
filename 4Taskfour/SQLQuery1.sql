use StoreDB


/*
1.
Write a query that classifies all products into price categories:

Products under $300: "Economy"
Products $300-$999: "Standard"
Products $1000-$2499: "Premium"
Products $2500 and above: "Luxury"
*/
select  product_name,list_price,
case 
when list_price>=2500 then 'Luxury'
when list_price between 1000 and 2499 then 'Premium'
when list_price between 300 and 999 then 'Standard'
else 'Economy'
end as "price category"
from production.products


/*
2.
Create a query that shows order processing information with user-friendly status descriptions:

Status 1: "Order Received"
Status 2: "In Preparation"
Status 3: "Order Cancelled"
Status 4: "Order Delivered"
Also add a priority level:

Orders with status 1 older than 5 days: "URGENT"
Orders with status 2 older than 3 days: "HIGH"
All other orders: "NORMAL"
*/
select order_id,order_date,
case order_status
when 1 then 'Order Received'
when 2 then 'In Preparation'
when 3 then 'Order Cancelled'
when 4 then 'Order Delivered'
end as StatusDescription,
case
when order_status=1 and datediff(DAY,required_date,order_date) > 5 then 'URGENT'
when order_status=2 and datediff(DAY,required_date,order_date) > 3 then 'HIGH'
else 'NORMAL'
end as Priority
from sales.orders

/*
3.
Write a query that categorizes staff based on the number of orders they've handled:

0 orders: "New Staff"
1-10 orders: "Junior Staff"
11-25 orders: "Senior Staff"
26+ orders: "Expert Staff"
*/
select s.first_name+' '+s.last_name as"Full name" ,COUNT(o.order_id) as OrderCount
,
case  
 WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
        ELSE 'Expert Staff'
end as "staff category"
from  sales.staffs s left join sales.orders o on s.staff_id=o.staff_id
group by s.staff_id,s.first_name+' '+s.last_name;

/*
4.
Create a query that handles missing customer contact information:

Use ISNULL to replace missing phone numbers with "Phone Not Available"
Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")
Show complete customer information
*/
select customer_id ,first_name,last_name ,ISNULL(phone,'Phone Not Available') as contact_phone, email, street,city,state,zip_code from sales.customers
select customer_id ,first_name,last_name ,coalesce(phone,email,'Phone Not Available') as contact, street,city,state,zip_code from sales.customers
------
select customer_id ,first_name,last_name ,ISNULL(phone,'Phone Not Available') as contact_phone, email, street,city,state,zip_code,coalesce(phone,email,'Phone Not Available') as contact from sales.customers

/*
5.Write a query that safely calculates price per unit in stock:

Use NULLIF to prevent division by zero when quantity is 0
Use ISNULL to show 0 when no stock exists
Include stock status using CASE WHEN
Only show products from store_id = 1
*/
select 
p.product_id,
p.product_name ,
s.quantity ,
p.list_price,
isnull(p.list_price/nullif(s.quantity,0),0) as price_per_unit,
case 
when s.quantity=0 then 'Out of Stock'
        ELSE 'In Stock'
        END AS stock_status
from production.products p 
left join production.stocks s 
on p.product_id =s.product_id
where s.store_id=1

/*
6.Create a query that formats complete addresses safely:

Use COALESCE for each address component
Create a formatted_address field that combines all components
Handle missing ZIP codes gracefully
*/
select 
customer_id,
coalesce(street,'')as street,
coalesce(city,'')as city,
coalesce(state,'Empty')as state,
coalesce(zip_code,'no ZIP')as zip_code,

coalesce(street,'') +','+
coalesce(city,'')+' ,'+
coalesce(state,'')+','+
coalesce(zip_code,'no ZIP')
 as formatted_address
from sales.customers

/*
7- Use a CTE to find customers who have spent more than $1,500 total:

Create a CTE that calculates total spending per customer
Join with customer information
Show customer details and spending
Order by total_spent descending
*/

with total_spending as (
select o.customer_id , sum(oi.list_price) as "total_price" from sales.orders o join sales.order_items oi on o.order_id= oi.order_id
group by o.customer_id

)

select * from total_spending ts join sales.customers c on  ts.customer_id =c.customer_id
where ts.total_price >1500
order by ts.total_price desc


  /*
  8-Create a multi-CTE query for category analysis:

CTE 1: Calculate total revenue per category
CTE 2: Calculate average order value per category
Main query: Combine both CTEs
Use CASE to rate performance: >$50000 = "Excellent", >$20000 = "Good", else = "Needs Improvement"
*/
with calc_total_rev as (
select p.category_id,    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue from sales.order_items oi join production.products  p on oi.product_id = p.product_id
group by p.category_id
)
,average_order AS (
select p.category_id,    avg(oi.list_price) AS avg_price from sales.order_items oi join production.products  p on oi.product_id = p.product_id
group by p.category_id
)
select ctr.category_id ,ao.avg_price, ctr.total_revenue,
case 
when  ctr.total_revenue > 50000 then 'Excellent'
when ctr.total_revenue> 20000 then 'Good'
else 'Needs Improvement'
end as rate
from calc_total_rev ctr join average_order ao on ctr.category_id =ao.category_id

/*
9.Use CTEs to analyze monthly sales trends:

CTE 1: Calculate monthly sales totals
CTE 2: Add previous month comparison
Show growth percentage
*/

with monthly_sales_totals as(
select  year(o.order_date)as "years",MONTH(o.order_date) months,sum(oi.list_price) prisces ,month (dateadd(month,-1,o.order_date)) as newmonth
from sales.orders o join sales.order_items oi on o.order_id=oi.order_id
group by year(order_date),MONTH(order_date) ,nullif(month (dateadd(month,-1,o.order_date)),0)
order by year(order_date),MONTH(order_date)
),prev_month as (
select nullif(month-1,0) , prisce from monthly_sales_totals
)
select * from prev_month


/*order by year(order_date),MONTH(order_date)*/

/*10.Create a query that ranks products within each category:

Use ROW_NUMBER() to rank by price (highest first)
Use RANK() to handle ties
Use DENSE_RANK() for continuous ranking
Only show top 3 products per category
*/

with rank_product as(
select  c.category_name,p.list_price,ROW_NUMBER() over (PARTITION BY p.category_id order by p.list_price) AS row_num ,
rank() over (partition by p.category_id order by p.list_price) as row_rank_num,
DENSE_RANK() over(partition by p.category_id order by p.list_price) as row_denseRanck
from production.products p join production.categories c on p.category_id= c.category_id
)
select * from rank_product rp where rp.row_num<=3 
/*
11.Rank customers by their total spending:

Calculate total spending per customer
Use RANK() for customer ranking
Use NTILE(5) to divide into 5 spending groups
Use CASE for tiers: 1="VIP", 2="Gold", 3="Silver", 4="Bronze", 5="Standard"
*/
with calc_total as(
select customer_id,sum(list_price) as prices,
rank() over(order by sum(list_price) desc) as ranks,
NTILE(5) over(order by sum(list_price) desc)as tiers 
from sales.orders o join sales.order_items oi on o.order_id=oi.order_id
group by customer_id)
select *,
case tiers
when 1 then 'VIP'
when 2 then 'Gold'
when 3 then 'Silver'
when 4 then 'Bronze'
when 5 then 'Standard'
end as ran
from calc_total

/*
12.Create a comprehensive store performance ranking:

Rank stores by total revenue
Rank stores by number of orders
Use PERCENT_RANK() to show percentile performance
*/
with total_reve as
(
select o.store_id,sum (oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
from sales.orders o join sales.order_items oi on o.order_id=oi.order_id
group by o.store_id
), number_of_orders as
(
select store_id,COUNT(*) as numOfOrder from sales.orders
group by store_id
)
select tr.store_id,tr.total_revenue, o.numOfOrder,
rank() over(order by tr.total_revenue desc)as rankone,
rank() over(order by o.numOfOrder desc) as ranktwo
from total_reve tr join number_of_orders o on tr.store_id= o.store_id

/*
13.Create a PIVOT table showing product counts by category and brand:

Rows: Categories
Columns: Top 4 brands (Electra, Haro, Trek, Surly)
Values: Count of products
*/
select* from
(
SELECT 
        c.category_name,
        b.brand_name,
        p.product_id
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name IN ('Ralph Lauren', 'Hugo Boss', 'Calvin Klein', 'Nike')
    )t
    pivot(
    count(product_id)
    for brand_name in ([Ralph Lauren],[Hugo Boss],[Calvin Klein],[Nike])
    )   as PivotTable;

/*14.Create a PIVOT showing monthly sales revenue by store:

Rows: Store names
Columns: Months (Jan through Dec)
Values: Total revenue
Add a total column
*/
select * from (
select o.store_id ,s.store_name ,month(o.order_date)as months ,
sum (oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
from sales.order_items oi 
join sales.orders o on o.order_id=oi.order_id 
join sales.stores s on o.store_id=s.store_id
group by o.store_id ,month(o.order_date) , store_name
)t
pivot(
count (store_id)
for months in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
)as PivotTable;

/*15.PIVOT order statuses across stores:

Rows: Store names
Columns: Order statuses (Pending, Processing, Completed, Rejected)
Values: Count of orders*/
select *from (
select s.store_name,o.order_id,o.order_status,
case o.order_status
when 1 then 'Pending'
when 2 then 'Processing' 
when 3 then 'Completed'
when 4 then 'Rejected'
end as orderstatue
from 
sales.orders o join sales.stores s on o.store_id=s.store_id)t 
pivot
(
count(order_id)
for orderstatue in ([Pending], [Processing], [Completed], [Rejected]) 
)as PivotTable;

/*16.Create a PIVOT comparing sales across years:

Rows: Brand names
Columns: Years (2016, 2017, 2018)
Values: Total revenue
Include percentage growth calculations*/

select*from (
select b.brand_name,p.model_year,sum (oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
from production.brands b join production.products p on b.brand_id = p.brand_id 
join sales.order_items oi on oi.product_id=p.product_id
group by b.brand_name , p.model_year
)t
pivot
(
sum(total_revenue)
for model_year in ([2022],[2023],[2024])
    
)as PivotTable;

/*17.Use UNION to combine different product availability statuses:

Query 1: In-stock products (quantity > 0)
Query 2: Out-of-stock products (quantity = 0 or NULL)
Query 3: Discontinued products (not in stocks table)

*/
select s.product_id,p.product_name from production.stocks s join production.products p on s.product_id=p.product_id
where quantity>0
union
select s.product_id,p.product_name from production.stocks s join production.products p on s.product_id=p.product_id
where quantity is null or quantity =0
union 
select s.product_id,p.product_name from production.stocks s join production.products p on s.product_id=p.product_id
where p.product_id not in (select product_id from production.stocks)
/*
18.Use INTERSECT to find loyal customers:

Find customers who bought in both 2022 AND 2023
Show their purchase patterns ??????
*/
SELECT customer_id 
FROM sales.orders
WHERE YEAR(order_date) = 2022

INTERSECT

SELECT customer_id 
FROM sales.orders
WHERE YEAR(order_date) = 2023;

/*19.Use multiple set operators to analyze product distribution:

INTERSECT: Products available in all 3 stores
EXCEPT: Products available in store 1 but not in store 2
UNION: Combine above results with different labels*/

SELECT product_id, 'In All Stores' AS status
FROM production.stocks
WHERE store_id = 1 AND quantity > 0

INTERSECT

SELECT product_id, 'In All Stores' AS status
FROM production.stocks
WHERE store_id = 2 AND quantity > 0

INTERSECT

SELECT product_id, 'In All Stores' AS status
FROM production.stocks
WHERE store_id = 3 AND quantity > 0

UNION


SELECT product_id, 'Only in Store 1' AS status
FROM production.stocks
WHERE store_id = 1 AND quantity > 0

EXCEPT

SELECT product_id, 'Only in Store 1' AS status
FROM production.stocks
WHERE store_id = 2 AND quantity > 0;

/* 20.Complex set operations for customer retention:

Find customers who bought in 2022 but not in 2023 (lost customers)
Find customers who bought in 2032 but not in 2022 (new customers)
Find customers who bought in both years (retained customers)
Use UNION ALL to combine all three groups
*/
select customer_id , 'lost customers' as year from sales.orders
where YEAR(order_date) =2022
except 
select customer_id , 'new customers' as year from sales.orders
where YEAR(order_date) =2023

union all

select customer_id , 'new customers' as year from sales.orders
where YEAR(order_date) =2023
except
select customer_id , 'lost customers' as year from sales.orders
where YEAR(order_date) =2022

union all

select customer_id , 'lost customers' as year from sales.orders
where YEAR(order_date) =2022
INTERSECT
select customer_id , 'new customers' as year from sales.orders
where YEAR(order_date) =2023