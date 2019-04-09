### Project
# Source: http://groupware.les.inf.puc-rio.br/har
# Six young health participants were asked to perform 
# one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl 
# in five different fashions:
# exactly according to the specification (Class A), 
# throwing the elbows to the front (Class B), 
# lifting the dumbbell only halfway (Class C), 
# lowering the dumbbell only halfway (Class D) and 
# throwing the hips to the front (Class E).
# Class A corresponds to the specified execution of the exercise, 
# while the other 4 classes correspond to common mistakes. 

fileUrl1 ="https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
fileUrl2 ="https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

#if(!file.exists("./data")){dir.create("./data")}
#download.file(fileUrl1,destfile="./training.csv",method="curl")
#download.file(fileUrl2,destfile="./testing.csv",method="curl")
# method="curl" doesn't work

#download.file(fileUrl1,destfile="./training.csv")
#download.file(fileUrl2,destfile="./testing.csv")
library(caret)
HAR0<- read.csv("./training.csv")
testcases0<- read.csv("./testing.csv")
#str(testcases0)
#summary(testcases0)

# After quickly checking the data with str() function, there are many near zero variance (NZV) predictors that have to be removed for further analysis.
nzvp <- nearZeroVar(testcases0)
nzvp
length(nzvp)
# nzvp<-nearZeroVar(HAR0,saveMetrics = T)
# nzvp
# Next we choose to remove several variables that we don't want to include in model-building by adding them to the list of near zero variance predictors).
# One can use advanced statistical variables to build a model, for example, average, standard deviation, variance, skewness, kurtosis, etc.,
# but these are not provided in the data of test cases.
nzvp<-c(1:5,7,nzvp)
nzvp
length(nzvp)

# Select those data without NZV predictors for further processing
HAR<-HAR0[,-nzvp]
testcases<-testcases0[,-nzvp]
dim(testcases)
sum(testcases=="NA")

# create data partition (training and testing data sets)
inTrain <- createDataPartition(y=HAR$classe, p=0.7, list=FALSE)
training <- HAR[inTrain, ]
testing <- HAR[-inTrain, ]
dim(training)
sum(training=="NA")
dim(testing)
sum(testing=="NA")

table(training$classe)

# create a report describing how you built your model, how you used cross validation, 
# what you think the expected out of sample error is, 
# and why you made the choices you did.

### model training

# # rpart: 9 secs! but accuracy is low
ptm <- proc.time()
#modRP<-train(classe~.,data=training,method="rpart",preProcess="pca")
modRP<-train(classe~.,data=training,method="rpart")
proc.time()-ptm

modRP$preProcess
str(modRP$preProcess)
modRP$preProcess$rotation
imp<-varImp(modRP)
imp

plot(modRP$finalModel, uniform=TRUE, main="Classification Tree")
text(modRP$finalModel, use.n=TRUE, all=TRUE, cex=.8)
library(rattle)
fancyRpartPlot(modRP$finalModel)

# glm: Something is wrong; all the Accuracy metric values are missing:
# lm: Error: wrong model type for classification

## lda: 7~16 secs! linear discriminant analysis, Accuracy : 0.7021
ptm <- proc.time()
#modLDA<-train(classe~.,data=training,method="lda",preProcess="pca",na.action=na.omit)
modLDA<-train(classe~.,data=training,method="lda",na.action=na.omit)
proc.time()-ptm
varImp(modLDA)

# gbm: ~22 mins, boosting with trees, accuracy:0.9621
ptm <- proc.time()
modGBM<-train(classe~.,data=training,method="gbm",na.action=na.omit,
                 trControl=trainControl(allowParallel = T),verbose=F)
proc.time()-ptm
varImp(modGBM)

## nb: ~23 mins Naive Bayes, accuracy:0.7281
ptm <- proc.time()
modNB<-train(classe~.,data=training,method="nb",na.action=na.omit,
                 trControl=trainControl(allowParallel = T))
proc.time()-ptm
varImp(modNB)

## rf: ~49 mins, accuracy:0.992
#?randomForest
# In random forests, data are sampled with replacement, 
# the estimation of out-of-sample error is performed on a test set, 
# so there is no need to repeat the cross-validation process outside the model.

ptm <- proc.time()
modRF<-train(classe~.,data=training,method="rf",ntree=5,tuneGrid=data.frame(mtry=6))
proc.time()-ptm

# Out-of Bag error rate and confusion matrix:
modRF$finalModel

# variable importance:
varImp(modRF)

#plot(modRF)
#modRF$finalModel$err.rate
#colnames(modRF$finalModel$err.rate)
plot(modRF$finalModel$err.rate[,1],xlab="trees",ylab="Random Forests Out-of-Bag error",
     main = "OOB",type = "l")
#modRF$finalModel$confusion
#str(modRF$finalModel)

# train(..., trControl=trainControl(allowParallel = T) ) 
# for large number of predictors or samples across multiple cores

# Cross-validation (not necessary for random forests): check model accuracy with test sets
model<-modRF
pred1<-predict(model,testing)
length(pred1)
confusionMatrix(pred1,testing$classe)

# Final: get model predictions for the test cases!
pred2<-predict(model,testcases)
length(pred2)
pred2

# ntree=2, Accuracy : 0.9325, prediction: B A B A A E C B A A B C E A E E A B B B
# roll_belt            100.000
# pitch_forearm         52.111
# magnet_dumbbell_y     51.725
# yaw_belt              43.789
# magnet_dumbbell_z     40.223
# roll_forearm          34.144
# pitch_belt            28.953

# ntree=5, Accuracy : 0.9844, prediction: B A B A A E D B A A B C B A E E A B B B
# roll_belt         100.000
# pitch_forearm      59.363
# yaw_belt           50.738
# pitch_belt         42.737
# magnet_dumbbell_z  40.023
# magnet_dumbbell_y  34.069

# ntree=500, Accuracy : 0.992, prediction: B A B A A E D B A A B C B A E E A B B B
# roll_belt            100.000
# pitch_forearm         60.192
# yaw_belt              52.544
# pitch_belt            44.021
# magnet_dumbbell_y     43.626
# magnet_dumbbell_z     42.814

#save(modRF,modNB,modGBM,file="mod_RF_NB_GBM.Rdata")
#load("./mod_RF_NB_GBM.Rdata")
#savehistory("./.Rhistory")

#for (ii in 1:dim(testcases)[2]) { print(ii); print( testcases[,ii] ) }

