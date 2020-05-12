#source('~/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Cleaning/Cleaning.R')
#source('~/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Cleaning/Data_Encoding.R')

str(dat)

datWork <- dat
datWork$market <- factor(datWork$market)
str(datWork)
