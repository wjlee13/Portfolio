# load library
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyverse)
library(randomForest)

# Load a CSV file from your computer
df <- read.csv("C:/Users/Lee/OneDrive/Data Projects/COE Prices/COEBiddingResultsPrices - MySQL Cleaned.csv")

# View the entire dataset
View(df)

#inspect table
str(df)

#inspect table
str(df)

#statistical overview
summary(df)

# concert YrMth col from chr/str to date
df$YrMth <- dmy(df$YrMth)

#inspect table
str(df)

# View the entire dataset
View(df)

##################################################################################################

# chart to show quota by year

# group by year to find out total number of quota by year
total_quota_by_year <- df %>%
  group_by(year) %>%
  summarize(total_quota = sum(quota))

# View the grouped data
View(total_quota_by_year)

# create bar chart of quota by year
ggplot(total_quota_by_year, aes(x = as.factor(year), y = total_quota)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Total Quota by Year",
       x = "Year",
       y = "Total Quota") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# chart shows the period 2015 to 2021 having more quotas

##################################################################################################

# chart to show successful bids by year

# group by year to find out total number of successful bids by year
total_successful_bids_by_year <- df %>%
  group_by(year) %>%
  summarize(total_successful_bids = sum(bids_success))

# View the grouped data
View(total_successful_bids_by_year)

# create bar chart of successful bids by year
ggplot(total_successful_bids_by_year, aes(x = as.factor(year), y = total_successful_bids)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Total Successful Bids by Year",
       x = "Year",
       y = "Total Successful Bids") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# unsurprisingly, with more quotas during the period 2015 to 2021, there was more successful bids during this period of time

##################################################################################################

# chart to show avg premium by year

# group by year to find out avg premium by year, round to 2 decimal places
avg_premium_by_year <- df %>%
  group_by(year) %>%
  summarize(avg_premium = round(mean(premium), 2))

# View the grouped data
View(avg_premium_by_year)

