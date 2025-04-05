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