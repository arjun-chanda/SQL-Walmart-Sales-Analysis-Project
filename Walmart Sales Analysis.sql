-- creating databse --
CREATE DATABASE Walmartsales;
USE Walmartsales;
-- creating table --
 CREATE TABLE  IF NOT  EXISTS Sales
(
    Invoice_ID VARCHAR(50)  NOT NULL PRIMARY KEY,
	Branch	VARCHAR(10)  NOT NULL,
    City VARCHAR(50)  NOT NULL,
	Customer_type VARCHAR(30)  NOT NULL,
	Gender	VARCHAR(10)  NOT NULL,
    Product_line VARCHAR(80)  NOT NULL,	
    Unit_price	DECIMAL(10,2)  NOT NULL,
    Quantity	INT  NOT NULL,
    Tax_5percenct	FLOAT(6,4)  NOT NULL,
    Total DECIMAL(12,4)  NOT NULL,
    date DATE  NOT NULL,
    time TIME  NOT NULL,
    Payment	VARCHAR(30) NOT NULL,
    cogs DECIMAL(10,2)  NOT NULL,	
    gross_margin_percentage DECIMAL(11,9), 
    gross_income DECIMAL(12,4),	
    Rating DECIMAL(2,1)
    );
    
    ALTER TABLE Sales
    MODIFY COLUMN  time  TIME;

-- ADD the time_of_day Coloumn--
SELECT time,
( CASE
    WHEN `time` BETWEEN "00:00:00" AND "11:59:59" THEN "MORNING"
    WHEN `time` BETWEEN "12:00:00" AND "15:59:59" THEN "AFTERNOON"
    ELSE "EVENING"
END ) AS time_of_day 
FROM Sales;

ALTER TABLE Sales ADD COLUMN  time_of_day VARCHAR(20);



SET SQL_SAFE_UPDATES = 0;

UPDATE Sales
SET time_of_day =( CASE
    WHEN `time` BETWEEN "00:00:00" AND "11:59:59" THEN "MORNING"
    WHEN `time` BETWEEN "12:00:00" AND "15:59:59" THEN "AFTERNOON"
    ELSE "EVENING"
END  
    ); 

--  ADD DAY NAME --

ALTER TABLE Sales ADD COLUMN  day_name VARCHAR(20);

UPDATE Sales
SET day_name = DAYNAME(DATE);

-- ADD MONTH NAME --

ALTER TABLE Sales ADD COLUMN  month_name VARCHAR(20);

UPDATE Sales
SET month_name = MONTHNAME(DATE);

-- -- -- -- Business Solving Questions -- -- -- --
-- -- -- 1. General Questions -- -- --

-- 1.How many unique cities does the data have? --

   SELECT DISTINCT city
   FROM Sales;
   
-- 2.In which city is each branch? --

   SELECT DISTINCT city,branch 
   FROM Sales;

-- Questions related to Products --

-- 1.How many unique product lines does the data have? --

    SELECT DISTINCT Product_line
    FROM Sales;
    
-- 2.What is the most common payment method? --
   
   SELECT Payment,
       COUNT(Payment) AS cpm
	FROM Sales
    GROUP BY Payment 
    Order BY cpm  DESC ;

-- 3.What is the total revenue by month? --

SELECT 
 month_name AS month,
 SUM(Total) As total_revenue
 FROM Sales
 GROUP BY month_name
 ORDER BY total_revenue DESC ;

-- 4.What month had the largest COGS? --

SELECT month_name AS month,
 SUM(cogs) AS cogs
 FROM Sales
 GROUP BY month_name 
 Order BY cogs desc;

-- 5.What product line had the largest revenue? --

SELECT Product_line AS pl,
 SUM(Total) AS total_revenue
 FROM Sales
 GROUP BY Product_line
 Order BY total_revenue desc;

-- 6.What is the city with the largest revenue? --

SELECT City AS cities,
 SUM(Total) AS total_revenue
 FROM Sales
 GROUP BY City
 Order BY total_revenue desc;

-- 7.What product line had the largest VAT? --

SELECT Product_line AS pl,
 AVG(Tax_5percenct) AS avg_vat
 FROM Sales
 GROUP BY Product_line
 Order BY avg_vat desc;
 
-- 8.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales? --

 SELECT 
  AVG(Quantity) AS avg_quty
  FROM Sales;
  
SELECT 
    Product_line,
    CASE 
        WHEN AVG(Quantity) > (SELECT AVG(Quantity) FROM Sales) THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM Sales
GROUP BY Product_line;

-- 9.Which branch sold more products than average product sold? --

SELECT branch,
   SUM(Quantity) AS avg_product_sold
FROM Sales
Group BY branch
HAVING  SUM(Quantity) > (SELECT AVG(Quantity) FROM Sales);

-- 10.What is the most common product line by gender? --

SELECT Gender,
Product_line As pl,
COUNT(Gender) As cpg
From Sales
group by Gender,Product_line
Order by cpg ;

-- 11.What is the average rating of each product line? --

    SELECT Product_line AS pl,
    ROUND(AVG(Rating),2) As avg_rating 
    FROM Sales
    Group By Product_line
    Order BY avg_rating DeSC;
    
-- -- -- Questions related to Sales -- -- --

-- 1.Number of sales made in each time of the day per weekday --
    
    SELECT time_of_day,
    COUNT(*) AS total_sales
    FROM Sales
    WHERE day_name = "Sunday"
    Group BY time_of_day
    Order By total_sales DESC;

-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- 2.Which of the customer types brings the most revenue? --

    SELECT Customer_type,
    SUM(Total) AS most_revenue
    FROM Sales
    Group By Customer_type
    Order BY most_revenue DESC;
    
-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)? --
   
    SELECT City As City,
    ROUND(Avg(Tax_5percenct) ,2)  AS ltp
    FROM Sales
    Group By City 
    Order BY ltp desc;

-- 4.Which customer type pays the most in VAT? --

    SELECT Customer_type ,
     Avg(Tax_5percenct) AS mv 
     FROM Sales
     Group BY Customer_type
     Order BY mv ;
     
	-- -- -- Questions related to Customers -- -- --
 
 -- How many unique customer types does the data have? --
       
   SELECT DISTINCT Customer_type
   FROM Sales;
 
-- How many unique payment methods does the data have? --
  
   SELECT DISTINCT Payment 
   FROM Sales;

-- What is the most common customer type? --
    
    SELECT Customer_type,
      COUNT(*) AS count
    FROM Sales
    Group BY Customer_type 
    Order By count DESC;

-- Which customer type buys the most? --

SELECT
	Customer_type,
    COUNT(*)
FROM sales
GROUP BY Customer_type;

-- What is the gender of most of the customers? --

    SELECT
    Gender,
    COUNT(*) As gen_type
    FROM Sales
    Group By gender
    order By gen_type DESC;

-- What is the gender distribution per branch? --
 
 SELECT
	Gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE Branch = "C"
GROUP BY Gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings? --

    SELECT 
    time_of_day AS tfd,
    AVG(Rating) AS mr
    FROM Sales
    Group  By time_of_day
    Order By mr  desc;

-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch? --
 
 SELECT  Branch,
    time_of_day AS tfd,
    AVG(Rating) AS mr
    FROM Sales
    WHERE Branch = "A"
    Group  By time_of_day
    Order By mr  desc;
    
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day fo the week has the best avg ratings? --
 
 SELECT
	day_name,
	AVG(Rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Mon, Tue and Friday are the top best days for good ratings

-- Which day of the week has the best average ratings per branch? --

SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- PROJECT END --

       


