create database WalmartSales;

use WalmartSales;

create table sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(20) not null,
customer_type varchar(20) not null,
gender varchar(20) not null,
product_line varchar(30) not null,
unit_price decimal(10,2) not null,
quantity int not null,
tax_pct float not null,
total float not null,
Dates date not null,
Time time not null,
payment varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float ,
gross_income decimal(12,6),
rating decimal(2,1)
);

select * from sales;

                               #DATA CLEANING

# Add the time_of_day column
select Time,
(case when Time between "00:00:00" and "12:00:00" then "Morning"
when Time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end) as time_of_day from  sales;

alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day=(case
when Time between "00:00:00" and "12:00:00" then "Morning"
when Time between "12:00:01" and "16:00:00" then "Afternoon"
else "Evening" end );

# Add the day_name column
select Dates, dayname(Dates) from sales;

alter table sales add column day_name varchar(20);

update sales 
set day_name= dayname(Dates);


# Add month_name column
select Dates,monthname(Dates) from sales;

alter table sales add column month_name varchar(20);

update sales 
set month_name=monthname(Dates);



                           #General questions#

#1.How many unique cities does the data have?
select distinct city from sales;

#2.In which city is each branch?
select distinct city,branch from sales ;

                           #Question on Products#

#1.How many unique product lines does the data have?
select distinct product_line from sales;

#2.What is the most selling product line?

select product_line,sum(quantity) as Qty from sales 
group by product_line
order by Qty desc;

#3.What is the total revenue by month?
select month_name as month,sum(total) as total_revenue from sales 
group by month_name order by total_revenue desc;


#4.What month had the largest COGS?
select month_name as month,sum(cogs) as cogs from sales 
group by month order by cogs desc;

#5.What product line had the largest revenue?
select product_line,sum(total) as total_revenue from sales
group by product_line
order by total_revenue desc;

#6.What is the city with the largest revenue?
select city,sum(total) as total_revenue from sales
group by city
order by total_revenue desc;

#7.What product line had the largest tax %?
select product_line, avg(tax_pct) as avg_tax from sales
group by product_line
order by avg_tax desc;

#8.Fetch each product line and add a column to those product line 
# showing "Good", "Bad". Good if its greater than average sales

select avg(quantity) from sales;
 
 select product_line,case
 when avg(quantity)>5.49 then "Good"
 else "Bad" end as remark 
 from sales
 group by product_line ;
 
 #9.Which branch sold more products than average product sold?
 
 select branch,avg(quantity) from sales 
 group by branch
 having avg(quantity)>(select avg(quantity) from sales);
 
#10.What is the most common product line by gender?

 SELECT
    product_line,
    gender,
    COUNT(gender) AS count
FROM sales
GROUP BY product_line, gender
ORDER BY gender, count DESC;


#11.What is the average rating of each product line?

select product_line,round(avg(rating),2) as avg_rating from sales
group by product_line;


                           #Question on Customers#
#1.How many unique customer types does the data have?
select 
       distinct customer_type 
from sales;

#2.How many unique payment methods does the data have?
select 
	 distinct payment 
from sales;

#3.What is the most common customer type?
select 
      customer_type,
      count(customer_type) as total_count
from sales
group by customer_type
order by total_count desc;

#4.Which customer type buys the most?
select 
      customer_type,
      count(quantity) as total_count
from sales
group by customer_type;

#5.What is the gender of most of the customers?
select 
      gender,
      count(gender) as count
from sales 
group by gender 
order by count desc ;

#6.What is the gender distribution per branch?
select
      branch,
      gender,
      count(gender) as count
from sales
group by branch,gender
order by branch;

#7.Which time of the day do customers give most ratings?
select       
     time_of_day as time_of_the_day,
     round(avg(rating),2) as avg_rating 
from sales 
group by time_of_day
order by avg_rating desc;

#8.Which time of the day do customers give most ratings per branch?
select     
     branch,  
     time_of_day as time_of_the_day,
     round(avg(rating),2) as avg_rating 
from sales 
group by branch,time_of_day
order by branch,avg_rating desc;

#9.Which day fo the week has the best avg ratings?
select 
      day_name,
      avg(rating) as  avg_rating
from sales
group by day_name
order by avg_rating desc;

#10.Which day of the week has the best average ratings per branch?
select 
      branch,
      day_name,
      avg(rating) as  avg_rating
from sales
group by branch,day_name
order by avg_rating desc,branch;


                           #Question on Sales#
#1.Number of sales made in each time of the day per weekday ?

select  
      count(quantity) as no_of_sales,
      time_of_day,
      day_name
from sales
group by time_of_day,day_name
order by no_of_sales desc;
      
#2.Which of the customer types brings the most revenue?
select 
     customer_type,
     round(sum(total),2) as revenue
from sales
group by customer_type
order by revenue desc;

#3,Which city has the largest tax percent?
select 
     city,
     round(avg(tax_pct),2) as tax_pct
from sales
group by city
order by tax_pct desc;

#4.Which customer type pays the most in tax?
SELECT 
     customer_type,
     round(avg(tax_pct),2) as tax_pct
from sales
group by customer_type
order by tax_pct desc;
