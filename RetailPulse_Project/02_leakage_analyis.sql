-- Which products do customers buy once and never again?

with non_reordered_products as (
  select
  count(op.reordered) as not_reordered,
  p.product_name
  from order_products__prior as op
  left join products as p
  on op.product_id = p.product_id
  Where reordered = 0 and p.product_name is not null
  group by p.product_name
)
select * from non_reordered_products
order by not_reordered desc

-- Which departments have the worst reorder rates?

with worst_reorder_rates as (
  select
  count(op.reordered) as least_reordered,
  d.department
  from departments as d 
  left join products as p
  on d.department_id = p.department_id
  left join order_products__prior as op
  on p.product_id = op.product_id
  where reordered = 0
  group by d.department
)
select * from worst_reorder_rates
order by least_reordered desc

-- How many orders has each customer placed? Who has placed only 1 or 2 orders and disappeared?

with orders_placed as (
  select
  count(order_id) as order_count,
  user_id
  from orders
  group by user_id
  having count(order_id) <= 5
)
select * from orders_placed

-- Which day of week and hour of day has the most orders? Does order timing affect reorder behavior?

with most_orders_of_day as (
  select
  order_hour_of_day,
  count(order_hour_of_day) as total_orders,
  order_dow
  from orders 
  group by order_dow, order_hour_of_day
)
select * from most_orders_of_day
order by total_orders desc

-- What are the top 10 most reordered products? 

Select top 10 
p.product_name,
count(*) as reorder_count
from order_products__prior as op
left join products as p
on op.product_id = p.product_id
where op.reordered = 1
and p.product_name is not null
group by p.product_name
order by reorder_count desc

-- Which department contribute most to orders? 

select
d.department,
count(op.order_id) as total_orders
from departments as d
left join products as p
on d.department_id = p.department_id
left join order_products__prior as op
on op.product_id = p.product_id
group by d.department
order by total_orders desc

-- Which products are most commonly added first to cart?

select
p.product_name,
count(*) as added_first_to_cart
from order_products__prior as op
left join products as p
on op.product_id = p.product_id
where op.add_to_cart_order = 1
and p.product_name is not null
group by p.product_name
order by added_first_to_cart desc

-- Which aisles receive the highest number of purchases?

select
a.aisle,
count(op.order_id) as no_of_purchases
from aisles as a
left join products as p
on a.aisle_id = p.aisle_id
left join order_products__prior as op
on op.product_id = p.product_id
where a.aisle NOT IN ('missing', 'other')
group by a.aisle
order by no_of_purchases desc