---data verifying
select *
from online_sales.dbo.customer
---data verifying
select *
from online_sales.dbo.product
---total_amount by payments method
SELECT
    payment_method,
    SUM(total_amount) AS total_amount_by_different_method
FROM
	online_sales.dbo.product
GROUP BY
    payment_method
ORDER BY
    total_amount_by_different_method DESC;

---total sales by each product category
SELECT
    product_category,
    sum(quantity) as total_sales
FROM
    online_sales.dbo.product
GROUP BY
    product_category
ORDER BY
     total_sales DESC
    
---the total sales and the number of transactions in each year
SELECT
      year,
      SUM(quantity) AS Total_sales,
      count(transaction_id) as Transaction_each_year
FROM
    online_sales.dbo.product
GROUP BY 
    year 
---the sales figures vary by month and day of the week
SELECT
    week_of_the_day,
    sum(quantity) as total_sales,
    DATEPART(MONTH, date) as month
FROM 
    online_sales.dbo.product
GROUP BY
    DATEPART(MONTH, date),week_of_the_day
---the average transaction value
SELECT
      (total_sales / Total_transaction) as transaction_value
FROM
      (SELECT
          sum(quantity) as total_sales,
          count(transaction_id) as Total_transaction
      FROM
           online_sales.dbo.product
      )as transction

---the demographic profile of customers (age, gender, location)
SELECT
    customer_age,
    customer_gender,
    customer_location
FROM
    online_sales.dbo.customer
---the average spending differ across different age groups and genders
SELECT
     c.customer_age,c.customer_gender,
     avg(total_amount) as avg_spending
FROM
    online_sales.dbo.product p left join online_sales.dbo.customer c on p.transaction_id=c.transaction_id 
GROUP BY
     c.customer_age,c.customer_gender  
---locations have the highest number of customers
SELECT
      COUNT(DISTINCT(customer_id))AS total_customer,
      customer_location
FROM 
    online_sales.dbo.customer
GROUP BY 
       customer_location
ORDER BY
      total_customer DESC
---product categories are the most and least popular in terms of sales volume and revenue?
WITH product_summary AS (
    SELECT
        product_category,
        SUM(total_amount) AS revenue,
        SUM(quantity) AS total_sales
    FROM
        online_sales.dbo.product
    GROUP BY
        product_category
)
SELECT
    (SELECT Top 1
		product_category
     FROM product_summary
     ORDER BY revenue DESC
     ) AS most_revenued_product_category,
    (SELECT Top 1
		product_category
     FROM product_summary
     ORDER BY revenue ASC
     ) AS least_revenued_product_category,
    (SELECT Top 1
		product_category
     FROM product_summary
     ORDER BY total_sales DESC
     ) AS most_soled_product_category,
    (SELECT Top 1
		product_category
     FROM product_summary
     ORDER BY total_sales ASC
     ) AS least_soled_product_category;

---the sales of different products vary by time of day and date
SELECT
  sum(quantity) AS Total_quantity_soled,
  sum(total_amount) AS Total_amount,
  product_category,
  date as sales_date,
  DATEPART(hour,time) as sales_hour
FROM 
  online_sales.dbo.product
GROUP BY
  product_category,
  date,
  time
order by
  sales_hour,
  sales_date
  ---what is the average discount offered on different product categories
select
	product_category,
	avg(discount) as avg_discount
from
	online_sales.dbo.product
group by product_category
---the application of discounts affect the overall profitability
select
	total_revenue_with_discount,
	total_revenue_without_discount,
	(total_revenue_without_discount-total_revenue_with_discount) as total_discount_amount
from
	(select 
			sum(total_amount) as total_revenue_with_discount,
			sum(quantity *price) as total_revenue_without_discount
	 from
			online_sales.dbo.product
) as revenue_details;.
---Are there any seasonal trends or patterns in sales for different product categories
select 
	product_category,
	YEAR(date) as year,
	case 
		when MONTH(date) in (12,1,2) THEN 'Winter'
		when MONTH(date) in (3,4,5) THEN 'Spring'
		When MONTH(date) in (6,7,8) THEN 'Summer'
		when MONTH(date) in (9,10,11) THEN 'Fall'
	end as season,
	sum(quantity) as total_sales
from 
	online_sales.dbo.product
group by 
	product_category,
	YEAR(date) ,
	case 
		when MONTH(date) in (12,1,2) THEN 'Winter'
		when MONTH(date) in (3,4,5) THEN 'Spring'
		When MONTH(date) in (6,7,8) THEN 'Summer'
		when MONTH(date) in (9,10,11) THEN 'Fall'
	end
order by 
	YEAR(date) ,
	case 
		when MONTH(date) in (12,1,2) THEN 'Winter'
		when MONTH(date) in (3,4,5) THEN 'Spring'
		When MONTH(date) in (6,7,8) THEN 'Summer'
		when MONTH(date) in (9,10,11) THEN 'Fall'
	end

---do holidays and special events impact sales figures
SELECT 
	product_category,
	CASE
		when week_of_the_day in ('Sunday','Saturday') THEN 'Holiday'
		when week_of_the_day in ('Monday','Tuesday') THEN 'first_two_days'
		when week_of_the_day in ('Wednesday','Thursday','Friday') THEN 'Mid_week_days'
	end as holidays,
	case 
		when MONTH(date) in (12,1,2) THEN 'Winter'
		when MONTH(date) in (3,4,5) THEN 'Spring'
		When MONTH(date) in (6,7,8) THEN 'Summer'
		when MONTH(date) in (9,10,11) THEN 'Fall'
	end as season,
	sum(quantity) as total_sales
FROM 
	online_sales.dbo.product
group by
	product_category,
	case 
		when week_of_the_day in ('Sunday','Saturday') THEN 'Holiday'
		when week_of_the_day in ('Monday','Tuesday') THEN 'first_two_days'
		when week_of_the_day in ('Wednesday','Thursday','Friday') THEN 'Mid_week_days'
	end,
	case 
		when MONTH(date) in (12,1,2) THEN 'Winter'
		when MONTH(date) in (3,4,5) THEN 'Spring'
		When MONTH(date) in (6,7,8) THEN 'Summer'
		when MONTH(date) in (9,10,11) THEN 'Fall'
	end 
ORDER BY total_sales desc,
	CASE
		when week_of_the_day in ('Sunday','Saturday') THEN 'Holiday'
		when week_of_the_day in ('Monday','Tuesday') THEN 'first_two_days'
		when week_of_the_day in ('Wednesday','Thursday','Friday') THEN 'Mid_week_days'
	end,
	case 
		when MONTH(date) in (12,1,2) THEN 'Winter'
		when MONTH(date) in (3,4,5) THEN 'Spring'
		When MONTH(date) in (6,7,8) THEN 'Summer'
		when MONTH(date) in (9,10,11) THEN 'Fall'
	end 


