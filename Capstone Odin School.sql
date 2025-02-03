create database Amazon;
use Amazon;
select * from amazon_data_odin_capstoneproject;
ALTER TABLE amazon_data_odin_capstoneproject
ADD COLUMN timeofday VARCHAR(20);

UPDATE amazon_data_odin_capstoneproject
SET timeofday = 
    CASE 
        WHEN EXTRACT(HOUR FROM time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM time) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night' -- optional if you want to include night transactions
    END;
Alter table amazon_data_odin_capstoneproject
ADD column dayname varchar(10);
Update amazon_data_odin_capstoneproject
SET dayname = DAYNAME(date);
UPDATE amazon_data_odin_capstoneproject
SET date = STR_TO_DATE(date, '%d-%m-%Y');
UPDATE amazon_data_odin_capstoneproject
SET time = STR_TO_DATE(date, '%d-%m-%Y');
Describe amazon_data_odin_capstoneproject;
Alter table amazon_data_odin_capstoneproject
ADD column monthname varchar(10);
Update amazon_data_odin_capstoneproject
SET monthname = monthname(date);

ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `Invoice Id` Invoice_ID VARCHAR(50);
ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `Customer type` Customer_type VARCHAR(25);
ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `Product line` Product_line VARCHAR(25);
ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `Unit price` Unit_price double;
ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `Tax 5%` Tax_5percent double;
ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `gross margin percentage` gross_margin_percentage double;
ALTER TABLE amazon_data_odin_capstoneproject 
CHANGE COLUMN `gross income` gross_income double;


-- questions to solve
-- 1.What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT (city)) AS Distinct_Cities
FROM amazon_data_odin_capstoneproject;
SELECT DISTINCT (city) AS Distinct_Cities
FROM amazon_data_odin_capstoneproject;


-- 2.For each branch, what is the corresponding city?
SELECT DISTINCT Branch,City
FROM amazon_data_odin_capstoneproject;

-- 3.What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT(product_line)) AS Distinct_productlines
FROM amazon_data_odin_capstoneproject;
SELECT DISTINCT(product_line) AS Distinct_productlines
FROM amazon_data_odin_capstoneproject;

-- 4.Which payment method occurs most frequently?
SELECT payment,COUNT(payment) AS Frequency_of_paymentmethod
FROM amazon_data_odin_capstoneproject
GROUP BY payment
ORDER BY Frequency_of_paymentmethod desc;

-- 5.Which product line has the highest sales?
SELECT product_line,ROUND(SUM(total)) AS Sales
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY Sales DESC;

-- 6.How much revenue is generated each month?
SELECT monthname,ROUND(SUM(total)) AS totalsales
FROM amazon_data_odin_capstoneproject
GROUP BY monthname
ORDER BY totalsales DESC;

-- 7.In which month did the cost of goods sold reach its peak?
SELECT monthname,ROUND(SUM(cogs)) AS cost_of_goods_sold
FROM amazon_data_odin_capstoneproject
GROUP BY monthname
ORDER BY cost_of_goods_sold DESC;

-- 8.Which product line generated the highest revenue?
SELECT product_line,ROUND(SUM(total),2) AS Revenue
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY revenue desc;

-- 9.In which city was the highest revenue recorded?
SELECT City,ROUND(SUM(total)) AS City_with_highest_sales
FROM amazon_data_odin_capstoneproject
GROUP BY City
ORDER BY City_with_highest_sales desc; 

-- 10.Which product line incurred the highest Value Added Tax?
SELECT product_line,ROUND(SUM(Tax_5percent)) AS Value_added_Tax
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY Value_added_Tax DESC;

-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
ALTER table amazon_data_odin_capstoneproject
ADD column Sales_Type varchar(6);

SELECT product_line,AVG(total) AS Avg_sales
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY Avg_sales DESC;

WITH AvgSales AS (
    SELECT 
        product_line, 
        AVG(total) AS Avg_sales
    FROM 
        amazon_data_odin_capstoneproject
    GROUP BY 
        product_line
)


UPDATE amazon_data_odin_capstoneproject
SET Sales_Type = CASE
    WHEN total > (SELECT Avg_sales 
                  FROM AvgSales 
                  WHERE AvgSales.product_line = amazon_data_odin_capstoneproject.product_line) THEN 'Good'
    ELSE 'Bad'
END;
SELECT sales_type,COUNT(Sales_type) AS count
FROM amazon_data_odin_capstoneproject
GROUP BY sales_type;
-- 12.Identify the branch that exceeded the average number of products sold.
SELECT product_line,SUM(quantity) Products_sold
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY products_sold desc;

SELECT product_line,Avg(quantity) avgProducts_sold
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY avgproducts_sold desc;

SELECT product_line, 
       SUM(quantity) AS total_quantity, 
       COUNT(*) AS row_count, 
       AVG(quantity) AS average_quantity
