library(caret)
library(doParallel)
library(tree)

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

# Down Sample
set.seed(100)
down_train <- downSample(x = trainData[, colnames(trainData) %ni% "post_success"],
                         y = trainData$post_success)

str(down_train)

table(down_train$Class)
colnames(down_train)[which(names(down_train) == "Class")] <- "post_success"

set.seed(100)

# Fit a decision tree
tree_churn <- tree(post_success ~ ., data = dat)

# Summary of the decision tree
summary(tree_churn)

# Plot the decison tree
plot(tree_churn)
text(tree_churn, cex = 0.75, col = 'red')

stopCluster(cl)
