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

select count(product_brand) from mock_data where product_brand is null;
-- 0

select count(distinct mock_data.store_name) from mock_data; --383
select count(distinct mock_data.store_location) from mock_data; -- 4621


select count(customer_first_name) from mock_data where customer_first_name is null; -- 0
select count(customer_last_name) from mock_data where customer_last_name is null; -- 0

select count(*) from mock_data where id != sale_customer_id;

select count(*) from mock_data where product_material is null;
-- 0

select count(*) from mock_data where product_size is null;
-- 0

select count(*) from mock_data where customer_first_name is null;
-- 0

-- выполним на случай дублирования
delete from d_customer
where ctid not in (
    select min(ctid)
    from d_customer
    group by id
);


-- проверяем, что по продуктам все сошлось
select name, count(name) from d_product GROUP BY name;
-- Cat Toy,3309
-- Bird Cage,3352
-- Dog Food,3339

select product_name, count(product_name) from mock_data GROUP BY product_name;
-- Bird Cage,3352
-- Cat Toy,3309
-- Dog Food,3339


select count(distinct mock_data.sale_customer_id) from mock_data;
-- 1000
select count(distinct mock_data.sale_product_id) from mock_data;
-- 1000
select count(distinct mock_data.sale_seller_id) from mock_data;
-- 1000


select count(distinct mock_data.customer_email) from mock_data;
-- 10000
select count(distinct mock_data.seller_email) from mock_data;
-- 10000
select count(distinct mock_data.supplier_email) from mock_data;
-- 10000

select count(*) from mock_data where sale_date is null;
-- 0