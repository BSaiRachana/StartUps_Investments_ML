library(caret)
library(doParallel)

cl <- makeCluster(detectCores())
registerDoParallel(cl)

dat <- readRDS("/Users/vineethpenugonda/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Dataset/Data_CE_Filtered.rds")

# SPLIT AND UNDERSAMPLE

'%ni%' <- Negate('%in%')  # define 'not in' func
options(scipen=999)  # prevents printing scientific notations.

# Prep Training and Test data.
set.seed(100)
trainDataIndex <- createDataPartition(dat$post_success, p=0.7, list = F)  # 70% training data
trainData <- dat[trainDataIndex, ]
testData <- dat[-trainDataIndex, ]
table(trainData$post_success)

# Up Sample
set.seed(100)
up_train <- upSample(x = trainData[, colnames(trainData) %ni% "post_success"],
                         y = trainData$post_success)

table(up_train$Class)
colnames(up_train)[which(names(up_train) == "Class")] <- "post_success"

set.seed(100)

## Train a logistic regression model with 10-fold cross-validation
fitControl <- trainControl(method = "cv",number = 10, verboseIter = TRUE)


svmRadial_fit <- train(post_success ~ ., data = up_train,
                       trControl = fitControl, method = "svmRadial",
                       verbose=TRUE)

# In-sample performance
confusionMatrix(svmRadial_fit)

# Plot resampling profile by accuracy
plot(svmRadial_fit)

# Plot resampling profile by kappa statistic
plot(svmRadial_fit, metric = "Kappa")

# Out-of-sample performance
confusionMatrix(predict(svmRadial_fit, newdata = testData),
                testData$post_success, positive = "1")

stopCluster(cl)
