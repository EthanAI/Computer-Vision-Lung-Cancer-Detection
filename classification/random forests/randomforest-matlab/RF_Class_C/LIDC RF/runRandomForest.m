function [] = runRandomForest(fileNameX,fileNameY)
%RUNRANDOMFOREST runs the random forest algorithm for a given set of files.
%   Detailed explanation goes here



%% Setup random forest code

    %add all paths to random forest directory
    addpath(genpath(['C:\Users\PSTEIN4\Desktop\matlab-code-summer-'....
        'research-2013\random forests\randomforest-matlab\RF_Class_C']));

    %compile everything
    if strcmpi(computer,'PCWIN') |strcmpi(computer,'PCWIN64')
       compile_windows;
    else
       compile_linux;
    end

%% Load data and transform into a usable form

    %load the dataset provided
    %Get the feature excel file
    X = xlsread(fileNameX);
    %Get the class label file
    Y = xlsread(fileNameY);

    %get malignancy semantic column
    Y = Y(:,7);
    
    %get size of image features
    [~, D] = size(X);
    
    
%% Build training and testing set
    [X_trn,Y_trn,X_tst,Y_tst] = buildRandomTrainAndTest(X,Y,0.75);


%% Run random forest
%external impl
% example 1:  simply use with the defaults
    model = classRF_train(X_trn,Y_trn,1000);
    Y_hat = classRF_predict(X_tst,model);
    fprintf('\nexample 1: error rate %f\n',... 
            length(find(Y_hat~=Y_tst))/length(Y_tst));
    
    figure('Name','OOB error rate');
    plot(model.errtr(:,1)); title('OOB error rate');  
    xlabel('iteration (# trees)'); ylabel('OOB error rate');

%Matlab impl

    b = TreeBagger(1000,X,Y,'OOBPred','on','NVarToSample',sqrt(D));
    figure('Name','MATLAB impl');
    plot(oobError(b));
    xlabel('number of grown trees');
    ylabel('out-of-bag classification error');
end

