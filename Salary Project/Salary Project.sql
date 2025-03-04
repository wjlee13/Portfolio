-- WIP WORKING FILE 1
-- POTENTIAL QUESTION #1: Which industry pays the most?
-- POTENTIAL QUESTION #2: How does salary increase given years of experience?
-- POTENTIAL QUESTION #3: How do salaries compare for the same role in different locations?
-- POTENTIAL QUESTION #4: How much do salaries differ by gender and years of experience?
-- POTENTIAL QUESTION #5: How do factors like race and education level correlate with salary?
-- POTENTIAL QUESTION #6: Is there a “sweet spot” total work experience vs years in the specific field?

-- For this, we are creating a working table so as not to mess up the original raw file. Note that this is just creating the table; values not populated yet
CREATE TABLE salary_1
LIKE salary_raw;

-- This is to check that if the table is successfully created
SELECT *
FROM salary_1;

-- To copy values from the salary_raw table and to insert them into the salary_1 table
INSERT salary_1
SELECT *
FROM salary_raw;

-- Check that if the values have been successfully cloned over from salary_raw to salary_1
SELECT *
FROM salary_1;

-- add new column: additional_moneytary_compensation1. varchar(20) is to define data type to be string, 20 characters long
ALTER TABLE salary_1
ADD additional_monetary_compensation1 VARCHAR(20);

-- update salary_1 table and set additional_monetary_compensation1 values from additional_monetary_compensation
UPDATE salary_1 
SET additional_monetary_compensation1 = additional_monetary_compensation;

-- check 
SELECT *
FROM salary_1;

-- view col additional_monetary_compensation1 where value = 'none'
SELECT additional_monetary_compensation1
FROM salary_1
WHERE additional_monetary_compensation1= 'none';

-- update col additional_monetary_compensation1 to change values from None to 0
UPDATE salary_1
SET additional_monetary_compensation1 = 0
WHERE additional_monetary_compensation1 = 'None';

-- check 
SELECT *
FROM salary_1;

-- Change data type from string to integer
ALTER TABLE salary_1
MODIFY additional_monetary_compensation1 INTEGER;

-- check table
show columns
from salary_1;

-- display everything
SELECT *
FROM salary_1;

-- shift col additional_monetary_compensation1 to next to additional_monetary_compensation
alter table salary_1
modify additional_monetary_compensation1 int4 after additional_monetary_compensation;

-- check
SELECT *
FROM salary_1;

-- drop additional_monetary_compensation col
ALTER TABLE salary_1
drop column additional_monetary_compensation;

-- check
select *
from salary_1;

-- rename column
alter table salary_1
change column additional_monetary_compensation1 additional_monetary_compensation
int4 NOT NULL;

-- check
select *
from salary_1;

-- create new working column
alter table salary_1
add column annual_salary1 text;

-- update salary_1 table and set annual_salary1 values from annual_salary
UPDATE salary_1 
SET annual_salary1 = annual_salary;

-- check
select annual_salary, annual_salary1
from salary_1;

-- remove comma from values
UPDATE salary_1
set annual_salary1 = replace(annual_salary1, ',', '');

-- check if comma is removed
select annual_salary, annual_salary1
from salary_1;

-- convert from string to integer
UPDATE salary_1
set annual_salary1 = cast(annual_salary1 AS UNSIGNED);

-- check if conversion is done successfully
DESCRIBE SALARY_1;
-- not successful
-- unable to convert into integer. error message was that there is a row that is out of range

-- check to see if there are any characters that are not digits or commas
select annual_salary1
from salary_1
where not annual_salary1 REGEXP '^[0-9]+$';
-- do not have any characters that are not digits or commas. however, it seems like there are many empty rows with null values

-- identify problematic rows
SELECT annual_salary1
FROM salary_1
WHERE TRIM(annual_salary1) = '' 
   OR annual_salary1 IS NULL
   OR annual_salary1 REGEXP '[^0-9]';

-- set invalid values to null
UPDATE salary_1
SET annual_salary1 = NULL
WHERE TRIM(annual_salary1) = ''
   OR annual_salary1 REGEXP '[^0-9]';

-- check for large values
SELECT MAX(CAST(REPLACE(annual_salary1, ',', '') AS UNSIGNED)) AS max_salary
FROM salary_1;
-- returned value of '6000070000'. seems like the max value for a standard INT is 2147483647. instead of converting into INT, to convert to BIGINT

-- Change data type from string to integer
ALTER TABLE salary_1
MODIFY annual_salary1 int8;

-- check if conversion is done successfully
DESCRIBE SALARY_1;

-- shift col annual_salary1 to next to annual_salary
alter table salary_1
modify annual_salary1 TEXT after annual_salary;

