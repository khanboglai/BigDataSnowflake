INSERT INTO d_month (name)
VALUES 
    ('January'),
    ('February'),
    ('March'),
    ('April'),
    ('May'),
    ('June'),
    ('July'),
    ('August'),
    ('September'),
    ('October'),
    ('November'),
    ('December');

INSERT INTO d_day (name)
VALUES
    ('Monday'),
    ('Tuesday'),
    ('Wednesday'),
    ('Thursday'),
    ('Friday'),
    ('Saturday'),
    ('Sunday');

-- get unique data about pet's breed
INSERT INTO d_breed (breed_name)
SELECT DISTINCT customer_pet_breed
FROM mock_data
WHERE customer_pet_breed IS NOT NULL;


-- get city's name from store column and supplier column
with sub1 as (
	select distinct store_city as city
	from mock_data
),

sub2 as (
	select distinct supplier_city as city
	from mock_data
),

sub3 as (
	select city
	from sub1 
	union 
	select city
	from sub2
)

INSERT INTO d_city (name)
select distinct * FROM sub3 
WHERE city is not null; 


-- pet type extract
insert into d_type (type_name)
select distinct customer_pet_type
from mock_data
where customer_pet_type is not null;


-- get pet info
insert into d_pet (name, type_id, breed_id)
select 
	data.customer_pet_name,
	(select id from d_type where type_name = data.customer_pet_type),
	(select id from d_breed where breed_name = data.customer_pet_breed)
from mock_data as data
where data.customer_pet_name is not null;


-- get time info
with sub as (
	select sale_date as date
	from mock_data
	union
	select product_release_date as date from mock_data 
	union 
    select product_expiry_date as date from mock_data
)

insert into d_time (date, day_id, month_id, year)
select distinct date,
	extract (DOW from date) + 1,
	extract (month from date),
	extract (year from date)
from sub;	


-- pet category
insert into d_pet_category (pet_category)
select distinct pet_category
from mock_data
where pet_category is not null;


-- get country
with cntr as (
	select customer_country as country
	from mock_data
	union
	select seller_country as country
	from mock_data
	union
	select store_country as country
	from mock_data
	union
	select supplier_country as country
	from mock_data
)

insert into d_country (name)
select distinct country
from cntr
where country is not null;


-- get product color
insert into d_product_color (color)
select distinct product_color
from mock_data
where product_color is not null;

