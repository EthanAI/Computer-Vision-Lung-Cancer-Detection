function [X_trn,Y_trn,X_tst,Y_tst] = ...
    buildRandomTrainAndTest(X,Y,percentTrain)
%buildTrainAndTest builds a training and testing set based on a percent for
%training. This will be done randomly.
%   Provide a decimal percent and both input data sets


    %Get total number of observations in the dataset
    [N D] = size(X);
    %randomly split into 250 examples for training and 50 for testing
    randvector = randperm(N);

    %Calculate the number of cases for both train and testing
    trnNum = floor( N * percentTrain);
   
    %separate training and testing sets
    X_trn = X(randvector(1:trnNum),:);
    Y_trn = Y(randvector(1:trnNum));
    X_tst = X(randvector((trnNum+1):end),:);
    Y_tst = Y(randvector((trnNum+1):end));


end

