-- Retail Sales Performance Analysis Using SQL
create database  retail_sales;
use retail_sales;
CREATE TABLE sales_info (
    Row_id INT,
    Order_id VARCHAR(50),
    Order_date VARCHAR(50),
    Ship_date VARCHAR(50),
    Ship_mode VARCHAR(100),
    Customer_id VARCHAR(50),
    Customer_name VARCHAR(255),
    Segment VARCHAR(100),
    Country VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_code VARCHAR(20),
    Region VARCHAR(50),
    Product_id VARCHAR(100),
    Category VARCHAR(100),
    Sub_category VARCHAR(100),
    Product_name TEXT,
    Sales DOUBLE,
    Quantity INT,
    Discount DOUBLE,
    Profit DOUBLE
);
 select* from  sales_info;
 
 -- Sales analysis
 -- total revenue generates by the company
  select round(sum(sales),2) as Total_sales 
  from sales_info;
  
  -- show overall profit
   select round(sum(profit),2) as Total_profit
   from sales_info;
-- total orders
select count(distinct order_id) as total_orders
from  sales_info;
-- Average order values
select round(sum(sales)/count(distinct order_id),2)as avg_order_value
from sales_info;

-- Product analysis
-- sales by category
select round(sum(sales),2) as Total_sales
from sales_info
 group by Category
 order by Total_sales desc;
 -- profit by category
select round(sum(profit),2) as Total_profit
from sales_info
group by category
order by Total_profit desc;

-- Top 10 products by Sales
select Product_name,round(sum(sales),2) as total_sales
from sales_info
group by product_name
order by  total_sales desc
limit 10;
-- Top 10 products by profit
select product_name,round(sum(profit),2)as total_profit
from sales_info
group by product_name
order by total_profit desc
limit 10;
 -- customers analysis
 -- sales by segment
 select segment,round(sum(sales),2)as total_sales
 from sales_info
  group by segment
  order by total_sales desc;
  -- Top 5 customers by sale
 with customer_sales as( select customer_name,round(sum(sales),2) as total_sales
 from sales_info
 group by customer_name)
 select * from customer_sales
 order by total_sales desc
 limit 5;
 -- customers above avg_sales
 with customer_sales as(select customer_name,round(sum(sales),2)as total_sales
 from sales_info
 group by customer_name)
 select * 
 from customer_sales 
 where total_sales>(select avg(total_sales) from customer_sales);
 
 
 --  Regional Analysis
 -- sales by region
 select region, round(sum(sales),2)as total_sales
from sales_info
group by region
order by total_sales desc;
 -- profit by region
 select region ,round(sum(profit),2) as profit
 from sales_info
 group by region
 order by profit desc;
-- Top states
  select state ,round(sum(sales),2)as total_sales
 from sales_info
 group by state
 order by  total_sales desc
 limit 10;
 -- profitability analysis
 -- loss making product
 select product_name,round(sum(profit),2) as total_loss
 from sales_info
 group by product_name
 having total_loss<0
 order by total_loss;
 
 -- Discount impact
 select Discount, round(avg(profit),2)as avg_profit
 from sales_info
 group by discount
 order by discount;
 
 -- rank products by sales
 select product_name,round(sum(sales),2)as total_sales,rank()over( order by sum(sales) desc) as rank_no 
 from sales_info
 group by product_name;
 
 -- states by profit-- dense rnk
 select  state ,round(sum(profit),2) as total_profit, dense_rank()over( order by sum(profit) desc) as rank_no
 from sales_info
 group by state;
 
 -- products above avg_sales
 select  product_name ,round(sum(sales),2) as total_sales 
 from sales_info
 group by product_name
 having sum(sales) >(select avg(sales) from sales_info);
-- find customers from same city
select  a.customer_name,b.customer_name ,a.city
from sales_info a join sales_info b on a.city=b.city and a.customer_name<>b.customer_name;
-- customer sales report--using stored procedure


delimiter $$
 create procedure  GetcustomerSales(in p_customer_name varchar(100))
 begin
  select  customer_name, round(sum(sales),2)as Total_sales,  round(sum(profit),2) as total_profit
  from sales_info
  where customer_name=p_customer_name
  group by customer_name;
  end $$
  delimiter ;
  call GetcustomerSales("sean miller");
  
  
  -- top customer in each region -- windows function+ advanced cte
  with  customer_sales as(select distinct region, customer_name,round(sum(sales),2)as total_sales,row_number() over( partition by region order by sum(sales) desc)as rank_no
  from sales_info
  group by region,customer_name)
  select *
  from customer_sales 
  where rank_no=1;
  
  
  
  
  
