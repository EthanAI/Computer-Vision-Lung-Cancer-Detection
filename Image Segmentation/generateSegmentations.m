%% generateSegmentations.m
%Patrick Stein 8/20/2013
%This will run both otsu and region growing segmentations and create the
%appropriate masks for both otsu and RG.
%
% Before you run this script make sure to 

%% Clear workspace 

    clear all;
    close all;
    clc;
%% Setup workspace for image segmentation
    %The folder with all of your DICOM images you wish to segment
    folderWithImages = '\\ailab03\WeakSegmentation\2k largest slice crops';
    %The number of classes you want for Otsu
    otsuClassNumber = 5;
    %Start threshold for RG
    rgStart = 0.0005;
    %Ending threshold
    rgEnd = 0.0021;
    %In what increments should the threshold be increased.
    rgInc = 0.0003;
    
    %add paths to utility functions and segmentations
    addpath(genpath('..\Image Segmentation'));

    %Open Matlab pool for multi-threading
    if(matlabpool('size') == 0) %checking to see if my pool is already open
       matlabpool open 4
    end
    %start timer
    tic
    %Turn off warnings briefly because parfor loop will get very angry at
    %variables being declared even though they are temporary
    warning('off','all');
%% Generate segmentations
    disp('Beginning Otsu...');
    [otsuImages] = runOtsu(folderWithImages,otsuClassNumber);
    disp('Otsu complete! Beginning Region Growing...');
    [rgImages] = runRegionGrowing(folderWithImages,rgStart,rgEnd,rgInc);
    disp('Region Growing Complete!');
    
%% Wrap up after segmentation
    %close matlab pool
    matlabpool close;
    %turn warnings back on
    warning('on','all');
   
 %% Generate masks
    disp('Generating masks...');
    otsuImages = createMasks(otsuImages);
    rgImages = createMasks(rgImages);
    disp('Mask generation complete!');
%% Wrap up
    toc

    %send a message out
    matlabMail('Pinkjello92@gmail.com','Segmentation Complete');
    