-- check table
select *
from salary_1;

-- remove annual_salary col
alter table salary_1
drop column annual_salary;

-- check table
select *
from salary_1;

-- rename col annual_salary1 to annual_salary
alter table salary_1
change column annual_salary1 annual_salary
int8 not null;

-- check table
select *
from salary_1;

-- add column total_comp_package
alter table salary_1
add column total_comp_package int8;

-- check table
describe salary_1;

-- add annual_salary + additional_monetary_compensation to total_comp_package
UPDATE salary_1
SET total_comp_package = annual_salary + additional_monetary_compensation;

-- shift total_comp_package to after additional_monetary_compensation col
alter table salary_1
modify total_comp_package int8 after additional_monetary_compensation;

-- check table
select *
from salary_1;

-- create new column for currency as a back up
ALTER TABLE salary_1
ADD currency1 VARCHAR(20);

-- insert values into currency1 col from currency col
UPDATE salary_1 
SET currency1 = currency;

-- update value for currency column
update salary_1
set currency = 'MXN'
WHERE other_currency = 'Mexican Pesos';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Mexican Pesos';

-- update value for currency column
update salary_1
set currency = 'USD'
WHERE other_currency = 'American Dollars';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'American Dollars';

-- update value for currency column
update salary_1
set currency = 'ARS'
WHERE other_currency = 'Argentine Peso';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Argentine Peso';

-- update value for currency column
update salary_1
set currency = 'ARS'
WHERE other_currency = 'Argentinian peso (ARS)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Argentinian peso (ARS)';

-- update value for currency column
update salary_1
set currency = 'ARS'
WHERE other_currency = 'ARS';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'ARS';

-- update value for currency column
update salary_1
set currency = 'AUD/NZD'
WHERE other_currency = 'AUD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'AUD';

-- update value for currency column
update salary_1
set currency = 'AUD/NZD'
WHERE other_currency = 'AUD Australian ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'AUD Australian ';

-- update value for currency column
update salary_1
set currency = 'AUD/NZD'
WHERE other_currency = 'Australian Dollars ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Australian Dollars ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'AUD Australian ';

-- update value for currency column
update salary_1
set currency = 'BDT'
WHERE other_currency = 'Bdt';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Bdt';

-- update value for currency column
update salary_1
set currency = 'BRL'
WHERE other_currency = 'BR$';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'BR$';

-- update value for currency column
update salary_1
set currency = 'BRL'
WHERE other_currency = 'BRL';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'BRL';

-- update value for currency column
update salary_1
set currency = 'BRL'
WHERE other_currency = 'BRL (R$)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'BRL (R$)';

-- update value for currency column
update salary_1
set currency = 'CAD'
WHERE other_currency = 'CAD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'CAD';

-- update value for currency column
update salary_1
set currency = 'CHF'
WHERE other_currency = 'CHF';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'CHF';

-- update value for currency column
update salary_1
set currency = 'RMB'
WHERE other_currency = 'China RMB';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'China RMB';

-- update value for currency column
update salary_1
set currency = 'RMB'
WHERE other_currency = 'CNY';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'CNY';

-- update value for currency column
update salary_1
set currency = 'COP'
WHERE other_currency = 'COP';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'COP';

-- update value for currency column
update salary_1
set currency = 'HRK'
WHERE other_currency = 'croatian kuna';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'croatian kuna';

-- update value for currency column
update salary_1
set currency = 'CZK'
WHERE other_currency = 'czech crowns';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'czech crowns';

-- update value for currency column
update salary_1
set currency = 'CZK'
WHERE other_currency = 'CZK';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'CZK';

-- update value for currency column
update salary_1
set currency = 'CZK'
WHERE other_currency = 'Czk';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Czk';

-- update value for currency column
update salary_1
set currency = 'DKK'
WHERE other_currency = 'Danish Kroner';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Danish Kroner';

-- update value for currency column
update salary_1
set currency = 'DKK'
WHERE other_currency = 'Dkk';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Dkk';

-- update value for currency column
update salary_1
set currency = 'USD'
WHERE other_currency = 'Equity';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Equity';

-- update value for currency column
update salary_1
set currency = 'EUR'
WHERE other_currency = 'EUR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'EUR';

-- update value for currency column
update salary_1
set currency = 'EUR'
WHERE other_currency = 'Euro';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Euro';

-- update value for currency column
update salary_1
set currency = 'GBP'
WHERE other_currency = 'GBP';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'GBP';

-- update value for currency column
update salary_1
set currency = 'IDR'
WHERE other_currency = 'IDR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'IDR';

-- update value for currency column
update salary_1
set currency = 'IDR'
WHERE other_currency = 'IDR ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'IDR ';

