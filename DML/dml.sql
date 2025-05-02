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


-- get product category
insert into d_product_category (category)
select distinct product_category
from mock_data
where product_category is not null;

-- product brand
insert into d_product_brand (brand_name)
select distinct product_brand
from mock_data;

-- product material
insert into d_product_material (material_type)
select distinct product_material
from mock_data;

-- product size
insert into d_product_size (size_type)
select distinct product_size
from mock_data;


-- customers
insert into d_customer (id, first_name, last_name, age, email, country_id, postal_code, pet_id)
select distinct m.id, m.customer_first_name, m.customer_last_name, m.customer_age, m.customer_email,
       c.id as country_id,
       m.customer_postal_code,
       p.id as pet_id
from mock_data m
left join d_country c on c.name = m.customer_country
left join d_type t on t.type_name = m.customer_pet_type
left join d_breed b on b.breed_name = m.customer_pet_breed
left join d_pet p on p.type_id = t.id
                 and p.name = m.customer_pet_name
                 and p.breed_id = b.id;


-- products
insert into d_product (
    name, category_id, price, quantity, pet_category_id, weight, color_id, size_id,
    brand_id, material_id, description, rating, reviews, release_date_id, expire_date_id
)
select distinct
    m.product_name,
    pc.id,
    m.product_price,
    m.product_quantity,
    pet.id,
    m.product_weight,
    col.id,
    ps.id,
    br.id,
    mat.id,
    m.product_description,
    m.product_rating,
    m.product_reviews,
    rel_d.id AS product_release_date_id,
    exp_d.id AS product_expiry_date_id
from mock_data AS m
LEFT JOIN d_product_category AS pc ON pc.category = m.product_category
LEFT JOIN d_pet_category AS pet ON pet.pet_category = m.pet_category
LEFT JOIN d_product_color AS col ON col.color = m.product_color
LEFT JOIN d_product_size AS ps ON ps.size_type = m.product_size
LEFT JOIN d_product_brand AS br ON br.brand_name = m.product_brand
LEFT JOIN d_product_material AS mat ON mat.material_type = m.product_material
LEFT JOIN d_time AS rel_d ON rel_d.date = m.product_release_date
LEFT JOIN d_time AS exp_d ON exp_d.date = m.product_expiry_date;


-- sellers
insert into d_seller (first_name, last_name, email, country_id, postal_code)
select distinct
    m.seller_first_name,
    m.seller_last_name,
    m.seller_email,
    dc.id,
    m.seller_postal_code

from mock_data AS m
left join d_country as dc on dc.name = m.seller_country;


-- stores
insert into d_store (name, location, city_id, state, country_id, phone, email)
select distinct
    m.store_name,
    m.store_location,
    dcity.id,
    m.store_state,
    dcountry.id,
    m.store_phone,
    m.store_email
from mock_data as m
left join d_city as dcity on dcity.name = m.store_city
left join d_country as dcountry on dcountry.name = m.store_country;


--supplier
insert into d_supplier (name, contact, email, phone, address, city_id, country_id)
select distinct
    m.supplier_name,
    m.supplier_contact,
    m.supplier_email,
    m.supplier_phone,
    m.supplier_address,
    dcity.id,
    dcountry.id
from mock_data as m
left join d_city as dcity on dcity.name = m.supplier_city
left join d_country as dcountry on dcountry.name = m.supplier_country;


-- sales
-- проверку на уникальность email у покупателя, продавца и поставщика проверил
insert into f_sale (customer_id, date_id, seller_id, product_id, store_id, supplier_id, quantity, total_price)
select distinct
    dcustom.id,
    dt.id,
    dsel.id,
    dp.id,
    dst.id,
    dsup.id,
    m.sale_quantity,
    m.sale_total_price

from mock_data as m
left join d_customer as dcustom on dcustom.email = m.customer_email
left join d_time as dt on dt.date = m.sale_date
left join d_seller as dsel on dsel.email = m.seller_email
left join d_product as dp
    ON dp.name = m.product_name
    AND dp.category_id = (SELECT pc.id FROM d_product_category AS pc WHERE pc.category = m.product_category)
    AND dp.price = m.product_price
    AND dp.quantity = m.product_quantity
    AND dp.pet_category_id = (SELECT id FROM d_pet_category WHERE pet_category = m.pet_category)
    AND dp.weight = m.product_weight
    AND dp.color_id = (SELECT id FROM d_product_color WHERE color = m.product_color)
    AND dp.size_id = (SELECT id from d_product_size where size_type = m.product_size)
    AND dp.brand_id = (SELECT id FROM d_product_brand WHERE brand_name = m.product_brand)
    AND dp.material_id = (SELECT id FROM d_product_material WHERE material_type = m.product_material)
    AND dp.description = m.product_description
    AND dp.rating = m.product_rating
    AND dp.reviews = m.product_reviews
    AND dp.release_date_id = (SELECT id FROM d_time WHERE date = m.product_release_date)
    AND dp.expire_date_id = (SELECT id FROM d_time WHERE date = m.product_expiry_date)
left join d_store as dst on dst.email = m.store_email
left join d_supplier as dsup on dsup.email = m.supplier_email;
