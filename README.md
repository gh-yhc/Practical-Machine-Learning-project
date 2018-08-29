## Practical-Machine-Learning-project
# Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify *how well they do it*. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).

Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.

Source: http://groupware.les.inf.puc-rio.br/har

Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions:
exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E).
Class A corresponds to the specified execution of the exercise, 
while the other 4 classes correspond to common mistakes. 

Data

The training data for this project are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

The data for this project come from this source: http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har. 


# Code Description 

After quickly checking the data with str() function, there are many near zero variance predictors that have to be removed for further analysis.

Next we choose to remove several variables that we don't want to include in model-building,
(add them to the list of near zero variance predictors).
One can use advanced statistical variables to build a model, for example, average, standard deviation, variance, skewness, kurtosis, etc., but these are not provided in the data of test cases.

Select those data without nzv predictors for further processing
create data partition (training and testing data sets)

create a report describing how you built your model, how you used cross validation, 
what you think the expected out of sample error is, 
and why you made the choices you did.

model training
In random forests, there is no need for cross-validation or a separate test set 
to get an unbiased estimate of the test set error.
It is estimated internally, during the run.
https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr

Out-of Bag error rate, confusion matrix and variable importance.
Cross-validation (not necessary for random forests): check model accuracy with test sets
Final: get model predictions for the test cases!