-- update value for currency column
update salary_1
set currency = 'ILS'
WHERE other_currency = 'ILS';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'ILS';

-- update value for currency column
update salary_1
set currency = 'ILS'
WHERE other_currency = 'ILS/NIS';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'ILS/NIS';

-- update value for currency column
update salary_1
set currency = 'INR'
WHERE other_currency = 'Indian rupees';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Indian rupees';

-- update value for currency column
update salary_1
set currency = 'INR'
WHERE other_currency = 'INR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'INR';

-- update value for currency column
update salary_1
set currency = 'INR'
WHERE other_currency = 'INR (Indian Rupee)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'INR (Indian Rupee)';

-- update value for currency column
update salary_1
set currency = 'ILS'
WHERE other_currency = 'Israeli Shekels';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Israeli Shekels';

-- update value for currency column
update salary_1
set currency = 'KRW'
WHERE other_currency = 'Korean Won ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Korean Won ';

-- update value for currency column
update salary_1
set currency = 'KRW'
WHERE other_currency = 'KRW';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'KRW';

-- update value for currency column
update salary_1
set currency = 'KRW'
WHERE other_currency = 'KRW (Korean Won)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'KRW (Korean Won)';

-- update value for currency column
update salary_1
set currency = 'LKR'
WHERE other_currency = 'LKR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'LKR';

-- update value for currency column
update salary_1
set currency = 'MXN'
WHERE other_currency = 'Mexican Pesos';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Mexican Pesos';

-- update value for currency column
update salary_1
set currency = 'MXN'
WHERE other_currency = 'MXN';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'MXN';

-- update value for currency column
update salary_1
set currency = 'MYR'
WHERE other_currency = 'MYR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'MYR';

-- update value for currency column
update salary_1
set currency = 'NGN'
WHERE other_currency = 'NGN';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'NGN';

-- update value for currency column
update salary_1
set currency = 'ILS'
WHERE other_currency = 'NIS (new Israeli shekel)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'NIS (new Israeli shekel)';

-- update value for currency column
update salary_1
set currency = 'NOK'
WHERE other_currency = 'NOK';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'NOK';

-- update value for currency column
update salary_1
set currency = 'NOK'
WHERE other_currency = 'Norwegian kroner (NOK)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Norwegian kroner (NOK)';

-- update value for currency column
update salary_1
set currency = 'NTD'
WHERE other_currency = 'NTD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'NTD';

-- update value for currency column
update salary_1
set currency = 'AUD/NZD'
WHERE other_currency = 'NZD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'NZD';

-- update value for currency column
update salary_1
set currency = 'ARS'
WHERE other_currency = 'Peso Argentino';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Peso Argentino';

-- update value for currency column
update salary_1
set currency = 'PHP'
WHERE other_currency = 'Philippine Peso';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Philippine Peso';

-- update value for currency column
update salary_1
set currency = 'PHP'
WHERE other_currency = 'Philippine peso (PHP)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Philippine peso (PHP)';

-- update value for currency column
update salary_1
set currency = 'PHP'
WHERE other_currency = 'Philippine Pesos';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Philippine Pesos';

-- update value for currency column
update salary_1
set currency = 'PHP'
WHERE other_currency = 'PHP';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'PHP';

-- update value for currency column
update salary_1
set currency = 'PHP'
WHERE other_currency = 'PhP (Philippine Peso)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'PhP (Philippine Peso)';

-- update value for currency column
update salary_1
set currency = 'PLN'
WHERE other_currency = 'PLN';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'PLN';

-- update value for currency column
update salary_1
set currency = 'PLN'
WHERE other_currency = 'PLN (Polish zloty)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'PLN (Polish zloty)';

-- update value for currency column
update salary_1
set currency = 'PLN'
WHERE other_currency = 'PLN (Zwoty)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'PLN (Zwoty)';

-- update value for currency column
update salary_1
set currency = 'PLN'
WHERE other_currency = 'Polish Złoty';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Polish Złoty';

-- update value for currency column
update salary_1
set currency = 'MYR'
WHERE other_currency = 'RM';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'RM';

-- update value for currency column
update salary_1
set currency = 'RMB'
WHERE other_currency = 'RMB (chinese yuan)';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'RMB (chinese yuan)';

-- update value for currency column
update salary_1
set currency = 'INR'
WHERE other_currency = 'Rupees';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Rupees';

-- update value for currency column
update salary_1
set currency = 'SAR'
WHERE other_currency = 'SAR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'SAR';

-- update value for currency column
update salary_1
set currency = 'SEK'
WHERE other_currency = 'SEK';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'SEK';

-- update value for currency column
update salary_1
set currency = 'SGD'
WHERE other_currency = 'SGD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'SGD';

