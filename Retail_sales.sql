create table retail_sale
(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id	int not null,
gender varchar(10) not null,
age int not null,	
category	varchar(20),
quantiy int not null,
price_per_unit money, 
cogs float, 
total_sale int
)


select count(*) from Retail_sales -- total 1986 records
-- null values to clean the data
select * from retail_sale
where transactions_id is null
		or sale_date is null
		or sale_time is null
		or customer_id is null
		or gender is not null
		or age is null
		or category is null
		or quantity is null
		or price_per_unit is null
		or cogs is null
		or total_sale is null 

-- problem solving
/* Q.1 Write a SQL query to retrieve all columns for sales
made on '2022-11-05*/
select * from retail_sale
where sale_date = '2022-11-05'


/* Q.2 Write a SQL query to retrieve all transactions where the 
category is 'Clothing' and the quantity sold is more than 4 in 
the month of Nov-2022 */
select * from retail_sale
where category = 'Clothing'
			and
			to_char(sale_date,'YYYY-MM')= '2022-11'
			and
			quantity >= 4

			
/* Q.3 Write a SQL query to calculate the total sales (total_sale)
for each category.*/
select category, sum(total_sale), count(*) from retail_sale
group by 1

/* Q.4 Write a SQL query to find the average age of customers
who purchased items from the 'Beauty' category.*/
select category, avg(age) as avg_age from retail_sale
where category =  'Beauty'
group by 1


/* Q.5 Write a SQL query to find all transactions where the total_sale
is greater than 1000.*/
select * from retail_sale
where total_sale > 1000


/*Q.6 Write a SQL query to find the total number of transactions 
(transaction_id) made by each gender in each category.*/
select gender,category,count(transactions_id) as total_transactions
from retail_sale
group by 1,2


/* Q.7 Write a SQL query to calculate the average sale for each month. 
Find out best selling month in each year */
select year, month, avg_sale
from
(select extract(month from sale_date) as month,
		extract (year from sale_date) as year,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) 
			order by avg(total_sale)desc) as rank
from retail_sale
group by 1,2)
as t1
where rank = 1


/* Q.8 Write a SQL query to find the top 5 customers based on the
highest total sales */
select * from retail_sale
select customer_id, sum(total_sale) as highest_Sale from retail_sale
group by customer_id
order by 2 desc
limit 5


/*Q.9 Write a SQL query to find the number of unique customers 
who purchased items from each category.*/
select  category, count(customer_id)
from retail_sale
group by category


/*Q.10 Write a SQL query to create each shift and number of orders 
(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)*/
with hourly_sale as
(
select *,
		case when extract(hour from sale_time) <=12 then 'Morning'
		when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
		end as shift
from retail_sale
)
select shift, count(transactions_id)
from hourly_sale
group by 1