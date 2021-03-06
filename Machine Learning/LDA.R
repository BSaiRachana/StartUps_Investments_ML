library(caret)
library(doParallel)

cl <- makeCluster(detectCores())
registerDoParallel(cl)

dat <- readRDS("/Users/vineethpenugonda/Documents/Academics/Masters/Semester IV/IST 5535/Projects/StartUps_Investments_ML/Dataset/Data_Cleansed.rds")
dat$name <- NULL

# SPLIT AND UNDERSAMPLE

'%ni%' <- Negate('%in%')  # define 'not in' func
options(scipen=999)  # prevents printing scientific notations.

# Prep Training and Test data.
set.seed(100)
trainDataIndex <- createDataPartition(dat$post_success, p=0.7, list = F)  # 70% training data
trainData <- dat[trainDataIndex, ]
testData <- dat[-trainDataIndex, ]
table(trainData$post_success)

# Down Sample
set.seed(100)
down_train <- downSample(x = trainData[, colnames(trainData) %ni% "post_success"],
                         y = trainData$post_success)

table(down_train$Class)
colnames(down_train)[which(names(down_train) == "Class")] <- "post_success"

set.seed(100)

## Train a logistic regression model with 10-fold cross-validation
fitControl <- trainControl(method = "cv",number = 5, verboseIter = TRUE)

lda_fit <- train(post_success ~ ., data = down_train,
                 trControl = fitControl, method="glm", family=binomial(link='logit'),
                 verbose=TRUE)

# In-sample performance
confusionMatrix(lda_fit)

# Plot resampling profile by accuracy
plot(lda_fit)

# Plot resampling profile by kappa statistic
plot(lda_fit, metric = "Kappa")

# Out-of-sample performance
confusionMatrix(predict(lda_fit, newdata = testData),
                testData$post_success, positive = '1')

stopCluster(cl)