-- update value for currency column
update salary_1
set currency = 'SGD'
WHERE other_currency = 'SGD ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'SGD';

-- update value for currency column
update salary_1
set currency = 'SGD'
WHERE other_currency = 'Singapore Dollara';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Singapore Dollara';

-- update value for currency column
update salary_1
set currency = 'NTD'
WHERE other_currency = 'Taiwanese dollars';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Taiwanese dollars';

-- update value for currency column
update salary_1
set currency = 'THB'
WHERE other_currency = 'THAI  BAHT';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'THAI  BAHT';

-- update value for currency column
update salary_1
set currency = 'THB'
WHERE other_currency = 'Thai Baht ';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'Thai Baht ';

-- update value for currency column
update salary_1
set currency = 'THB'
WHERE other_currency = 'THB';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'THB';

-- update value for currency column
update salary_1
set currency = 'TRY'
WHERE other_currency = 'TRY';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'TRY';

-- update value for currency column
update salary_1
set currency = 'TTD'
WHERE other_currency = 'TTD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'TTD';

-- update value for currency column
update salary_1
set currency = 'USD'
WHERE other_currency = 'US Dollar';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'US Dollar';

-- update value for currency column
update salary_1
set currency = 'USD'
WHERE other_currency = 'USD';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'USD';

-- update value for currency column
update salary_1
set currency = 'ZAR'
WHERE other_currency = 'ZAR';

-- check
select job_title, other_currency, currency, currency1
from salary_1
where other_currency = 'ZAR';

-- Update country column for australia
update salary_1
set country = 'Australia'
WHERE country = 'Australia';

-- Update country column for australia
update salary_1
set country = 'Australia'
WHERE country = 'Australia ';

-- Update country column for australia
update salary_1
set country = 'Australia'
WHERE country = 'Australian ';

-- Update country column for australia
update salary_1
set country = 'Australia'
WHERE country = 'Australi';

-- check
select country
from salary_1
where country = 'Australia';

-- current value is AUD/NZD. to decouple the currency.
update salary_1
set currency = 'AUS'
WHERE country = 'Australia';

-- check
select country, currency
from salary_1
where country = 'Australia';

-- Update country column for new zealand
update salary_1
set country = 'New Zealand'
WHERE country = 'Aotearoa New Zealand';

-- Update country column for new zealand
update salary_1
set country = 'New Zealand'
WHERE country = 'From New Zealand but on projects across APAC';

-- Update country column for new zealand
update salary_1
set country = 'New Zealand'
WHERE country = 'New Zealand';

-- Update country column for new zealand
update salary_1
set country = 'New Zealand'
WHERE country = 'New Zealand ';

-- Update country column for new zealand
update salary_1
set country = 'New Zealand'
WHERE country = 'New Zealand Aotearoa';

-- check table
select country
from salary_1
where country = 'New Zealand';

-- current value is AUD/NZD. to decouple the currency.
update salary_1
set currency = 'NZD'
WHERE country = 'New Zealand';

-- check
select country, currency
from salary_1
where country = 'New Zealand';

-- check again
select country, currency, Job_title
from salary_1
where currency = 'AUD/NZD';

-- Update country column for new zealand
update salary_1
set country = 'New Zealand'
WHERE country = 'NZ';

-- there was a new zealand with a space before. to clean it up
UPDATE salary_1
SET country = LTRIM(country);

-- check table
select *
from salary_1
where currency = 'other';

-- update all currency
update salary_1
set currency = 'INR'
WHERE job_title = 'Data Engineer' AND city = 'Banglore';

-- check table
select *
from salary_1
where currency = 'other';

-- check table
select *
from salary_1
where currency = 'AUD/NZD';

-- delete rows where currency is null
delete FROM salary_1
where currency = '';

-- CHECK
select distinct currency
from salary_1;

-- there are 2 rows where currency is AUD/NZD, but country is somewhere else. to remove these data from table
delete FROM salary_1
where currency = 'AUD/NZD';

-- CHECK
select distinct total_work_experience
from salary_1;
-- to see if formatting is correct. shows that 5-7 years had no spaces in between, while the rest had.

-- update formatting for 5-7 years to 5 - 7 years
UPDATE salary_1
SET total_work_experience = REPLACE(total_work_experience, '5-7 years', '5 - 7 years')
WHERE total_work_experience LIKE '%5-7 years%';

-- CHECK
select distinct total_work_experience
from salary_1;

select *
from salary_1;

-- CHECK
select distinct relevant_experience
from salary_1;
-- to see if formatting is correct. shows that 5-7 years had no spaces in between, while the rest had.

