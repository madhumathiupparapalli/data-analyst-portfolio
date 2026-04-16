-- ==================
--DATA EXPLORATION
-- ==================

--Step 1: Preview all tables

select top 10 * from olist_customers_dataset
select top 10 * from olist_order_items_dataset
select top 10 * from olist_order_payments_dataset
select top 10 * from olist_order_reviews_dataset
select top 10 * from olist_orders_dataset
select top 10 * from olist_products_dataset
select top 10 * from olist_sellers_dataset
select top 10 * from product_category_name_translation


--Step 2: Row counts for all tables

select count(*) from olist_customers_dataset
union all
select count(*) from olist_order_items_dataset
union all
select count(*) from olist_order_payments_dataset
union all
select count(*) from olist_order_reviews_dataset
union all
select count(*) from olist_orders_dataset
union all
select count(*) from olist_products_dataset
union all
select count(*) from olist_sellers_dataset
union all
select count(*) from product_category_name_translation


-- Step 3: Order status distribution

select order_status, count(*) as count
from olist_orders_dataset
group by order_status
order by count desc