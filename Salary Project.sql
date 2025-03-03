-- CLEAN FILE
-- POTENTIAL QUESTION #1: Which industry pays the most?
-- POTENTIAL QUESTION #2: How does salary increase given years of experience?
-- POTENTIAL QUESTION #3: How do salaries compare for the same role in different locations?
-- POTENTIAL QUESTION #4: How much do salaries differ by gender and years of experience?
-- POTENTIAL QUESTION #5: How do factors like race and education level correlate with salary?
-- POTENTIAL QUESTION #6: Is there a “sweet spot” total work experience vs years in the specific field?

-- For this, we are creating a working table so as not to mess up the original raw file. Note that this is just creating the table; values not populated yet
CREATE TABLE salary_cleaned
LIKE salary_raw;

-- This is to check that if the table is successfully created
SELECT *
FROM salary_cleaned;

-- To copy values from the salary_raw table and to insert them into the salary_cleaned table
INSERT salary_cleaned
SELECT *
FROM salary_raw;

-- Check that if the values have been successfully cloned over from salary_raw to salary_cleaned
SELECT *
FROM salary_cleaned;

-- add new column: additional_moneytary_compensation1. varchar(20) is to define data type to be string, 20 characters long
ALTER TABLE salary_cleaned
ADD additional_monetary_compensation1 VARCHAR(20);

-- update salary_cleaned table and set additional_monetary_compensation1 values from additional_monetary_compensation
UPDATE salary_cleaned 
SET additional_monetary_compensation1 = additional_monetary_compensation;

-- check 
SELECT *
FROM salary_cleaned;

-- view col additional_monetary_compensation1 where value = 'none'
SELECT additional_monetary_compensation1
FROM salary_cleaned
WHERE additional_monetary_compensation1= 'none';

-- update col additional_monetary_compensation1 to change values from None to 0
UPDATE salary_cleaned
SET additional_monetary_compensation1 = 0
WHERE additional_monetary_compensation1 = 'None';

-- check 
SELECT *
FROM salary_cleaned;

-- Change data type from string to integer
ALTER TABLE salary_cleaned
MODIFY additional_monetary_compensation1 INTEGER;

-- check table
show columns
from salary_cleaned;

-- display everything
SELECT *
FROM salary_cleaned;

-- shift col additional_monetary_compensation1 to next to additional_monetary_compensation
alter table salary_cleaned
modify additional_monetary_compensation1 varchar(20) after additional_monetary_compensation;

-- check
SELECT *
FROM salary_cleaned;

-- drop additional_monetary_compensation col
ALTER TABLE salary_cleaned
drop column additional_monetary_compensation;

-- check
select *
from salary_cleaned;

-- rename column
alter table salary_cleaned
change column additional_monetary_compensation1 additional_monetary_compensation
int4 NOT NULL;

-- check
select *
from salary_cleaned;

-- create new working column
alter table salary_cleaned
add column annual_salary1 text;

-- update salary_2 table and set annual_salary1 values from annual_salary
UPDATE salary_cleaned
SET annual_salary1 = annual_salary;

-- check
select annual_salary, annual_salary1
from salary_cleaned;

-- remove comma from values
UPDATE salary_cleaned
set annual_salary1 = replace(annual_salary1, ',', '');

-- check if comma is removed
select annual_salary, annual_salary1
from salary_cleaned;

-- convert from string to integer
UPDATE salary_cleaned
set annual_salary1 = cast(annual_salary1 AS UNSIGNED);

-- check if conversion is done successfully
DESCRIBE SALARY_cleaned;
-- not successful
-- unable to convert into integer. error message was that there is a row that is out of range

-- check to see if there are any characters that are not digits or commas
select annual_salary1
from salary_cleaned
where not annual_salary1 REGEXP '^[0-9]+$';
-- do not have any characters that are not digits or commas

-- check for large values
SELECT MAX(CAST(REPLACE(annual_salary1, ',', '') AS UNSIGNED)) AS max_salary
FROM salary_cleaned;
-- returned value of '6000070000'. seems like the max value for a standard INT is 2147483647. instead of converting into INT, to convert to BIGINT

-- Change data type from string to integer
ALTER TABLE salary_cleaned
MODIFY annual_salary1 INT8;

-- check if conversion is done successfully
DESCRIBE SALARY_cleaned;

-- shift col annual_salary1 to next to annual_salary
alter table salary_cleaned
modify annual_salary1 int8 after annual_salary;

-- check table
select *
from salary_cleaned;

-- remove annual_salary col
alter table salary_cleaned
drop column annual_salary;

-- check table
select *
from salary_cleaned;

-- rename col annual_salary1 to annual_salary
alter table salary_cleaned
change column annual_salary1 annual_salary
int8 not null;

-- check table
select *
from salary_cleaned;

-- add column total_comp_package
alter table salary_cleaned
add column total_comp_package int8;

-- check table
describe salary_cleaned;

-- add annual_salary + additional_monetary_compensation to total_comp_package
UPDATE salary_cleaned
SET total_comp_package = annual_salary + additional_monetary_compensation;

-- shift total_comp_package to after additional_monetary_compensation col
alter table salary_2
modify total_comp_package int8 after additional_monetary_compensation;

-- check table
select *
from salary_2;


