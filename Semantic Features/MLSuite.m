function [ classValue, errorRate, errorHeaders, confusionMatrix, sens, spec  ] = MLSuite(X, Y, settings)
%MLSuite Runs all the base level machine learning methods on the X and Y matrices
%given using the set of options given

categories = settings.categories;
numCategories = length(categories);

clError         = zeros(1, numCategories); %To hold classification success/error rates
clHeader        = cell(1,1);

classValue   = 0;
errorRate    = 0;
errorHeaders = 0;
confusionMatrix = 0; %Code exists, but not used since changing from classes to numbers for the labels
sens = 0; %Code exists, but not used since changing from classes to numbers for the labels
spec = 0; %Code exists, but not used since changing from classes to numbers for the labels

%Note: each algo, each run will test on different rows

classValue = zeros(size(X,1), numCategories, 1);
%-------------------------------------------------------------------
% Standard Learning
%-------------------------------------------------------------------
if settings.doLearning == 1
    if settings.doTrees == 1
        %-------------------------------------------------------------------
        % Decion tree learning
        %-------------------------------------------------------------------      
        fprintf('\nDecision tree learning from mean of each group vs mean of features \n');
        clHeader = vertcat(clHeader, {'DT Mean to Mean'});
        errorVector = zeros(1, numCategories);
        for i = 1:numCategories
            fprintf('Learning and evaluating success on category: %s\t\t', str2mat(categories(i)));
            [dtClassValue(:,i), errorVector(i), ~] = CrossValLearn(X, Y(:,i), @classregtree, @(X, trainedStruct) eval(trainedStruct, X));
            %[dtClassValue(:,i), errorVector(i)] = dtLearning(X, Y, i);
            fprintf('Error: %f class Success %f\n', errorVector(i), GetClassSuccessRate(dtClassValue(:,i), Y(:,i)) );
        end
        clError = vertcat(clError, errorVector);
        classValue = cat(3, classValue, dtClassValue);
    end
    %-------------------------------------------------------------------
    % Neural Network Learning
    %-------------------------------------------------------------------
    if settings.doNN == 1
        fprintf('\nNeural Network training.\n');
        clHeader = vertcat(clHeader, {'NN'});
       
        errorVector = zeros(1, numCategories);
        for i = 1:numCategories
            fprintf('NN on category: %s ', str2mat(categories(i)));
            [nnClassValue(:,i), errorVector(i)] = nnLearning(X, Y, settings.hiddenLayer, i);
            fprintf('\t\tAverage Error: %.4f Class Success %f\n', errorVector(i), GetClassSuccessRate(nnClassValue(:,i), Y(:,i)) );
            %fprintf('Average Error: %.4f Pstdev: %.4f\n', nnEvaluation(i).Eout, nnEvaluation(i).sigmaOut);
        end
        clError = vertcat(clError, errorVector);
        classValue = cat(3, classValue, nnClassValue); 
    end

    %-------------------------------------------------------------------
    % SVM Learning
    %-------------------------------------------------------------------
    %Multiclass/Class & Probability/Continuous numerical predictions by SVM
    %never got to work reliably and was removed. I hear scikit for python
    %works good
    
    %-------------------------------------------------------------------
    % Bayesian Learning
    %-------------------------------------------------------------------
    %Does not work! Works 99%, but <1% of the samples will result in a NaN
    %prediction thus destroying all the math steps that come afterwords.
    %You can try to figure out how to fix it, or just convert NaN into 0s
    %and be fine with failing those guys. 
    if settings.doBayes == 1   
        fprintf('\nNaieve Bayes Learning.\n');
        clHeader = vertcat(clHeader, {'Bayes'});        
        errorVector = zeros(1, numCategories);
        
        for i = 1:numCategories
            fprintf('Bayes on category: %s ', str2mat(categories(i)));
            [bayesClassValue(:,i), errorVector(i), ~] = CrossValLearn(X, Y(:,i), ...
                @(X, Y) NaiveBayes.fit(X, Y, 'Distribution', 'kernel'),...
                @(X, trainedStruct) posterior(trainedStruct, X, 'HandleMissing', 'On') ...
                );
            fprintf('\t\tAverage Error: %.4f Class Success %f\n', errorVector(i), GetClassSuccessRate(bayesClassValue(:,i), Y(:,i)) );
        end
        clError = vertcat(clError, errorVector);
        classValue = cat(3, classValue, nnClassValue); 
    end

    %-------------------------------------------------------------------
    % Ensemble Learning (Still a first layer classifier)
    %-------------------------------------------------------------------
    if settings.doBagging == 1
        %-------------------------------------------------------------------
        % Bagging
        %-------------------------------------------------------------------
        fprintf('\nPerforming Bagging\n');
        clHeader = vertcat(clHeader, {'Bagging Trees'});
        for i = 1:numCategories
            fprintf('Learning and evaluating success on category: %s\n', str2mat(categories(i)));
            tBag = TreeBagger(settings.numTrees, X, Y(:,i), 'method', 'regression', 'OOBPred', 'on', 'NPrint', 25);% , 'minleaf', 15);
            %errorArray = oobError(tBag);
            %errorVector(i) = errorArray(end);

            %bagClassValue(:,i) = predict(tBag, X); %tBag consists of
            %trees that don't apply to all data. Some trees were
            %trained with certain points! Therefore not all trees can
            %be applied to each observation. 
            bagClassValue(:,i) = oobPredict(tBag);
            errorVector(i) = RMSE(bagClassValue(:,i), Y(:,i));
            fprintf('Error: %f classSuccess %f\n', errorVector(i), GetClassSuccessRate(bagClassValue(:,i), Y(:,i)) );
            %For regression bagClassProb is just the standard
                %deviation across all the trees, so its kind of an
                %indication
            if settings.doPlot == 1
                %plot the change over time. Real slow so might as well look at something
                figure;
                plot(oobError(tBag));
                xlabel('number of grown trees');
                ylabel('out-of-bag regression error');
                title(str2mat(categories(i)));
            end
        end
    clError = vertcat(clError, errorVector);
    classValue = cat(3, classValue, bagClassValue);
    end
end

%-------------------------------------------------------------------
% Compile results
%-------------------------------------------------------------------
%clError = horzcat(clError, mean(clError, 2));
%bagError = horzcat(bagError, mean(bagError, 2));
%nnError = horzcat(nnError, mean(nnError, 2));
%allErrors = vertcat(clError, bagError);
%allErrors = vertcat(allErrors, nnError);
%averageError = [mean(clError, 2);mean(bagError, 2);mean(nnError, 2)];
%Remove blank lines at the beginning. This was the easiest way I found to
%1. Guarantee variable initialized to keep matlab from complaining and 2.
%Have an unspecified length, so you don't have to rework the code if you
%add more classifiers to the mix, or turn some of them off in the settings.
errorRate = clError(2:end,:);
errorHeaders = clHeader(2:end);
classValue = classValue(:,:,2:end);


