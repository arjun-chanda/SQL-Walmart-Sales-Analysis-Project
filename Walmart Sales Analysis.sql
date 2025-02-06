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


     SELECT * FROM Sales;
   
   SHOW TABLES;
    


