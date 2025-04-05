-- count lines of breed data
select count(customer_pet_breed)
from mock_data
where customer_pet_breed is not null;
