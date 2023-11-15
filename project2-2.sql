select FORMAT_DATE('%Y-%m', DATE (ordi.created_at))||'-'|| '01' as month,
extract (year from ord.created_at) as year,
pd.category as product_category,
cast(sum(ordi.sale_price) as int) as tpv,
count(ordi.order_id) as tpo,
round(100 * (sum(ordi.sale_price) - lag(sum(ordi.sale_price)) over(partition by 1,2 order by 1,2 ))/lag(sum(ordi.sale_price)) over(partition by 1,2 order by 1,2 ),2)||'%' as Revenue_growth,
round(100 * (count(ordi.order_id) -lag(count(ordi.order_id)) over(partition by 1,2 order by 1,2))/lag(count(ordi.order_id)) over(partition by 1,2 order by 1,2),2)||'%' as Order_growth,
cast(sum(pd.cost) as int) as total_cost,
cast(sum(ordi.sale_price) - sum(pd.cost)as int) as total_profit,
round(sum(ordi.sale_price) / sum(pd.cost),3) as Profit_to_cost_ratio
from bigquery-public-data.thelook_ecommerce.orders ord
join bigquery-public-data.thelook_ecommerce.order_items ordi
on ord.order_id = ordi.order_id
join bigquery-public-data.thelook_ecommerce.products pd
on ordi.product_id = pd.id
group by 1,2,3
order by 1 desc