FROM amazon_data_odin_capstoneproject
GROUP BY product_line;

-- 13.Which product line is most frequently associated with each gender?
WITH GenderProductCount AS (
    SELECT 
        gender,
        product_line,
        COUNT(*) AS product_count
    FROM amazon_data_odin_capstoneproject
    GROUP BY gender, product_line
)
SELECT 
    gender,
    product_line,
    product_count
FROM GenderProductCount;
/*WHERE (gender, product_count) IN (
    SELECT 
        gender,
        MAX(product_count)
    FROM GenderProductCount
    GROUP BY gender
);*/

-- 14.Calculate the average rating for each product line.
SELECT product_line,ROUND(AVG(rating),2) as Avg_rating
FROM amazon_data_odin_capstoneproject
GROUP BY product_line
ORDER BY Avg_rating desc;

-- 15.Count the sales occurrences for each time of day on every weekday.

SELECT 
    dayname,
    timeofday,
    COUNT(*) AS sales_count
FROM amazon_data_odin_capstoneproject
GROUP BY dayname, timeofday
ORDER BY FIELD(dayname, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), 
         FIELD(timeofday, 'Morning', 'Afternoon', 'Evening', 'Night');


-- 16.Identify the customer type contributing the highest revenue.
SELECT customer_type,ROUND(SUM(total)) AS Revenue_generating
FROM amazon_data_odin_capstoneproject
GROUP BY customer_type;

-- 17.Determine the city with the highest VAT percentage.
SELECT city,ROUND(SUM(tax_5percent),2) AS value_added_tax_percent
FROM amazon_data_odin_capstoneproject
GROUP BY city
ORDER BY value_added_tax_percent desc;

SELECT 
    city,
    SUM(tax_5percent) / SUM(total) * 100 AS VAT_percentage
FROM 
    amazon_data_odin_capstoneproject
GROUP BY 
    city
ORDER BY 
    VAT_percentage DESC;

-- 18.Identify the customer type with the highest VAT payments.
SELECT customer_type,ROUND(SUM(tax_5percent)) AS VAT_payments
FROM amazon_data_odin_capstoneproject
GROUP BY customer_type;

-- 19.What is the count of distinct customer types in the dataset?
SELECT customer_type,COUNT(customer_type) AS Count_of_customer_type
FROM amazon_data_odin_capstoneproject
GROUP BY customer_type;

-- 20.What is the count of distinct payment methods in the dataset?
SELECT Payment,COUNT(payment) AS Count_of_payment
FROM amazon_data_odin_capstoneproject
GROUP BY payment;

-- 21.Which customer type occurs most frequently?
SELECT 
    customer_type,
    COUNT(*) AS frequency
FROM 
    amazon_data_odin_capstoneproject
GROUP BY 
    customer_type
ORDER BY 
    frequency DESC;
    

-- 22.Identify the customer type with the highest purchase frequency.
SELECT 
    customer_type,
    ROUND(SUM(TOTAL),2) AS purchasing_frequency
FROM 
    amazon_data_odin_capstoneproject
GROUP BY 
    customer_type
ORDER BY 
    purchasing_frequency DESC;

-- 23.Determine the predominant gender among customers.
SELECT gender,count(gender)  AS Gender_count
FROM amazon_data_odin_capstoneproject
GROUP BY gender;

-- 24.Examine the distribution of genders within each branch.
SELECT 
    branch,gender,
    COUNT(gender) AS Gender_count
FROM 
    amazon_data_odin_capstoneproject
GROUP BY 
    gender,branch;

-- 25.Identify the time of day when customers provide the most ratings.
SELECT timeofday,COUNT(rating) AS Ratings_count
FROM amazon_data_odin_capstoneproject
GROUP BY timeofday
ORDER BY Ratings_count desc;

-- 26.Determine the time of day with the highest customer ratings for each branch.
SELECT branch,timeofday,COUNT(rating) AS Ratings_count
FROM amazon_data_odin_capstoneproject
GROUP BY timeofday,branch
ORDER BY Ratings_count desc;

-- 27.Identify the day of the week with the highest average ratings.
SELECT dayname,ROUND(avg(rating),2) AS avg_ratings
FROM amazon_data_odin_capstoneproject
GROUP BY dayname
ORDER BY avg_ratings DESC;

-- 28.Determine the day of the week with the highest average ratings for each branch.
SELECT branch,dayname,ROUND(avg(rating),2) AS avg_ratings
FROM amazon_data_odin_capstoneproject
GROUP BY dayname,branch
ORDER BY avg_ratings,branch DESC;


-- Extra
-- Branch count
SELECT count(DISTINCT(branch)) AS Distinct_Branch_count
FROM amazon_data_odin_capstoneproject;

-- Branches
SELECT DISTINCT(branch) AS Distinct_Branch
FROM amazon_data_odin_capstoneproject;

