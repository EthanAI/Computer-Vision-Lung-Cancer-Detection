function [ classValue, errorRate ] = nnLearning( X, Y, hiddenLayerSize, category )
% nnLearning trains a nn classifier and outputs the predictions
%    Just using matlabs NN package. Make sure you have it (AILAB02 does
%    not).

%Gives outputs and predictions on everything. Assuming it is doing nFold
%validation
inputs = X';
targets = Y(:,category)'; %using wrong dimension? thats why getting 7s?

% Create a Fitting Network
net = fitnet(hiddenLayerSize);


% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
net.trainParam.showWindow = false; %Hide the GUI window
net.trainParam.showCommandLine = false; 
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
classValue = outputs;
%install a max and min value
classValue = min(classValue, 5);
classValue = max(classValue, 1);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs); %MSE apparently

%RMSE Error
errorRate = RMSE(net(inputs)', targets');

close all

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotfit(net,inputs,targets)
%figure, plotregression(targets,outputs)
%figure, ploterrhist(errors)
