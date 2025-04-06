-- count lines of breed data
select count(customer_pet_breed)
from mock_data
where customer_pet_breed is not null;


-- анализируем данные по месяцам, тут все как с id в таблицах d_day, d_month
with sub as (
	select sale_date as date
	from mock_data
	union
	select product_release_date as date from mock_data 
	union select product_expiry_date as date from mock_data
)

select distinct sub.date,
	extract(DOW from sub.date) + 1 as day,
	extract(month from sub.date) as month,
	extract(year from sub.date) as year
from sub;