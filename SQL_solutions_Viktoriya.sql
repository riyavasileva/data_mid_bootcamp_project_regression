#1 Create a database called `house_price_regression`

create database house_price_regression;

#2 Create a table house_price_data with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.

create table house_price_data (
	`id` bigint not null,
	`date` varchar(255) not null,
	`bedrooms` INT not null,
	`bathrooms` varchar(255) not null,
	`sqft_living` INT not null, 
	`sqft_lot` INT not null,
	`floors` varchar(255) not null, 
	`waterfront` int not null,
	`view` INT not null,
	`condition` INT not null,
	`grade` INT not null,
	`sqft_above` INT not null,
	`sqft_basement` INT not null,
	`yr_built` INT not null,
	`yr_renovated` INT not null,
	`zipcode` INT not null,
	`lat` varchar(255) not null,
	`long` varchar(255) not null,
	`sqft_living15` INT not null,
	`sqft_lot15` INT not null,
	`price` int not null,
	PRIMARY KEY (`id`)
);

#Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:

SHOW VARIABLES LIKE 'local_infile';

#3. Import the data into the table (File->Import).

#4. Select all the data from table house_price_data to check if the data was imported correctly

select * from house_price_data

#5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

alter table house_price_data
drop column date;

select * from house_price_data
limit 10;

#6. Use sql query to find how many rows of data you have.

select count(*) from house_price_data;

#7. Find the unique values in some of the categorical columns: bedrooms, bathrooms, floors, condition, grade

select distinct bedrooms as 'bedrooms_unique' from house_price_data;

select distinct bathrooms as 'bathrooms_unique' from house_price_data; 

select distinct floors as 'floors_unique' from house_price_data;

select distinct `condition` as 'condition_unique' from house_price_data;

select distinct grade as 'grade_unique' from house_price_data;

#8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

select id, price from house_price_data
order by price DESC
limit 10;

#9. What is the average price of all the properties in your data?

select round(avg(price),2) from house_price_data;

#10. GROUP BY

#What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.

select bedrooms, round(avg(price),2) as 'average_price' 
from house_price_data
group by bedrooms
order by bedrooms ASC;

#What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.

select bedrooms,round(avg (sqft_living),2) as 'average_sqft_living' 
from house_price_data
group by bedrooms
order by bedrooms ASC;

#What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.

select waterfront,round(avg (price),2) as 'average_price' 
from house_price_data
group by waterfront;

#Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.

select `condition`, avg(grade) as 'average_grade' from house_price_data
group by `condition`
order by `condition`

	#-> A possitive correlation would mean that if one of the variables increases/decreases, this will have an impact on the second variable. 
	#-> Seems there is no correlation between these two variables, as the highest grade number is on '3' grading. 


#11. One of the customers is only interested in the following houses:
#Number of bedrooms either 3 or 4

select * from house_price_data
where bedrooms=3 and 4;

#Bathrooms more than 3

select * from house_price_data
where bathrooms>3
order by bathrooms ASC;

#one floor
select * from house_price_data
where floors=1;

#No waterfront
select * from house_price_data
where waterfront=0;

#Condition should be 3 at least
select * from house_price_data
where `condition`>=3
order by `condition` ASC;

#Grade should be 5 at least
select * from house_price_data
where `grade`>=5
order by grade ASC;

#Price less than 300000
select * from house_price_data
where price<300000;

#12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.

select * from house_price_data
where price> (
select 2*avg(price) as 'target' from house_price_data)
order by price ASC;

#13. Since this is something that the senior management is regularly interested in, create a view of the same query.

create view target_2timesavg as
select * from house_price_data
where price> (
select 2*avg(price) as 'target' from house_price_data)
order by price ASC;

#14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

select bedrooms, avg(price) from house_price_data
group by bedrooms
having bedrooms between 3 and 4;

#15. What are the different locations where properties are available in your database? (distinct zip codes)

select distinct(zipcode) from house_price_data;

#16. Show the list of all the properties that were renovated.
select * from house_price_data
where yr_renovated <> 0;

#->I have made here the assumption that if there is a '0' (and not a specific year), the house has not been renovated. 

#17. Provide the details of the property that is the 11th most expensive property in your database.

with cte_11th as (
select *
from house_price_data
order by price DESC
limit 11
)
select *
from cte_11th
order by price ASC
LIMIT 1;

