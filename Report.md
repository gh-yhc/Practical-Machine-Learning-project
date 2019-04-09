## Code Description 

1. After quickly checking the data with str() function, there are many near zero variance predictors that have to be removed for further analysis. We choose to remove several variables that we don't want to include in model-building by adding them to the list of near zero variance (NZV) predictors. One can use advanced statistical variables to build a model, for example, average, standard deviation, variance, skewness, kurtosis, etc., but these are not provided in the data of test cases.
2. Select those data without NZV predictors for further processing
3. Create data partition (training and testing data sets)
4. Model training: Multipled models are tested but not surprisingly, Random Forests algorithm gives best accuracy with the expense of computation time.
Note that in random forests, data are sampled with replacement, 
the estimation of out-of-sample error is performed on a test set, 
so there is no need to repeat the cross-validation process outside the model.
5. Calculate Out-of-Bag error rate, confusion matrix and variable importance.
6. Cross-validation (not necessary for random forests): check model accuracy with test sets
7. Final: get model predictions for the test cases!
