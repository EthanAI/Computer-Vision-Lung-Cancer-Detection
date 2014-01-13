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
    LIDCData = xlsread('sample_set.xlsx');
    
    %very specific to this dataset
    X = LIDCData(:,10:83);
    Y = LIDCData(:,end);
    
    %Open Matlab pool for multi-threading
    if(matlabpool('size') == 0) %checking to see if my pool is already open
       matlabpool open 4
    end
    
%% run bagging    
    rfName = 'Random Forest';
    bagName = 'Bagging';
    leafs = [1 5 10 20 50 100];
    
    tic
    disp('Running Bagging...');
    bags = runBagging(X,Y,200,leafs,0);
    disp('Bagging complete! Running Random Forest...');
    rfs = runBagging(X,Y,200,leafs,1);
    toc
    
    %close matlab pool
    matlabpool close;
    
%% graph the error
    tic
    disp('Random Forest complete! Graphing OOB...');
    graphBags(bags,leafs,bagName);
    graphBags(rfs,leafs,rfName);
    disp('Graphing Complete!');
    toc
    
%% Wrap up

    
    %send a message out
    matlabMail('Pinkjello92@gmail.com','Bagging and RF Complete!');
