select 
	COUNT(customer_id) as customers_count
from customers;

-- Считает общее количество покупателей в таблице customers
STEP 6

6.1.
	select 
	CONCAT(e.first_name, ' ', e.last_name) as seller,
	count(s.sales_id) as operations,
	FLOOR(SUM(s.quantity * p.price)) as income
from sales s
join employees e 
	on s.sales_person_id = e.employee_id
join products p 
	on s.product_id = p.product_id 
group by seller  
order by income desc
limit 10;

-- соединяем таблицы, собираем фамилию и имя вместе(CONCAT), считаем операции(count), считаем и округляем выручку(FLOOR(SUM)).

6.2.
	
