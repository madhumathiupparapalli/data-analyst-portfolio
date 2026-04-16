--Question 1: Late delivery rates by state and correlation with review scores

select
oc.customer_state,
count(o.order_id) as total_orders,
sum(case when convert(datetime,o.order_delivered_customer_date) >
convert(datetime,o.order_estimated_delivery_date) 
Then 1 else 0 end) as late_orders,
round(sum(case when convert(datetime,o.order_delivered_customer_date) >
convert(datetime,o.order_estimated_delivery_date) 
Then 1 else 0 end) * 100.0/ count(o.order_id),2) as late_rate_percent,
round(avg(cast(r.review_score as float)),2) as avg_review_score
from olist_orders_dataset as o
left join olist_customers_dataset as oc
on o.customer_id = oc.customer_id
left join olist_order_reviews_dataset as r
on o.order_id = r.order_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
and oc.customer_state is not null
group by oc.customer_state
order by late_orders desc

--Question 2: Product categories with highest and lowest review score

select
t.product_category_name_english,
count(o.order_id) as total_orders,
round(avg(cast(r.review_score as float)),2) as avg_review_score
from olist_order_items_dataset as o
join olist_products_dataset as p
on o.product_id = p.product_id
join olist_order_reviews_dataset as r
on o.order_id = r.order_id
join product_category_name_translation as t
on p.product_category_name = t.product_category_name
group by t.product_category_name_english
order by avg_review_score desc

--Question 3: Average delivery time per state with Performance ranking

with delivery_by_state as(
select
oc.customer_state,
avg(datediff(day,
convert(datetime,o.order_purchase_timestamp),
convert(datetime,o.order_delivered_customer_date))) as avg_delivery_days
from olist_orders_dataset as o
left join olist_customers_dataset as oc
on o.customer_id=oc.customer_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
and oc.customer_state is not null
group by oc.customer_state
)
select *,
rank() over (order by avg_delivery_days asc) as delivery_rank
from delivery_by_state

--Question 4: Sellers with lowest review scores - identifying underperformers

select
oi.seller_id,
count(oi.order_id) as total_orders,
round(avg(cast(r.review_Score as float)),2) as avg_review_score
from olist_order_items_dataset as oi
join olist_order_reviews_dataset as r
on oi.order_id = r.order_id
group by oi.seller_id
having count(oi.order_id) > 5
order by avg_review_score asc

--Question 5: Freight value variation across states and product categories - where is delivery most expensive?

select
oc.customer_state,
round(avg(o.freight_value),2) as avg_freight_value,
t.product_category_name_english
from olist_order_items_dataset as o
left join olist_products_dataset as p
on o.product_id = p.product_id
left join olist_orders_dataset as ord
on o.order_id = ord.order_id
left join olist_customers_dataset as oc
on ord.customer_id = oc.customer_id
left join product_category_name_translation as t
on p.product_category_name = t.product_category_name
where oc.customer_state is not null
group by oc.customer_state,t.product_category_name_english
order by avg_freight_value desc

--Question 6: Does higher freight cost lead to faster and more reliable deliveries, or are customers paying more without better service?

select
case
when o.freight_value < 20 then 'Low Freight'
when o.freight_value between 20 and 50 then 'Medium Freight'
else 'High Freight'
end as freight_category,
count(o.order_id) as total_orders,
round(avg(o.freight_value),2) as avg_freight,
round(avg(datediff(day,
convert(datetime,oi.order_purchase_timestamp),
convert(datetime,oi.order_delivered_customer_date))),2) as avg_delivery_days,
round(avg(cast(r.review_score as float)),2) as avg_review_score
from olist_order_items_dataset as o
join olist_orders_dataset as oi
on o.order_id = oi.order_id
join olist_order_reviews_dataset as r
on o.order_id = r.order_id
where oi.order_status = 'delivered'
and oi.order_delivered_customer_date is not null
group by 
case 
when o.freight_value < 20 then 'Low Freight'
when o.freight_value between 20 and 50 then 'Medium Freight'
else 'High Freight'
end
order by avg_freight asc

--Question 7: What are the key factors driving late deliveries - are delays caused by specific sellers, states or product categories?

select
os.seller_state,
t.product_category_name_english,
count(o.order_id) as total_orders,
sum(case when convert(datetime,oi.order_delivered_customer_date) >
convert(datetime, oi.order_estimated_delivery_date)
then 1 else 0 end) as late_orders,
cast(round(sum(case when convert(datetime, oi.order_delivered_customer_date) >
convert(datetime, oi.order_estimated_delivery_date)
then 1 else 0 end) * 100.0/ count(o.order_id),2) as decimal(10,2)) as late_rate_percent
from olist_order_items_dataset as o
join olist_sellers_dataset as os
on o.seller_id = os.seller_id
join olist_products_dataset as p
on o.product_id = p.product_id
join product_category_name_translation as t
on p.product_category_name = t.product_category_name
join olist_orders_dataset as oi
on o.order_id = oi.order_id
where oi.order_status = 'delivered'
and oi.order_delivered_customer_date is not null
group by os.seller_state,t.product_category_name_english
order by late_orders desc