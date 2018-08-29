## Code Description 

After quickly checking the data with str() function, there are many near zero variance predictors that have to be removed for further analysis.

We choose to remove several variables that we don't want to include in model-building,
(add them to the list of near zero variance predictors).
One can use advanced statistical variables to build a model, for example, average, standard deviation, variance, skewness, kurtosis, etc., but these are not provided in the data of test cases.

Select those data without nzv predictors for further processing
create data partition (training and testing data sets)

### Model training: Random Forests
The reason for choosing the algorithm random forests is that there is no need for cross-validation or a separate test set 
to get an unbiased estimate of the test set error. It is estimated internally, during the run.
https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr

Out-of Bag error rate, confusion matrix and variable importance.

Cross-validation (not necessary for random forests): check model accuracy with test sets

Final: get model predictions for the test cases!
