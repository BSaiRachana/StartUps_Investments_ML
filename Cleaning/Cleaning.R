library(lubridate)

setwd("/Users/vineethpenugonda/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Dataset/")
dat <- read.csv("/Users/vineethpenugonda/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Dataset/US_StartUps_Investments_Data.csv", na.strings = c("", "NA"), stringsAsFactors = FALSE)
str(dat)

# Replacing commas in the column - funding_total_usd
dat$funding_total_usd <- as.numeric(gsub(",","",dat$funding_total_usd))

# Remove rows with NAs
dat <- dat[complete.cases(dat),]

# Remove trailing spaces in column - market
dat$market <- trimws(dat$market, which = c("both"))

# Remove city, homepage_URL and X
dat$homepage_url <- NULL
dat$X <- NULL
dat$permalink <- NULL
dat$country_code <- NULL

# Strip values in columns
# Remove Year
dat$founded_month = substring(dat$founded_month,6)
dat$founded_month = as.numeric(dat$founded_month)
# Remove Year
dat$founded_quarter = substring(dat$founded_quarter,6)
# YY/MM/DD. We only need the day.
dat$founded_at = substring(dat$founded_at,9)
dat$founded_at = as.numeric(dat$founded_at)

# Date DataType
dat$first_funding_at <- as.Date(dat$first_funding_at)
dat$last_funding_at <- as.Date(dat$last_funding_at)

# Separate date into three columns
dat$first_funding_day <- day(ymd(dat$first_funding_at))
dat$first_funding_month <- month(ymd(dat$first_funding_at)) 
dat$first_funding_year <- year(ymd(dat$first_funding_at))

dat$last_funding_day <- day(ymd(dat$last_funding_at))
dat$last_funding_month <- month(ymd(dat$last_funding_at)) 
dat$last_funding_year <- year(ymd(dat$last_funding_at))

# Remove Funding Dates
dat$first_funding_at <- NULL
dat$last_funding_at <- NULL

str(dat)

# Datatypes
# Categorical Variables:  name, category_list, market, status, state_code, region, city, founded_at, founded_month, founded_quarter,
#                         founded_year, first_funding_day, first_funding_month, first_funding_year, last_funding_day, last_funding_month,
#                         last_funding_year

# dat$category_list<-factor(dat$category_list)
# dat$market<-factor(dat$market)
# dat$status<-factor(dat$status)
# dat$state_code<-factor(dat$state_code)
# dat$region<-factor(dat$region)
# dat$city<-factor(dat$city)
# dat$founded_at<-factor(dat$founded_at)
# dat$founded_month<-factor(dat$founded_month)
# dat$founded_quarter<-factor(dat$founded_quarter)
# dat$founded_year<-factor(dat$founded_year)
# dat$first_funding_day<-factor(dat$first_funding_day)
# dat$first_funding_month<-factor(dat$first_funding_month)
# dat$first_funding_year<-factor(dat$first_funding_year)
# dat$last_funding_day<-factor(dat$last_funding_day)
# dat$last_funding_month<-factor(dat$last_funding_month)
# dat$last_funding_year<-factor(dat$last_funding_year)



# Create new column: Success or not Success
# Acquired, post_ipo_equity or post_ipo_equity and Acquired

dat$post_success <- ifelse(dat$status=="acquired", 1,
               ifelse(dat$post_ipo_equity > 0, 1,
                      ifelse((dat$status=="acquired") && (dat$post_ipo_equity > 0), 1,
                                    0  ))) # all other values map to 0

dat$post_success <- factor(dat$post_success)

str(dat)

# Saving file
write.csv(dat,'Data_Cleansed.csv')
saveRDS(dat, file = "Data_Cleansed.rds")