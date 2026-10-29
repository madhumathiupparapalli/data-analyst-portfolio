-- Which products have the highest number of first-time purchase occurences?

  select
  p.product_id,
  p.product_name,
  count(*) as first_time_purchase_count
  from order_products__prior as op
  left join products as p
  on op.product_id = p.product_id
  Where reordered = 0
  group by p.product_id, p.product_name
  order by first_time_purchase_count desc
  

-- Which departments have the worst reorder rates?

select
    d.department_id,
    d.department,
    count(*) as total_product_records,
    sum(case when op.reordered = 1 then 1 else 0 end)
        as reordered_records,
    cast(
         100.0 * sum(
        case when op.reordered = 1 then 1 else 0 end
    ) / nullif (count(*), 0)
    as decimal(5,2)
    ) as reorder_rate_pct
from order_products__prior as op
join products as p
    on op.product_id = p.product_id
join departments as d
    on p.department_id = d.department_id
group by d.department_id, d.department
order by reorder_rate_pct asc


-- Which day of week and hour of day has the most orders? Does order timing affect reorder behavior?

select
    o.order_dow,
    o.order_hour_of_day,
    count(distinct o.order_id) as total_orders,
    count(*) as total_product_records,
    sum(case when op.reordered = 1 then 1 else 0 end)
        as reordered_records,
    cast(
        100.0 * sum(
            case when op.reordered = 1 then 1 else 0 end
        ) / nullif(count(*),0)
        as decimal
    ) as reorder_rate_pct
from orders as o
join order_products__prior as op
   on o.order_id = op.order_id
group by 
    o.order_dow,
    o.order_hour_of_day
order by total_orders desc

-- What are the top 10 most reordered products? 

Select top 10
p.product_id,
p.product_name,
count(*) as reorder_count
from order_products__prior as op
left join products as p
on op.product_id = p.product_id
where op.reordered = 1
and p.product_name is not null
group by p.product_id,p.product_name
order by reorder_count desc, p.product_id

-- Which department contribute most to orders? 

select
d.department,
count(op.order_id) as total_product_records
from departments as d
left join products as p
on d.department_id = p.department_id
left join order_products__prior as op
on op.product_id = p.product_id
group by d.department
order by total_product_records desc

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
