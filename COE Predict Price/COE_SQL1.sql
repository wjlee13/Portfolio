# insert data by creating schema > table data import wizard
# check if values are entered properly into table
SELECT * 
FROM coe.coebiddingresultsprices;

# check data type
DESCRIBE coe.coebiddingresultsprices;

# change month to YrMth. This is because to create a new col for year and a new col for month
ALTER TABLE coe.coebiddingresultsprices
CHANGE month YrMth VARCHAR(100);

# add year and month col
ALTER TABLE coe.coebiddingresultsprices 
ADD COLUMN year INT,
ADD COLUMN month INT;

# update year and month col using values from YrMth col
UPDATE coebiddingresultsprices
SET 
    year = YEAR(STR_TO_DATE(CONCAT(YrMth, '-01'), '%Y-%m-%d')),
    month = MONTH(STR_TO_DATE(CONCAT(YrMth, '-01'), '%Y-%m-%d'));

# YrMth col is currently Str type. to change it to Date Type
# Step 1: Add a new DATE column
ALTER TABLE coe.coebiddingresultsprices
ADD new_YrMth DATE;

# Step 2: Convert and populate the new column with the correct format
UPDATE coebiddingresultsprices
SET new_YrMth = STR_TO_DATE(CONCAT(YrMth, '-01'), '%Y-%m-%d');

# Step 3: Drop the old VARCHAR column
ALTER TABLE coebiddingresultsprices
DROP COLUMN YrMth;

# Step 4: Rename the new column to the original name
ALTER TABLE coebiddingresultsprices
CHANGE new_YrMth YrMth DATE;

# export table to csv file using right click on table > Table Data Export Wizard
# clean csv file in excel using data > Text to Column (Delimited, semi colon)
