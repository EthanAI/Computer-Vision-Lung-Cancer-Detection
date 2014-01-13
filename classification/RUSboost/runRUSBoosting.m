function [allModels, allTraining, allTesting] = runRUSBoosting(X,Y)
%RUNRUSBOOSTING runs RUSBoost on a given LIDC dataset broken into two
%parameters, X and Y.
%   param X
%      This is the data that is input matrix that contains image features
%      calculated from nodules in the LIDC.
%   param Y
%      This is a cell matrix that contains semantic ratings from the LIDC.
%   return allModels
%      a cell array containing a model for each semantic characteristic.
%   return allTraining
%      a cell matrix indicating which values are testing for each semantic 
%      characteristic.
%   return allTesting
%      a cell matrix indicating which values are training for each 
%      semantic characteristic.
                 


%% Setup the data and the labels
    %number of semantic classes in the array 'Y'
    n = size(Y,2);
    
    %Semantic labels
    labels = {'Subtlety', 'Sphericity', 'Margin', 'Lobulation',... 
              'Spiculation', 'Texture', 'Malignancy'};
  
    %create a cell array containing the models
    allModels = cell(1,1);
    allTraining = cell(1,1);
    allTesting = cell(1,1);

    %Show distribution for each semantic label
    for i = 1:n
        fprintf('%s%s\n','Tabulation for: ', labels{i});
        tabulate(Y(:,i));
    end
      
    %create weak learner template for RUSBoosting to build an ensemble on
    % TODO: CHANGE THESE PARAMS TO SOMETHING ELSE
    t = ClassificationTree.template('MinParent',60,'minleaf',30);
    
%% Build testing and training sets
    
    %build training and testing sets
    for i=1:n
        part = cvpartition(Y(:,i),'holdout',0.25);
        allTraining{i} = training(part);
        allTesting{i} = test(part);
    end  
    
%% Run RUSBoosting

    %iterate through each semantic class label and run boosting
    for i=1:n
        fprintf('Growing ensemble for: %s\n',labels{i});
        tic
        tempY = Y(:,i);
        tempY = tempY(allTraining{i});
        tempX = X(allTraining{i},:);
        %run the RUSboost on a semantic label
        allModels{i} = fitensemble(tempX,tempY,'RUSBoost',1500,t,...
            'LearnRate',0.1,'nprint',100);
        toc
        
    end

