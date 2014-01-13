function [rusTree, istrain, istest] = runSRB(X,Y)
%RUNSRB Summary of this function goes here
%   Detailed explanation goes here


%% Transform data into a usable form

    %Semantic labels
    label = 'Sphericity';

    %Show distribution for semantic label
    fprintf('%s%s\n','Tabulation for: ', label);
    tabulate(Y);

      
    %create weak learner template for RUSBoosting to build an ensemble on
    % TODO: CHANGE THESE PARAMS TO SOMETHING ELSE
    t = ClassificationTree.template();
    
%% Build testing and training sets
    
    %build training and testing sets

    part = cvpartition(Y,'holdout',0.25);
    istrain = training(part);
    istest = test(part);

    
%% Run RUSBoosting

    %build training sets
    trainingX = X(istrain,:);
    trainingY = Y(istrain);
    
    %Run a decision tree
    %tree = ClassificationTree.fit(trainingX,trainingY);
    
    %run the RUSboost on a semantic label
    rusTree = fitensemble(trainingX,trainingY,'RUSBoost',1000,'Tree',...
        'LearnRate',1,'nprint',100);
%% Plot error rate

    %build testing sets
    testingX = X(istest,:);
    testingY = Y(istest);
    
    figure;
    plot(loss(rusTree,testingX,testingY,'mode','cumulative'));
    grid on;
    xlabel('Number of trees');
    ylabel('Test classification error');
    disp('end');

end

