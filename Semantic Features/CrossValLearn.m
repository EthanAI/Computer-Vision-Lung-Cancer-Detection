function [ classValue, regError, successRate, trainedStruct ] = CrossValLearn2(X, Y, trainFunc, evalFunc)
%CrossValLearn does cross validation learning 
%  You need to supply it the function used to run the training and make the
%  prediction. Hardcoded to do 10 folds

%Perform random sampling by just jumbling up the data then slicing the new
%set into 4ths or nths.
divisions = 10;
numSamples = size(X,1);
testSize = round(numSamples/divisions);

%get a random order of our rows
randomRows = randsample(numSamples, numSamples);

%get vector of row order to undo the scrambling of the rows
for i = 1:numSamples
    restoreRows(i) = find(i == randomRows);
end

Xmixed = X(randomRows,:);
Ymixed = Y(randomRows,:);

%perform process repeatedly with the test set different each time untill
%all are covered.
classValue = 0;
testrows = cell(divisions,1);
trainedStruct = cell(divisions,1);
for i = 1:(divisions - 1) %perform all iterations guaranteeed to have a full share
    %start with testing at the beginning rows, then cycle down
    testrows{i} = [(i-1)*testSize + 1:i*testSize];
    
    Xtest = Xmixed(testrows{i}, :);
    Ytest = Ymixed(testrows{i}, :);
    
    Xtrain = Xmixed;
    Xtrain(testrows{i},:) = [];
    Ytrain = Ymixed;
    Ytrain(testrows{i},:) = [];
    
    trainedStruct{i} = trainFunc(Xtrain, Ytrain);
    classValue = vertcat(classValue, evalFunc(Xtest, trainedStruct{i}));
end
%collect all the remaining rows. Could be undersized, but eliminates
%problems of some rows getting lost
testrows{divisions} = [(divisions-1)*testSize + 1:numSamples];
    
Xtest = Xmixed(testrows{divisions}, :);
Ytest = Ymixed(testrows{divisions}, :);

Xtrain = Xmixed;
Xtrain(testrows{divisions},:) = [];
Ytrain = Ymixed;
Ytrain(testrows{divisions},:) = [];
    
trainedStruct{divisions} = trainFunc(Xtrain, Ytrain);
classValue = vertcat(classValue(2:end,:), evalFunc(Xtest, trainedStruct{divisions})); %Chop off the zero we put at the beginning

%Resort everything to the original order so we can compare against other
%algorithms
classValue = classValue(restoreRows,:);

%perform RMSE on allll the samples
regError = RMSE(classValue, Y); %RMSE error. Maybe better as an array so we can combine in the future

successRate = sum(round(classValue) == round(Y)) / size(Y,1);


end


