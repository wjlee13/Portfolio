-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;
-- For the above, we are creating a working table so as not to mess up the original raw file. Note that this is just creating the table; values not populated yet

SELECT * 
FROM layoffs_staging;
-- This line is to check that if the table is successfully created

INSERT layoffs_staging
SELECT *
FROM layoffs;
-- This is line to copy values from the layoffs table and to insert them into the layoffs_staging table

SELECT * 
FROM layoffs_staging;
-- This line is to check that if the values have been successfully cloned over from layoffs to layoffs_staging

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;
-- adding a row number, as well as selecting which column to display. if there are duplicates, results shall be greater than 1
-- GROUP BY clause: one row per group in the result set
-- partition by: aggregated columns with EACH record in the specified table

WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
where row_num > 1;
-- creating a CTE, and then to identify duplicates (row_num = 2)
-- to be safe, partition by to include all columns

SELECT *
from layoffs_staging
where company = 'Casper';
-- this is to check and verify if there really are duplicates?

WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
where row_num > 1;
-- Doing the DELETE clause above would not work because unable to update the above (which is a CTE (Common Table Expression))


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Right click on tables > layoffs_staging, then click on Copy to Clipboard > Create Statement. this will then copy and paste the above create table statement
-- Make sure to rename properly as `layoffs_staging` table name is already used, so need a different name
-- because when creating layoffs_staging table, there was no row_num (that was only added in as part of CTE), hence, now that we are duplicating layoffs_staging table into a new table, to also include a new column, which is row_num

SELECT *
from layoffs_staging2
-- to test if table is created properly

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
from layoffs_staging2
WHERE row_num > 1;

DELETE 
from layoffs_staging2
WHERE row_num > 1;

SELECT *
from layoffs_staging2;

-- standardizing data: finding issues in the data and fixing it?

SELECT company, (trim(company))
FROM layoffs_staging2;
-- this is to populate the company name, as well as trim is to remove additional spaces in text

update layoffs_staging2
SET company = trim(company);
-- this is to update the company values with the new values (which is removing unncessary spaces)

SELECT distinct industry
from layoffs_staging2
ORDER BY 1;
-- this is to find out which industry are listed here, and then by ordering it, we can view them in alphabetical order. also useful to identify similar values
-- crypto currency is not properly formatted

SELECT *
from layoffs_staging2
WHERE industry LIKE 'Crypto%';
-- this is to filter values for the crypto industry

update layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- this is to update the crypto industry. set industry = 'Crypto'

SELECT distinct industry
from layoffs_staging2;
-- to check

SELECT distinct location
from layoffs_staging2;
-- to see if locations appear to be ok? discovered weird value DÃ¼sseldorf

SELECT *
from layoffs_staging2
WHERE location = 'DÃ¼sseldorf' 
;
-- to find out how many rows had the location = DÃ¼sseldorf

UPDATE layoffs_staging2
set location = 'Dusseldorf'
WHERE location = 'DÃ¼sseldorf' 
;
-- update location = DÃ¼sseldorf to Dusseldorf

SELECT *
from layoffs_staging2
WHERE location = 'DÃ¼sseldorf';
-- To check if it is ok. seems like no more DÃ¼sseldorf

SELECT distinct location
from layoffs_staging2
ORDER BY 1;
-- to see if locations appear to be ok? discovered weird value 'FlorianÃ³polis'

UPDATE layoffs_staging2
set location = 'Florianópolis'
WHERE location = 'FlorianÃ³polis'
;
-- update location = 'FlorianÃ³polis' to Florianópolis

SELECT distinct location
from layoffs_staging2
ORDER BY 1;
-- to see if locations appear to be ok? discovered weird value 'MalmÃ¶'

SELECT *
from layoffs_staging2
WHERE location = 'MalmÃ¶'
;
-- to find out how many rows had the location = 'MalmÃ¶'

UPDATE layoffs_staging2
set location = 'Malmö'
WHERE location = 'MalmÃ¶';
-- update location = 'MalmÃ¶' to Malmö

SELECT *
from layoffs_staging2
WHERE location = 'MalmÃ¶';
-- To check if it is ok. seems like no more 'MalmÃ¶' 

SELECT distinct country
from layoffs_staging2
ORDER BY 1;
-- to see if countries are spelt correctly, got duplicates? found out there's United States and United States.

SELECT *
from layoffs_staging2
WHERE Country = 'United States.';
-- to find out how many rows where Country = 'United States.'

SELECT distinct country, TRIM(country)
FROM layoffs_staging2
Order by 1;

SELECT distinct country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
Order by 1;
-- remove the addition '.' from the end (in this case, will be from United States.). however, only tge trim(country) column is affected

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
-- to update the country column to remove '.', specifically for country like 'United States%'

SELECT *
from layoffs_staging2
WHERE Country = 'United States.';
-- to check

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;
-- this is just to write sample code to test and play around. this code shall return 2 column: date and str_to_date
-- be mindful of the date formatting

update layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');
-- update date to the new format

SELECT date
FROM layoffs_staging2
;

ALTER table layoffs_staging2
modify column `date` DATE;
-- this is to change date column from text field to date field/format 

SELECT *
FROM layoffs_staging2;
-- to check

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;
-- need to use IS NULL, instead of = NULL. 

SELECT distinct industry
FROM layoffs_staging2;
-- there is missing and null value in industry column

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
or industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
-- join 2 tables. (or rather in this case, the two tables are essentially the same table)

UPDATE layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

update layoffs_staging2
SET industry = null
WHERE industry = '';

alter table layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;


