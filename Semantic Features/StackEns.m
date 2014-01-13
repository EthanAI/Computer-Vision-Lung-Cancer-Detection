function [ EnsemblePrediction, EnsembleError, EnsembleSuccess, beta ] = StackEns( outputs, labels, category )
%StackEns Take the outputs from the various L0 classifiers and merge them
%into a single L1 output. 
%   Takes numerical values, outputs numerical values. Reccomend converting
%   to classifications after this step. Uses linear regression over
%   multiple variables (>2 variable) to merge them

%Add with cross validation, currently training and testing on the same set

trainFunc = @mvregress;
evalFunc = @(X, trainFunc) X * trainFunc;

[ EnsemblePrediction, EnsembleError, EnsembleSuccess, trainedStruct ] = CrossValLearn(outputs(:,:,category), labels(:,category), trainFunc, evalFunc);


beta = reshape(cell2mat(trainedStruct), 20, []); %Convert to right format
beta = mean(beta,2);

%end

