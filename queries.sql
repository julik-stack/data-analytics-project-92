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

-- отчет о десятке лучших продавцов

6.2.
with t as(
	select 
		CONCAT(e.first_name, ' ', e.last_name) as seller,
		AVG(s.quantity * p.price) AS avg_income
	from sales s
	join employees e 
		on s.sales_person_id = e.employee_id
	join products p 
		on s.product_id = p.product_id 
	group by seller  
)
select 
	seller,
	FLOOR(avg_income) as average_income
from t
where avg_income < (
    select AVG(s.quantity * p.price)
    from sales s
    join products p
        ON s.product_id = p.product_id)
order by average_income asc;

-- 	отчет содержит информацию о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам

6.3.

select 
	CONCAT(e.first_name, ' ', e.last_name) as seller,
	TRIM(TO_CHAR(s.sale_date, 'day')) as day_of_week,
	FLOOR(SUM(s.quantity * p.price)) as income
from sales s
join employees e 
	on s.sales_person_id = e.employee_id
join products p 
	on s.product_id = p.product_id 
group by seller, day_of_week, extract(isodow from s.sale_date)
order by extract(isodow from s.sale_date), seller;

-- отчет содержит информацию о выручке по дням недели

7.1.

	select 
	case 
		when age between 16 and 25 then '16-25'
		when age between 26 and 40 then '26-40'
		when age > 40 then '40+'
	end  as age_category,
	count(*) as age_count
from customers
group by age_category 
order by age_category ;
-- отчет - количество покупателей в разных возрастных группах

7.2.
select 
	to_char(s.sale_date, 'YYYY-MM') as selling_month,
	count(distinct s.customer_id) as total_customer,
	floor(sum(s.quantity * p.price)) as income
from sales s 
join products p 
	on s.product_id = p.product_id
group by selling_month 
order by selling_month asc;

--отчете предоставлены данные по количеству уникальных покупателей и выручке, которую они принесли

7.3.
with t as(	
	select 
		c.customer_id,
		CONCAT(c.first_name, ' ', c.last_name) as customer,
		s.sale_date,
		CONCAT(e.first_name, ' ', e.last_name) as seller,
		p.price,
		row_number() over (
			partition by c.customer_id
			order by s.sale_date, s.sales_id
		)  as rn  
	from sales s
	join employees e 
		on s.sales_person_id = e.employee_id
	join products p 
		on s.product_id = p.product_id
	join customers c 
		on s.customer_id = c.customer_id
)
select
	customer,
	sale_date,
	seller 
from t 
where rn = 1
	and price = 0
order by customer_id;
-- отчет следует составлен о покупателях, первая покупка которых была в ходе проведения акций (акционные товары отпускали со стоимостью равной 0)


