# Load a CSV file from your computer
coebiddingprice <- read.csv("C:/Users/Lee/OneDrive/Data Projects/COE Prices/COEBiddingResultsPrices - MySQL Cleaned.csv")

# View the entire dataset
View(coebiddingprice)

#inspect table
str(coebiddingprice)

# install lubridate library
install.packages("lubridate")

# load lubridate library
library(lubridate)

#inspect table
str(coebiddingprice)

#statistical overview
summary(coebiddingprice)

# concert YrMth col from chr/str to date
coebiddingprice$YrMth <- dmy(coebiddingprice$YrMth)

#inspect table
str(coebiddingprice)

# View the entire dataset
View(coebiddingprice)

# install and load dplyr library
install.packages("dplyr")
library(dplyr)

# group by year to find out total number of quota by year
total_quota_by_year <- coebiddingprice %>%
  group_by(year) %>%
  summarize(total_quota = sum(quota))

# View the grouped data
View(total_quota_by_year)

# install and load ggplot2 library
install.packages("ggplot2")
library(ggplot2)

# create bar chart of quota by year
ggplot(total_quota_by_year, aes(x = as.factor(year), y = total_quota)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Total Quota by Year",
       x = "Year",
       y = "Total Quota") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# chart shows the period 2015 to 2021 having more quotas

# group by year to find out total number of successful bids by year
total_successful_bids_by_year <- coebiddingprice %>%
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

# group by year to find out avg premium by year, round to 2 decimal places
avg_premium_by_year <- coebiddingprice %>%
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