# create bar chart of avg premium by year
ggplot(avg_premium_by_year, aes(x = as.factor(year), y = avg_premium)) +
  geom_bar(stat = "identity", fill = "salmon", color = "black") +
  labs(title = "Average Premium by Year",
       x = "Year",
       y = "Average Premium ($)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# unsurprisingly, average premiums during the periods of 2015 - 2021 was lower, due mainly to the higher number of quotas
# average premiums during 2020 was also low, when compared against available quotas. This could be because it was covid period

##################################################################################################

## MACHINE LEARNING AND PREDICTIVE ANALYTICS - LINEAR REGRESSION
## PREDICT TOTAL QUOTA FOR THE MONTH OF SEP 2025

# Convert the YrMth column to a proper date format. then Group by 'YrMth' and sum the 'quota'
df_monthly <- df %>%
  mutate(YrMth = ymd(YrMth)) %>%
  group_by(YrMth) %>%
  summarize(quota = sum(quota)) %>%
  ungroup()

# Create a numerical 'time_index' feature
df_monthly <- df_monthly %>%
  mutate(time_index = (year(YrMth) - min(year(YrMth))) * 12 + (month(YrMth) - min(month(YrMth))))

# Check for NA values
# This will show how many missing values are in each column
sum(is.na(df_monthly$time_index))
sum(is.na(df_monthly$quota))

# Train the Linear Regression Model
model <- lm(quota ~ time_index, data = df_monthly)

# Predict the Quota for September 2025
start_date <- as.Date("2010-01-01")
target_date <- as.Date("2025-09-01")

# Calculate the time_index for September 2025 using the same logic as the training data
sept_2025_index <- (year(target_date) - year(start_date)) * 12 + (month(target_date) - month(start_date))

# CREATE THE 'new_data' OBJECT HERE
new_data <- data.frame(time_index = sept_2025_index)

# Make the prediction
predicted_quota <- predict(model, new_data)

cat("The predicted total quota for September 2025 is:", round(predicted_quota))
# Results: The predicted total quota for September 2025 is: 4957

##################################################################################################

## MACHINE LEARNING AND PREDICTIVE ANALYTICS - LINEAR REGRESSION
## PREDICT PREMIUM FOR THE MONTH OF SEP 2025

# Convert the YrMth column to a proper date format and aggregate
df_monthly <- df %>%
  mutate(YrMth = as.Date(YrMth, format = "%d/%m/%Y")) %>%
  group_by(YrMth) %>%
  summarize(premium = mean(premium)) %>%
  ungroup()

# Create a numerical 'time_index' feature for the regression model.
# This represents the number of months from the start of the data.
df_monthly <- df_monthly %>%
  mutate(time_index = (year(YrMth) - min(year(YrMth))) * 12 + (month(YrMth) - min(month(YrMth))))

# Train the linear regression model
model <- lm(premium ~ time_index, data = df_monthly)

# view the model's summary to see its coefficients
summary(model)

# Define the start and target dates
start_date <- as.Date("2010-01-01")
target_date <- as.Date("2025-09-01")

# Calculate the time_index for September 2025
sept_2025_index <- (year(target_date) - year(start_date)) * 12 + (month(target_date) - month(start_date))

# Create a new data frame for the prediction
new_data <- data.frame(time_index = sept_2025_index)

# Make the prediction
predicted_avg_premium <- predict(model, new_data)

# Print the final result, rounded to two decimal places
cat("The predicted average premium for September 2025 is:", round(predicted_avg_premium, 2))

# Results: The predicted average premium for September 2025 is: 62431.01


##################################################################################################

## MACHINE LEARNING AND PREDICTIVE ANALYTICS - RANDOM FOREST
## PREDICT TOTAL QUOTA FOR THE MONTH OF SEP 2025

# Convert the YrMth column to a proper date format, group, and summarize
df_monthly <- df %>%
  mutate(YrMth = ymd(YrMth)) %>%
  group_by(YrMth) %>%
  summarize(quota = sum(quota)) %>%
  ungroup()

# Create a numerical 'time_index' feature
df_monthly <- df_monthly %>%
  mutate(time_index = (year(YrMth) - min(year(YrMth))) * 12 + (month(YrMth) - min(month(YrMth))))

# Set a seed for reproducibility
set.seed(42)

# Train the Random Forest model
model_rf <- randomForest(quota ~ time_index, data = df_monthly, ntree = 100)

# Define the start and target dates
start_date <- as.Date("2010-01-01")
target_date <- as.Date("2025-09-01")

# Calculate the time_index for September 2025
sept_2025_index <- (year(target_date) - year(start_date)) * 12 + (month(target_date) - month(start_date))

# Create a new data frame for the prediction
new_data <- data.frame(time_index = sept_2025_index)

# Make the prediction
predicted_quota_rf <- predict(model_rf, new_data)

cat("The predicted total quota for September 2025 using Random Forest is:", round(predicted_quota_rf))

# Results: The predicted total quota for September 2025 using Random Forest is: 2759

##################################################################################################

## MACHINE LEARNING AND PREDICTIVE ANALYTICS - RANDOM FOREST
## PREDICT AVG PREMIUM FOR THE MONTH OF SEP 2025

# Convert the YrMth column to a proper date format and aggregate
df_monthly <- df %>%
  mutate(YrMth = ymd(YrMth)) %>%
  group_by(YrMth) %>%
  summarize(premium = mean(premium)) %>%
  ungroup()

# Create a numerical 'time_index' feature
df_monthly <- df_monthly %>%
  mutate(time_index = (year(YrMth) - min(year(YrMth))) * 12 + (month(YrMth) - min(month(YrMth))))

# Train the Random Forest Model
set.seed(42)
model_rf <- randomForest(premium ~ time_index, data = df_monthly, ntree = 100)

# Define the start and target dates
start_date <- as.Date("2010-01-01")
target_date <- as.Date("2025-09-01")

# Calculate the time_index for September 2025
sept_2025_index <- (year(target_date) - year(start_date)) * 12 + (month(target_date) - month(start_date))

# Create a new data frame for the prediction
new_data <- data.frame(time_index = sept_2025_index)

# Make the prediction
predicted_premium_rf <- predict(model_rf, new_data)

cat("The predicted avg premium for September 2025 using Random Forest is:", round(predicted_premium_rf))

# results: The predicted avg premium for September 2025 using Random Forest is: 79494

##################################################################################################

## MACHINE LEARNING AND PREDICTIVE ANALYTICS - RANDOM FOREST
## PREDICT AVG PREMIUM FOR CAT A FOR THE MONTH OF SEP 2025

# Filter for Category A, convert date, and aggregate
df_monthly_a <- df %>%
  filter(vehicle_class == "Category A") %>%
  mutate(YrMth = ymd(YrMth)) %>%
  group_by(YrMth) %>%
  summarize(premium = mean(premium)) %>%
  ungroup()

# Create a numerical 'time_index' feature
df_monthly_a <- df_monthly_a %>%
  mutate(time_index = (year(YrMth) - min(year(YrMth))) * 12 + (month(YrMth) - min(month(YrMth))))

# Set a seed for reproducibility
set.seed(42)

# Train the Random Forest model
model_rf_a <- randomForest(premium ~ time_index, data = df_monthly_a, ntree = 100)

# Define the start and target dates
start_date <- as.Date("2010-01-01")
target_date <- as.Date("2025-09-01")

# Calculate the time_index for September 2025
sept_2025_index <- (year(target_date) - year(start_date)) * 12 + (month(target_date) - month(start_date))

# Create a new data frame for the prediction
new_data <- data.frame(time_index = sept_2025_index)

# Make the prediction
predicted_premium_rf_a <- predict(model_rf_a, new_data)

cat("The predicted premium for Category A in September 2025 using Random Forest is:", round(predicted_premium_rf_a))

# Results: The predicted premium for Category A in September 2025 using Random Forest is: 98482





