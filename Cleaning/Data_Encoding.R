dat_encoded <- readRDS("/Users/vineethpenugonda/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Dataset/Data_Cleansed.rds")

# Binary Encoding

library(binaryLogic)
encode_binary <- function(x, order = unique(x), name = "v_") {
  x <- as.numeric(factor(x, levels = order, exclude = NULL))
  x2 <- as.binary(x)
  maxlen <- max(sapply(x2, length))
  x2 <- lapply(x2, function(y) {
    l <- length(y)
    if (l < maxlen) {
      y <- c(rep(0, (maxlen - l)), y)
    }
    y
  })
  d <- as.data.frame(t(as.data.frame(x2)))
  rownames(d) <- NULL
  colnames(d) <- paste0(name, 1:maxlen)
  d
}

new_df <- cbind(dat_encoded, encode_binary(dat_encoded[["market"]], name = "market_"))
head(new_df)

new_df <- cbind(new_df, encode_binary(dat_encoded[["region"]], name = "region_"))
head(new_df)

new_df <- cbind(new_df, encode_binary(dat_encoded[["state_code"]], name = "state_code_"))
head(new_df)

saveRDS(new_df, file = "Data_Cleansed_Encoded.rds")

# Filter the data and Factorize it!

filter_data <- new_df[ which(new_df$founded_year >= 1990), ]
str(filter_data)

# Datatypes
# Categorical Variables:  name, category_list, market, status, state_code, region, city, founded_at, founded_month, founded_quarter,
#                         founded_year, first_funding_day, first_funding_month, first_funding_year, last_funding_day, last_funding_month,
#                         last_funding_year

filter_data$name <- NULL
filter_data$category_list<- NULL
filter_data$market<- NULL

filter_data$status<-factor(filter_data$status)

filter_data$state_code<- NULL
filter_data$region<- NULL
filter_data$city<- NULL

filter_data$founded_at<-factor(filter_data$founded_at)
filter_data$founded_month<-factor(filter_data$founded_month)
filter_data$founded_quarter<-factor(filter_data$founded_quarter)
filter_data$founded_year<-factor(filter_data$founded_year)
filter_data$first_funding_day<-factor(filter_data$first_funding_day)
filter_data$first_funding_month<-factor(filter_data$first_funding_month)
filter_data$first_funding_year<-factor(filter_data$first_funding_year)
filter_data$last_funding_day<-factor(filter_data$last_funding_day)
filter_data$last_funding_month<-factor(filter_data$last_funding_month)
filter_data$last_funding_year<-factor(filter_data$last_funding_year)

str(filter_data)

saveRDS(filter_data, file="Data_CE_Filtered.rds")