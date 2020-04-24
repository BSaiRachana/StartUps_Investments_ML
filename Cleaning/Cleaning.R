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
# Categorical Variables:  market, status, country_code, state_code

# Saving file
write.csv(dat,'Data_Cleansed.csv')