-- update formatting for 5-7 years to 5 - 7 years
UPDATE salary_1
SET relevant_experience = REPLACE(relevant_experience, '5-7 years', '5 - 7 years')
WHERE relevant_experience LIKE '%5-7 years%';

-- CHECK
select distinct relevant_experience
from salary_1;

-- find out what are the distinct countries so that can clean up formatting
select distinct country
from salary_1;

show columns 
from salary_1;


-- add new column: country1. text is to define data type to be string. there are long characters, hence instead of using varchar(20), went with text instead
ALTER TABLE salary_1
ADD country1 text;

-- update salary_1 table and set country1 values from country
UPDATE salary_1 
SET country1 = country;

-- check table
select *
from salary_1;

-- check what to clean
select currency, country, country1
from salary_1
where currency = 'ARS';

-- update value for currency column
update salary_1
set country = 'Argentina'
WHERE currency = 'ARS';

-- check
select currency, country, country1
from salary_1
where currency = 'ARS';

-- check what to clean
select currency, country, country1
from salary_1
where currency = 'AUS';

-- update value for currency column
update salary_1
set country = 'Australia'
WHERE currency = 'Aus';

-- check
select currency, country, country1
from salary_1
where currency = 'AUS';

UPDATE salary_1
SET currency = 'AUD'
where currency = 'AUS';

-- update value for currency column
update salary_1
set country = 'Australia'
WHERE currency = 'AUD';

-- check
select currency, country, country1
from salary_1
where currency = 'AUD';

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- update country column
update salary_1
set country = 'Australia'
WHERE currency = 'CAD' AND country = '$2,175.84/year is deducted for benefits'; 

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND country = '$2,175.84/year is deducted for benefits';

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND country = 'Australia';

-- correction
update salary_1
set country = 'Canada'
where country1 = '$2,175.84/year is deducted for benefits';

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND country1 = '$2,175.84/year is deducted for benefits';

-- remove extra space after 'canada '
UPDATE salary_1
SET country = RTRIM(country)
WHERE country = 'Canada ';

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- update country column
update salary_1
set country = 'Canada'
where country = 'Canada, Ottawa, ontario';

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- update country column
update salary_1
set country = 'Canada'
where country in ('Canadw',  'Csnada');

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- update country column
update salary_1
set country = 'Canada'
where currency = 'CAD' and country in ('Global',  'Can', 'Canda', 'Canada and USA', 'Canad', 'Canda', 'Policy');

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- update country column
update salary_1
set country = 'USA'
where currency = 'CAD' and country in ('US');

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- check
select currency, country, country1
from salary_1
where currency = 'CZK';

-- update country column
update salary_1
set country = 'Czech Republic '
where currency = 'CZK' and country in ('Czech republic', 'Czechia', 'czech republic');

-- check
select currency, country, country1
from salary_1
where currency = 'CZK';

-- check
select currency, country, country1
from salary_1
where currency = 'DKK';

-- update country column
update salary_1
set country = 'Denmark'
where currency = 'DKK' and country in ('denmark');

-- check
select currency, country, country1
from salary_1
where currency = 'DKK';

-- check
select currency, country, country1
from salary_1
where currency = 'EUR';

-- update country column
update salary_1
set country = 'Netherlands'
where currency = 'EUR' and country in ('The Netherlands', 'netherlands', 'Nederland');

-- check
select currency, country, country1
from salary_1
where currency = 'EUR';

-- update country column
update salary_1
set country = 'Austria'
where currency = 'EUR' and country in ('Austria, but I work remotely for a Dutch/British company');

-- update country column
update salary_1
set country = 'Spain'
where currency = 'EUR' and country in ('Catalonia');

-- update country column
update salary_1
set country = 'Pakistan'
where currency = 'EUR' and country in ('Company in Germany. I work from Pakistan.');

-- update country column
update salary_1
set country = 'Finland'
where currency = 'EUR' and country in ('finland');

-- update country column
update salary_1
set country = 'France'
where currency = 'EUR' and country in ('FRANCE');

-- update country column
update salary_1
set country = 'Germany'
where currency = 'EUR' and country in ('germany');

-- update country column
update salary_1
set country = 'Italy'
where currency = 'EUR' and country in ('Itanly');

-- update country column
update salary_1
set country = 'Luxembourg'
where currency = 'EUR' and country in ('Luxemburg');

-- update country column
update salary_1
set country = 'Netherland'
where currency = 'EUR' and country in ('Nederland');

-- update country column
update salary_1
set country = 'Netherland'
where currency = 'EUR' and country in ('NL');

-- update country column
update salary_1
set country = 'Spain'
where currency = 'EUR' and country in ('spain');

-- update country column
update salary_1
set country = 'United Kingdom'
where currency = 'EUR' and country in ('UK', 'Uk', 'U.K.');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'EUR' and country in ('United States of America', 'USA');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('United States', 'USA');

