function plotEnsError( allModels,ist,X,Y,figureName)
%PLOTENSERROR Plots the ensemble error for each semantic rating in a single
%figure.
%
%   param allModels
%       a cell array containing a model for each semantic characteristic.
%   param ist
%       a cell matrix indicating which values are testing for each semantic 
%       characteristic. Sidenote: I think training error can be plotted the
%       same way by passing the allTraining cell matrix instead of the 
%       allTesting cell matrix.
%   param X
%      This is the data that is input matrix that contains image features
%      calculated from nodules in the LIDC.
%   param Y
%      This is a cell matrix that contains semantic ratings from the LIDC.
%
%   param figureName
%      A string indicating the name of the figure. Example: 'Testing Error'


%% Setup

    %Semantic labels
    label = {'Subtlety', 'Sphericity', 'Margin', 'Lobulation',... 
              'Spiculation', 'Texture', 'Malignancy'};
          
    n = size(allModels,2);
    
    subplotX = 4;
    subplotY = 2;
     
    figure('name',figureName);    
%% Plot error rate of all models
    for i=1:n
        
        %build testing sets
        testingY = Y(:,i);
        testingX = X(ist{i},:);
        testingY = testingY(ist{i});
        
        %plot the error
        subplot(subplotY,subplotX,i);
        %This is for if you do kfold cross-validation
        %L = kfoldLoss(allModels{i},'mode','average');
        L = loss(allModels{i},testingX,testingY,'mode','cumulative');
        L = 1-L;
        plot(L);
        title(label{i});
        grid on;
        xlabel('Number of iterations');
        ylabel('Test accuracy');
    end

end

