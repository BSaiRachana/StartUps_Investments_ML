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
trainDataIndex <- createDataPartition(dat$post_success, p=0.8, list = F)  # 70% training data
trainData <- dat[trainDataIndex, ]
testData <- dat[-trainDataIndex, ]
table(trainData$post_success)

# Down Sample
set.seed(100)
# down_train <- downSample(x = trainData[, colnames(trainData) %ni% "post_success"],
#                           y = trainData$post_success)

# Up Sample
up_train <- upSample(x = trainData[, colnames(trainData) %ni% "post_success"],
                     y = trainData$post_success)

table(up_train$Class)
colnames(up_train)[which(names(up_train) == "Class")] <- "post_success"

set.seed(100)

## Train a logistic regression model with 10-fold cross-validation
fitControl <- trainControl(method = "cv",number = 10, verboseIter = TRUE)

gbm_fit <- train(post_success ~ ., data = trainData,
                 trControl = fitControl, method = "gbm",
                 verbose=TRUE)

# In-sample performance
confusionMatrix(gbm_fit)

# Plot resampling profile by accuracy
plot(gbm_fit)

# Plot resampling profile by kappa statistic
plot(gbm_fit, metric = "Kappa")

# Out-of-sample performance
confusionMatrix(predict(gbm_fit, newdata = testData),
                testData$post_success, positive = '1')

stopCluster(cl)