SELECT distinct country
from salary_1
where currency = 'USD';

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('United States', 'US', 'USA', 'U.S.', 'U.S. ', 'U.S>', 'ISA', 'US ', 'United State', 'U.S.A', 'U.S.A.', 'America', 'The United States', 'United State of America', 'United Stated', 'USA-- Virgin Islands', 'United Statws', 'U.S', 'Unites States ', 'U.S.A. ', 'U. S. ', 'United Sates', 'United States of American ', 'Uniited States', 'Worldwide (based in US but short term trips aroudn the world)', 'United Sates of America', 'United States (I work from home and my clients are all over the US/Canada/PR', 'Unted States', 'United Statesp', 'United Stattes', 'United Statea');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('United States', 'United States ', 'USA ', 'United States of America ', 'Unites States', 'United Statees' 'Uniyed states', 'Uniyes States', 'United States of Americas', 'U. S.', 'US of A', 'U.SA', 'United Status', 'Uniteed States', 'United Stares', 'Unite States', 'The US', 'For the United States government, but posted overseas', 'United statew', 'United Statues', 'Untied States', 'USA (company is based in a US territory, I work remote)', 'Unitied States', 'USAB', 'United Sttes', 'Uniter Statez', 'U. S ', 'USA tomorrow ', 'United Stateds', 'US govt employee overseas, country withheld', '🇺🇸 ', 'Unitef Stated', 'United Stares ', 
'United States- Puerto Rico', 'USD', 'United Statss', 'I work for a UAE-based organization, though I am personally in the US.', 'United  States', 'United States is America', 'United States of American', 'U.S.A ');

SELECT distinct country
from salary_1
where currency = 'GBP';

-- update country column
update salary_1
set country = 'United Kingdom'
where currency = 'GBP' and country in ('United Kingdom', 'United Kingdom ', 'UK', 'UK ', 'United Kingdom.', 'U.K. ', 'United Kindom', 'U.K.', 'UK for U.S. company', 'United Kingdomk', 'U.K', 'UK, remote', 'Unites kingdom ', 'Isle of Man', 'UK, but for globally fully remote company');

-- update country column
update salary_1
set country = 'Scotland'
where currency = 'GBP' and country in ('Scotland ', 'Scotland', 'Scotland, UK');

-- update country column
update salary_1
set country = 'England'
where currency = 'GBP' and country in ('England', 'England ', 'England/UK', 'England, UK.', 'Britain ', 'United Kingdom (England)', 'England, UK', 'Great Britain', 'England, Gb', 'England, United Kingdom', 'Englang', 'UK (England)', 'England, United Kingdom ', 'London', 'Great Britain ');

-- update country column
update salary_1
set country = 'Northern Ireland'
where currency = 'GBP' and country in ('Northern Ireland', 'Northern Ireland ', 'UK (Northern Ireland)', 'U.K. (northern England)', 'Northern Ireland ', 'Northern Ireland, United Kingdom');

-- update country column
update salary_1
set country = 'Wales'
where currency = 'GBP' and country in ('Wales (United Kingdom)', 'Wales', 'Wales, UK', 'Wales (UK)');

-- update country column
update salary_1
set country = 'India'
where currency = 'GBP' and country in ('ibdia');

-- update country column
update salary_1
set country = 'Croatia'
where currency = 'HRK' and country in ('croatia');

-- update country column
update salary_1
set country = 'India'
where currency = 'INR' and country in ('INDIA');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'JPY' and country in ('United States');

-- update country column
update salary_1
set country = 'Mexico'
where currency = 'MXN' and country in ('MÃ©xico');

-- update country column
update salary_1
set country = 'Nigeria'
where currency = 'NGN' and country in ('NIGERIA');

-- update country column
update salary_1
set country = 'China'
where currency = 'RMB' and country in ('Mainland China');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'SEK' and country in ('US ');

-- check
select currency, country, country1
from salary_1
where currency = 'SEK' AND NOT country = 'Sweden'; 

-- update country column
update salary_1
set country = 'Argentina'
where currency = 'THB' and country in ('ARGENTINA BUT MY ORG IS IN THAILAND');

-- update country column
update salary_1
set country = 'Spain'
where currency = 'ZAR' and country in ('spain');

-- check
select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada'; 

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'CAD' and country in ('USA');

select currency, country, country1
from salary_1
where currency = 'CAD' AND NOT country = 'Canada';

-- update country column
update salary_1
set country = 'Canada'
where currency = 'CAD' and country in ('canada');

-- update country column
update salary_1
set country = 'Switzerland'
where currency = 'CHF' and country in ('switzerland');

