CREATE TABLE IF NOT EXISTS d_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_breed (
    id SERIAL PRIMARY KEY,
    breed_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_type (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_day (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS d_month (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS d_time (
    id SERIAL PRIMARY KEY,
    date DATE,
    day_id INT,
    month_id INT,
    year INT,
    FOREIGN KEY (day_id) REFERENCES d_day(id),
    FOREIGN KEY (month_id) REFERENCES d_month(id)
);

CREATE TABLE IF NOT EXISTS d_pet (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    type_id INT,
    breed_id INT,
    FOREIGN KEY (type_id) REFERENCES d_type(id),
    FOREIGN KEY (breed_id) REFERENCES d_breed(id)
);

CREATE TABLE IF NOT EXISTS d_customer (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INTEGER,
    email VARCHAR(100),
    country_id INT,
    postal_code VARCHAR(100),
    pet_id INT,
    FOREIGN KEY (country_id) REFERENCES d_country(id),
    FOREIGN KEY (pet_id) REFERENCES d_pet(id)
);

CREATE TABLE IF NOT EXISTS d_seller (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    country_id INT,
    postal_code VARCHAR(100),
    FOREIGN KEY (country_id) REFERENCES d_country(id)
);

CREATE TABLE IF NOT EXISTS d_product_category (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_product_color (
    id SERIAL PRIMARY KEY,
    color VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_pet_category (
    id SERIAL PRIMARY KEY,
    pet_category VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_product_brand (
    id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category_id INT,
    price NUMERIC(10, 3),
    quantity INT,
    pet_category_id INT,
    weight NUMERIC(10, 2),
    color_id INT,
    size VARCHAR(10),
    brand_id INT,
    material VARCHAR(15),
    description TEXT,
    rating NUMERIC(10, 2),
    reviews INT,
    release_date_id INT,
    expire_date_id INT,
    FOREIGN KEY (category_id) REFERENCES d_product_category(id),
    FOREIGN KEY (pet_category_id) REFERENCES d_pet_category(id),
    FOREIGN KEY (color_id) REFERENCES d_product_color(id),
    FOREIGN KEY (brand_id) REFERENCES d_product_brand(id),
    FOREIGN KEY (release_date_id) REFERENCES d_time(id),
    FOREIGN KEY (expire_date_id) REFERENCES d_time(id)
);

CREATE TABLE IF NOT EXISTS d_city (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS d_store (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(200),
    city_id INT,
    state VARCHAR(20),
    country_id INT,
    phone VARCHAR(15),
    email VARCHAR(20),
    FOREIGN KEY (city_id) REFERENCES d_city(id),
    FOREIGN KEY (country_id) REFERENCES d_country(id)
);

CREATE TABLE IF NOT EXISTS d_supplier (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    email VARCHAR(20),
    phone VARCHAR(15),
    address VARCHAR(20),
    city_id INT,
    country_id INT,
    FOREIGN KEY (city_id) REFERENCES d_city(id),
    FOREIGN KEY (country_id) REFERENCES d_country(id)
);


CREATE TABLE IF NOT EXISTS f_sale (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    date_id INT,
    seller_id INT,
    product_id INT,
    store_id INT,
    supplier_id INT,
    quantity INT,
    total_price NUMERIC(10, 2),
    FOREIGN KEY (customer_id) REFERENCES d_customer(id),
    FOREIGN KEY (seller_id) REFERENCES d_seller(id),
    FOREIGN KEY (product_id) REFERENCES d_product(id),
    FOREIGN KEY (date_id) REFERENCES d_time(id),
    FOREIGN KEY (store_id) REFERENCES d_store(id),
    FOREIGN KEY (supplier_id) REFERENCES d_supplier(id)
);
