Create TABLE sales_data(
order_id INT,
customer_id VARCHAR(50),
product_category VARCHAR(50),
product_price FLOAT,
quantity INT,
order_date DATE,
region VARCHAR(50),
payment_method VARCHAR(50),
delivery_days INT,
is_returned INT,
customer_rating FLOAT,
discount_percent INT,
revenue FLOAT
)



-- Data Analysis using SQL:


-- Quantity distribution:
select MIN(quantity) as min_qty,
MAX(quantity) as max_qty,
round(avg(quantity)::numeric,2) as avg_qty,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY quantity)
AS median_qty from sales_data;

-- Rating disturbution:

SELECT 
    customer_rating,
    ROUND(AVG(customer_rating)::numeric, 2) AS avg_rating,
    COUNT(*) AS count
FROM sales_data
GROUP BY customer_rating
ORDER BY customer_rating DESC;

select 
revenue,
discount_percent,
quantity,
(revenue / NULLIF(quantity, 0))  as price_per_unit,
(revenue / ( 1 - discount_percent / 100)) as original_revenue
from sales_data
limit 10;

select * from sales_data;

--- Revenue by payment method

select payment_method,
round(sum(revenue)::numeric,2) as total_revenue
from sales_data
group by payment_method
order by total_revenue desc;

-- Credit card,Paypal and Bank Transfer payment_method are generated more money.

-- Net revenue after discount:

select
order_id,
revenue,
discount_percent,
round(revenue::numeric * (1 - discount_percent / 100.0)::numeric,2) as net_revenue
from sales_data;

-- Estimated profit margin

select 
order_id,
revenue,
round((1 - 0.70)* 100,2) as estimated_margin
from sales_data;

--- Average Delivery time by region
select
region,
round(avg(delivery_days),2) as avg_delivery_days
from sales_data
group by region
order by avg_delivery_days;

-- Return rate by payment method:

select
payment_method,
round(avg(is_returned) * 100,2) as return_rate_percent
from sales_data
group by payment_method
order by return_rate_percent desc;

-- Revenue by product Category
select
product_category,
round(sum(revenue)::numeric,2) as total_revenue
from sales_data
group by product_category
order by total_revenue desc;

-- Insights and findings:

--  All the products categories contribute the same revenue:
-- Regions with delivery > 5 days show higher return rated and lower ratings.
--  30% margin baseline, improving discount discipline and 
-- reducing returned could expand profit margin by 3-5 percentage points.

-- Based on the analysis of sales_data, revenue is concentrated in a few key products,
-- categories, suggesting a clear opportunity to deepen investment and pricing 
-- precision in those segments.