-- update country column
update salary_1
set country = 'Ireland'
where currency = 'EUR' and country in ('ireland');

-- update country column
update salary_1
set country = 'Netherlands'
where currency = 'EUR' and country in ('Netherland', 'The Netherlands ', 'The Netherlands');

-- update country column
update salary_1
set country = 'United Kingdom'
where currency = 'EUR' and country in ('U.K. ');

select currency, country, country1
from salary_1
where currency = 'EUR' AND country = 'ff';

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'EUR' and country in ('ff');

-- check table
select currency, country, country1
from salary_1
where currency = 'EUR' AND country = 'ff';

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'EUR' and country in ('n/a (remote from wherever I want)');

-- check table
select currency, country, country1
from salary_1
where currency = 'EUR' AND country = 'n/a (remote from wherever I want)';

-- update country column
update salary_1
set country = 'Jersey, Channel Islands'
where currency = 'GBP' and country in ('Jersey, Channel islands');

select currency, country, country1
from salary_1
where currency = 'GBP' and country in ('Jersey, Channel Islands');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'GBP' and country in ('Remote');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'GBP' and country in ('USA');

-- update country column
update salary_1
set country = 'Japan'
where currency = 'JPY' and country in ('japan');

select currency, country, country1
from salary_1
where currency = 'MXN';

-- update country column
update salary_1
set country = 'Mexico'
where currency = 'MXN' and country in ('México');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ('bonus based on meeting yearly goals set w/ my supervisor');

-- update country column
update salary_1
set country = 'Myanmar'
where currency = 'USD' and country in ('Burma');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('California ');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ('Contracts');

-- update country column
update salary_1
set country = 'Ivory Coast'
where currency = 'USD' and country in ("Cote d'Ivoire");

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ('Currently finance');

-- update country column
update salary_1
set country = 'Denmark'
where currency = 'USD' and country in ('Danmark');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ('dbfemf');

-- update country column
update salary_1
set country = 'Denmark'
where currency = 'USD' and country in ('denmark');

-- update country column
update salary_1
set country = 'Romania'
where currency = 'USD' and country in ('From Romania, but for an US based company');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('Hartford');

-- update country column
update salary_1
set country = 'Hong Kong'
where currency = 'USD' and country in ('hong konh');

-- update country column
update salary_1
set country = 'Canada'
where currency = 'USD' and country in ('I am located in Canada but I work for a company in the US');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("I earn commission on sales. If I meet quota, I'm guaranteed another 16k min. Last year i earned an additional 27k. It's not uncommon for people in my space to earn 100k+ after commission. ");

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("I was brought in on this salary to help with the EHR and very quickly was promoted to current position but compensation was not altered. ");

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('I.S.');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("International ");

-- update country column
update salary_1
set country = 'Ireland'
where currency = 'USD' and country in ('ireland');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('IS');

-- update country column
update salary_1
set country = 'Japan'
where currency = 'USD' and country in ('Japan, US Gov position');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("LOUTRELAND");

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("na");

-- update country column
update salary_1
set country = 'Pakistan'
where currency = 'USD' and country in ('pakistan');

-- update country column
update salary_1
set country = 'Panama'
where currency = 'USD' and country in ('Panamá');

select currency, country, country1
from salary_1
where currency = 'USD' and country like 'Pan%';

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("Remote");

-- update country column
update salary_1
set country = 'Philippines'
where currency = 'USD' and country in ('Remote (philippines)');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('San Francisco');

-- update country column
update salary_1
set country = 'Singapore'
where currency = 'USD' and country in ('singapore');

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("ss");

-- update country column
update salary_1
set country = 'Netherlands'
where currency = 'USD' and country in ('The Netherlands');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('U.A.');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('UA');

-- update country column
update salary_1
set country = 'United Kingdom'
where currency = 'USD' and country in ('UK ');

-- update country column
update salary_1
set country = 'UAE'
where currency = 'USD' and country in ('United Arab Emirates ');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('United Statees');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('United y');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('Uniyed states');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('UnitedStates');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ('Usat');

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ("UXZ");

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ("USS");

-- update country column
update salary_1
set country = 'United States of America'
where currency = 'USD' and country in ("Virginia");

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("Y");

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'USD' and country in ("We don't get raises, we get quarterly bonuses, but they periodically asses income in the area you work, so I got a raise because a 3rd party assessment showed I was paid too little for the area we were located");

-- update country column (delete rows where country is invalid)
delete from salary_1
where currency = 'EUR' and country in ("europe");

select *
from salary_1;

-- delete back up column currency1
ALTER TABLE salary_1
drop column currency1;

-- check table
select *
from salary_1;

-- delete back up column country1
ALTER TABLE salary_1
drop column country1;

