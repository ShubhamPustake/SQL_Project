# SQL Retail Database Project
create Database SQL_Project;
USE SQL_Project;

#Create table reatil sales
DROP table if exists retail_sales;
create table retail_sales(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time	TIME,
	customer_id	INT,
	gender	VARCHAR(10),
	age	INT,
	category VARCHAR(12),	
	quantity	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,
	total_sale FLOAT
);

#change name of column
alter table retail_sales
RENAME column quantiy to quantity;

#Data Understanding
select * from retail_sales;

#Checking Null values
select * from retail_sales where transactions_id IS NULL;

select * from retail_sales 
where 	transactions_id IS NULL or
		sale_date IS NULL or
		sale_time IS NULL or
		customer_id IS NULL or 
        gender IS NULL or
		age IS NULL or
		category IS NULL or
        quantity IS NULL or
		price_per_unit IS NULL or
		cogs IS NULL or
		total_sale IS NULL;

# Removing null values
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;    
    
# Data Exploration
# How many sales we have ?
    select count(*) as total_sales from retail_sales;
    
# How many unique customers we have ?
 select count(DISTINCT customer_id) as total_customer from retail_sales;
 
 # How many unique category we have ?
 select count(DISTINCT category) as unique_category from retail_sales;
 
# Data Analysis
# 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date='2022-11-05';

#total count of sales made on 2022-11-05
select count(*) as total_sale from retail_sales where sale_date='2022-11-05';
 
# 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity>=4;

# 3. Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale) as total_sale_per_category
from retail_sales
group by Category;

# 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
category,
avg(age) as avg_age 
from retail_sales where category="Beauty"
group by category ;

SELECT 
    AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


# 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000 
;

# 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
category ,gender,
count(distinct transactions_id) 
from retail_sales
group by category,gender;

# 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT 
year(sale_date)as YEAR,
month(sale_date) as MONTH,
avg(total_sale) as total_sale
from retail_sales
group by year(sale_date), month(sale_date)
order by YEAR, MONTH
;

SELECT 
    year,
    month,
    avg_monthly_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        avg(total_sale) AS avg_monthly_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) ranked_sales
WHERE rnk = 1
ORDER BY year;

# 8. Write a SQL query to find the top 5 customers based on the highest total sales.
select 
	customer_id , 
    sum(total_sale) as total_sale
from retail_sales
group by 1 
order by 2 DESC LIMIT 5;

# 9. Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id) as unique_customer
from retail_sales
group by category;

#10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
as
(
select *,
	CASE 
    #converted time into Hour
		WHEN Hour(sale_time) < 12 THEN 'Morning' 
		WHEN Hour(sale_time) between 12 and 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
from retail_sales 
)
select 
shift,
count(*) as orders from hourly_sale
Group by shift
;










