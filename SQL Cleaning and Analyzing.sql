#Create Database

create database RetailsalesDB;
Use Retailsales;
############################################    
#IMPORTING DATA

/* IMPORT csv file into SQL 
Right click on database name on schemas wizard and then select table data import wizard option and create table option there */

#checking the imported data
SELECT * 
FROM RetailSales
ORDER BY OrderID ASC;
select count(*) from RetailSales;

###########################################################
#CLEANING AND TRANSFORMING DATA

#Removing duplicates in order_id row
CREATE TABLE RetailSales_Clean AS
SELECT DISTINCT OrderID, OrderDate, CustomerName, Region, Product, Quantity, Sales, Profit
FROM RetailSales;

#fix date formatting
UPDATE RetailSales_Clean
SET OrderDate = STR_TO_DATE(OrderDate, '%d/%m/%Y')
WHERE OrderDate LIKE '%/%/%';
SELECT COUNT(*) FROM RetailSales_Clean where OrderDate Like '____-__-__';


#replace missing customer names with placeholder
SET SQL_SAFE_UPDATES = 0;

UPDATE RetailSales_Clean
SET CustomerName = 'Unknown'
WHERE CustomerName IS NULL OR TRIM(CustomerName) = '';
select *from RetailSales_Clean where CustomerName='Unknown';

#standardizing region names and replacing empty cells with placeholder
UPDATE RetailSales_Clean
SET Region = CASE
    WHEN TRIM(Region) IN ('Andhra Pradesh', 'AP', 'Andhrapradesh') THEN 'AP'
    WHEN Region is null or Trim(Region)='' THEN 'NA'
    Else Region END;
select *from RetailSales_Clean where Region = 'NA';

#Fixing text noise
UPDATE RetailSales_Clean
SET Product = CONCAT(UPPER(LEFT(TRIM(Product), 1)), LOWER(SUBSTRING(TRIM(Product), 2)));

#updating missing/negative in profit
Alter table RetailSales_Clean modify profit varchar(20);
UPDATE RetailSales_Clean
SET Profit = '0'
WHERE Profit IS NULL OR Profit='' or Profit < 0;
Alter table RetailSales_Clean modify profit int;
select *from RetailSales_Clean where Profit=0;

#modifying extreme high values
UPDATE RetailSales_Clean
Set sales= Case 
When sales>100000 then sales=0 else sales
end;

#Checking the cleaned data
select *from RetailSales_Clean;