-- check table
select *
from salary_1;

-- add new column: country1 as a updated backup
ALTER TABLE salary_1
ADD country1 VARCHAR(100);

-- update salary_1 table and set country1 values from country
UPDATE salary_1 
SET country1 = country;

-- check table
select country, country1
from salary_1;

-- remove any trailing spaces
UPDATE salary_1
SET country = TRIM(country);

-- check table
select country, country1
from salary_1;

-- delete back up column country1
ALTER TABLE salary_1
drop column country1;

-- check table
select *
from salary_1;

select distinct currency
from salary_1;

-- add new column: currency1 as a updated backup
ALTER TABLE salary_1
ADD currency1 VARCHAR(20);

-- update salary_1 table and set currency1 values from currency
UPDATE salary_1 
SET currency1 = currency;

-- check table
select currency, currency1
from salary_1
where currency = 'NTD';

-- update currency from RMB to CNY
update salary_1
set currency = 'CNY'
WHERE currency = 'RMB';

-- update currency from NTD to TWD
update salary_1
set currency = 'TWD'
WHERE currency = 'NTD';
	
-- delete back up column currency1
ALTER TABLE salary_1
drop column currency1;

-- delete later
drop table currency_exchange;

-- create new table for currency exchange rate
CREATE TABLE currency_exchange (
currency_id INT,
base_currency VARCHAR(20),
converted_currency VARCHAR(20),
currency_conversion VARCHAR(20),
exchange_rate decimal (10,6)
);

-- check table
select *
from currency_exchange;

-- test join query
select s.currency, exchange_rate
from salary_1 AS S
INNER JOIN currency_exchange AS CE
ON s.currency = ce.base_currency
where currency = 'IDR';

-- add new column: exchange_rate column
ALTER TABLE salary_1
ADD exchange_rate decimal (10,6);

-- shift exchange_rate column next to currency
ALTER TABLE salary_1
MODIFY COLUMN exchange_rate DECIMAL(10, 6)
AFTER currency;

-- check table
SELECT *
FROM salary_1;

-- inner join salary_1 table with currency_exchange table, and set salary_1.exchange_rate column as currency_exchange.exchange_rate
UPDATE salary_1 AS S
INNER JOIN currency_exchange AS CE
ON S.currency = CE.base_currency
SET S.exchange_rate = CE.exchange_rate;

-- check table
SELECT *
FROM salary_1;

-- add new column: total_comp_package_usd
ALTER TABLE salary_1
ADD total_comp_package_usd decimal (10,6)
AFTER exchange_rate;

-- check table
SELECT *
FROM salary_1;

-- increase range value for total_comp_package_usd to accomodate bigger values
ALTER TABLE salary_1
MODIFY COLUMN total_comp_package_usd DECIMAL(20, 2);

-- update total_comp_package_usd column by multiplying total_comp_package with exchange_rate
UPDATE salary_1
SET total_comp_package_usd = (total_comp_package * exchange_rate);

-- check table
SELECT *
FROM salary_1;

# show relevant fields only, for export to csv for visualization in powerbi
SELECT country, gender, highest_education, age_range, relevant_experience, total_work_experience, total_comp_package_usd
FROM salary_1;

-- add new column: highest_education1
ALTER TABLE salary_1
ADD highest_education1 VARCHAR(40);

-- update salary_1 table and set highest_education1 values from highest_education1. this is to have a master col and a working col
UPDATE salary_1 
SET highest_education1 = highest_education;

# check table
SELECT highest_education1, highest_education
FROM salary_1;

DELETE FROM salary_1
WHERE highest_education ='';

# check table
SELECT highest_education1, highest_education
FROM salary_1;

# DELETE BLANK COL
DELETE FROM salary_1
WHERE gender ='';

# only want to keep man and woman values from gender col
DELETE FROM salary_1
WHERE gender NOT IN ('Man', 'Woman');

# show relevant fields only, for export to csv for visualization in powerbi
SELECT country, gender, highest_education, age_range, relevant_experience, total_work_experience, total_comp_package_usd
FROM salary_1;

# set total_comp_package_usd to 2 decimal points
UPDATE salary_1
SET total_comp_package_usd = ROUND(total_comp_package_usd, 2);

# show relevant fields only, for export to csv for visualization in powerbi
SELECT country, gender, highest_education, age_range, relevant_experience, total_work_experience, total_comp_package_usd
FROM salary_1;

select *
from salary_1
where country = 'Canada'AND gender = 'Woman' AND highest_education = 'College degree' AND Age_range = '18-24' AND relevant_experience = '1 year or less' AND total_work_experience = '2 - 4 years';

select *
from salary_1
ORDER BY total_comp_package_usd DESC;


