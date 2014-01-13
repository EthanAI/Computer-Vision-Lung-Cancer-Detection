%% Script Description
% A script that runs both RUSBoosting and plots the final ensemble 
% error.


%% Setup the workspace and load the data

    %clean up the variables and remove from the console window.
    clear all;
    clc;
    close all;
    
    addpath('data');
    %load radiologist's dataset
    load('large slice radiologists.mat');
    X = Xlargest;
    %round the averaged ratings
    Y = round(Yaverage);

%% Run RUSBoost

    [allModels, allTraining, allTesting] = runRUSBoosting(X,Y);

%% Plot the error for both training the testing

    tic
    plotEnsError( allModels,allTesting,X,Y,'Testing Accuracy');
    plotEnsError( allModels,allTraining,X,Y,'Training Accuracy');
    toc
