--Check 1: How many orders have missing delivery dates?

select count(*) - count(order_delivered_customer_date) as null_delivered_dates
from olist_orders_dataset

--Check 2: Filter only delivered orders for analysis

select
order_id,
order_status,
order_delivered_customer_date
from olist_orders_dataset
where order_status = 'delivered'

--Check 3: Convert date columns from nvarchar to datetime for calculations

select 
order_id,
convert(datetime, order_delivered_customer_date)
from olist_orders_dataset

-- Cleaned dataset for analysis
select 
order_id,
customer_id,
order_status,
convert(datetime, order_purchase_timestamp) as purchase_date,
convert(datetime, order_delivered_customer_date) as delivered_date,
convert(datetime, order_estimated_delivery_date) as estimated_date,
datediff(day, 
convert(datetime, order_purchase_timestamp),
convert(datetime, order_delivered_customer_date)
) as delivery_days
from olist_orders_dataset
where order_status = 'delivered'
and order_delivered_customer_date is not null

--Check for invalid deliveries (delivered before purchase)
select *
from olist_orders_dataset
where order_delivered_customer_date is not null
and convert(datetime, order_delivered_customer_date) <
convert(datetime, order_purchase_timestamp)

-- Check missing critical columns
select 
count(*) as total_orders,
count(order_delivered_customer_date) as delivered_count,
count(order_estimated_delivery_date) as estimated_count,
count(order_purchase_timestamp) as purchase_count
from olist_orders_dataset