%This is the main file to run for the weak segmentation semantic
%predictions. Assumes you have feature data already extracted from images
%and stored in csv files. This reads them and feeds them to a suite of
%machine learning algorithms, then uses the results to perform stacked
%generalization to merge them all into a single value. 
fprintf('*********************************************************************\n');
fprintf('Beginning Execution\n');
tic;
close all;
%clear all;
%load('sourceData.mat'); %Just a shortcut if you rerun the script. Wont exist the first run

%Variables for data set
rebuildRTMatrices = 0; %flag that we are loading saved X and Y matrices to reduce repeating old calculations
reloadWSMatrices  = 0;
doWSEns           = 1;
minAgreement      = 1; %Ignore data if fewer than this many radiologists rated it
%Variable for data output
doSave             = 0;
doPlot             = 0; %Will need fixing if you want it working again. 

%Options for learning which will be passed
settings.doLearning  = 1;
settings.doTrees     = 1;
settings.doBagging   = 1;
settings.doNN        = 0;
settings.doBayes     = 0; %not 100% working
%Options for learning parameters
settings.numTrees    = 10; %100; %Bagging number of trees to make

settings.hiddenLayer = 5; % 50; %Neural Network hidden nodes 60 was the max the ram could handle. More always gave improvement. 

%Misc Data to pass
settings.categories      = {'Subtlety', 'Sphericity', 'Margin   ', 'Lobulation', 'Spiculation', 'Texture', 'Malignancy'};
numCategories = length(settings.categories);

%-------------------------------------------------------------------
% Prepare the X and Y matrices for each method type we want to perform
%-------------------------------------------------------------------
%Build X and Y from radiologists' data
if rebuildRTMatrices == 1
    [Xraw, Yraw, instanceID, settings.ratingRow, data, histos ] = GetRadData(minAgreement);
    fprintf('Getting the average rating for each nodule\n'); 
    [Yaverage, instanceOrder] = GetAveragedMatrix(Yraw, settings.ratingRow, instanceID);
    fprintf('Getting the image features from the largest outline of each nodule\n'); 
    load('idstouse.mat');
    Xlargest = GetLargestMatrix(Xraw, IDsToUse, instanceID);
    %get Xaverage for the rand comparison
    [Xaverage, instanceOrder] = GetAveragedMatrix(Xraw, settings.ratingRow, instanceID);
end

%Build X from weakly segmented features
if reloadWSMatrices == 1
    [Xws, numSegments] = GetXws(instanceID); %raw version
    [XwsMulti, YwsMulti] = GetXwsSampleConcat(Xws, Yaverage, numSegments);
end

settings.histos = histos;
settings.doPlot = doPlot;

fprintf('\nPerforming Relative Truth Learning');
[ rtClassValue, rtRegError, rtErrorHeaders, rtConfusionMatrix, rtSens, rtSpec  ] = MLSuite(Xlargest, Yaverage, settings);

%fprintf('\nPerforming learning on segment features'); %With 10
%segmentations, this data is just too big for NN to handle. WSEns has good
%performance anyhow. 
%[ wsClassValue, wsRegError, wsErrorHeaders, wsConfusionMatrix, wsSens, wsSpec  ] = MLSuite(Xws, Yaverage, settings);

if doWSEns == 1
    fprintf('\nPerforming WS learning, each segmentation sent to a different classifier'); %loop over segments sets
    clear wsMultiClassValue wsMultiRegError wsMultiErrorHeaders wsMultiConfusionMatrix wsMultiSens wsMultiSpec

    startRow = 0;
    finishRow = 0;
    setLength = size(Xws,1);
    for i = 1:numSegments
        fprintf('\nTraining on segmentation #: %d', i);
        startRow = 1 + (i-1) * setLength;
        if i == numSegments %Last set has unusual length
            finishRow = size(XwsMulti,1);
        else
            finishRow = i * setLength;
        end
        [ wsMultiClassValue(:,:,:,i), wsMultiRegError(:,:,i), wsMultiErrorHeaders(:,i), wsMultiConfusionMatrix(:,:,:,i), wsMultiSens(:,i), wsMultiSpec(:,i)  ] = MLSuite(XwsMulti(startRow:finishRow,:), YwsMulti(startRow:finishRow,:), settings);
    end
end

%add a random matrix for comparison
fprintf('\nPerforming Learning on randomized features (garbage)');
Xrand = rand(size(Xaverage,1), size(Xaverage,2));  
[ randClassValue, randRegError, randErrorHeaders, randConfusionMatrix, randSens, randSpec  ] = MLSuite(Xrand, Yaverage, settings);

%-------------------------------------------------------------------
% Summarize L0 Results
%-------------------------------------------------------------------
clear rtOverRandReg rtOverWSReg rtOverRandSuccess rtOverWSSuccess rtClassSuccess
clear wsClassSuccess randClassSuccess


%sum(round(rtClassValue(:,:,3)) == round(Yaverage))/size(Yaverage,1)
%tabulate()
%sum(num2RadClass(rtClassValue(:,:,3)) == num2RadClass(Yaverage))/size(Yaverage,1)

%Final comparsions. Turn back into classifications and compare to the
%targets. (Best after ensemble learning)
for i = 1:size(rtRegError,1)
    %rtClassSuccess(i,:) = sum(num2RadClass(rtClassValue(:,:,i)) == num2RadClass(Yaverage))/size(Yaverage,1);
    rtClassSuccess(i,:) = sum(round(rtClassValue(:,:,i)) == round(Yaverage))/size(Yaverage,1);
end

%for i = 1:size(randRegError,1)
    %wsClassSuccess(i,:) = sum(num2RadClass(wsClassValue(:,:,i)) == num2RadClass(Yws))/size(Yws,1);
%    wsClassSuccess(i,:) = sum(round(wsClassValue(:,:,i)) == round(Yaverage))/size(Yaverage,1);
%end

%for i = 1:size(randRegError,1)
    %wsClassSuccess(i,:) = sum(num2RadClass(wsClassValue(:,:,i)) == num2RadClass(Yws))/size(Yws,1);
%    wsSConcatClassSuccess(i,:) = sum(round(wsSConcatClassValue(:,:,i)) == round(YwsMulti))/size(YwsMulti,1);
%end

%wsMulti only has value after stacked ensemble learning, but estimate
%anyway
for segment = 1:size(wsMultiClassValue,4)
    for i = 1:size(wsMultiRegError,1)
        %randClassSuccess(i,:) = sum(num2RadClass(randClassValue(:,:,i)) == num2RadClass(Yaverage))/size(Yaverage,1);
        wsMultiClassSuccess(i,:,segment) = sum(round(wsMultiClassValue(:,:,i,segment)) == round(Yaverage))/size(Yaverage,1);
    end
end

for i = 1:size(randRegError,1)
    %randClassSuccess(i,:) = sum(num2RadClass(randClassValue(:,:,i)) == num2RadClass(Yaverage))/size(Yaverage,1);
    randClassSuccess(i,:) = sum(round(randClassValue(:,:,i)) == round(Yaverage))/size(Yaverage,1);
end

%rtOverRandSuccess = rtClassSuccess - randClassSuccess;
%rtOverWSSuccess = rtClassSuccess - wsClassSuccess;

%rtOverRandReg = randRegError - rtRegError;
%rtOverWSReg = wsRegError - rtRegError;

%-------------------------------------------------------------------
% Stacking Ensemble Learning
%-------------------------------------------------------------------
clear XwsMultiEns
%reformat the data for ensemble use
for i = 1:numCategories
    %XwsEns(:,:,i) = reshape(wsClassValue(:,i,:),size(wsClassValue,1), []);
    %XwsSConcatEns(:,:,i) = reshape(wsSConcatClassValue(:,i,:),size(wsSConcatClassValue,1), []);
    XrtEns(:,:,i) = reshape(rtClassValue(:,i,:),size(rtClassValue,1), []);
    XwsMultiEns(:,:,i) = reshape(wsMultiClassValue(:,i,:,:), size(wsMultiClassValue,1), []); %Concats all the estimated ratings for a rating category from each segmentation of the same ROI. Puts them on the same row
    XrandEns(:,:,i) = reshape(randClassValue(:,i,:),size(randClassValue,1), []);
end

for i = 1:numCategories
    %[wsEnsPred(:,i), wsEnsError(i), wsEnsSuccess(i), wsEnsBeta(:,i)] = StackEns(XwsEns, Yaverage, i );
    %[wsSConcatEnsPred(:,i), wsSConcatEnsError(i), wsSConcatEnsSuccess(i), wsSConcatEnsBeta(:,i)] = StackEns(XwsSConcatEns, YwsMulti, i );
    [wsMultiEnsPred(:,i), wsMultiEnsError(i), wsMultiEnsSuccess(i), wsMultiEnsBeta(:,i)] = StackEns(XwsMultiEns, Yaverage, i );
    [rtEnsPred(:,i), rtEnsError(i), rtEnsSuccess(i), rtEnsBeta(:,i)] = StackEns(XrtEns, Yaverage, i );
    [randEnsPred(:,i), randEnsError(i), randEnsSuccess(i), randEnsBeta(:,i)] = StackEns(XrandEns, Yaverage, i );
end
%Code fragments useful to check results 
%[wsMultiClassSuccess(:,:,1);wsMultiClassSuccess(:,:,2);wsMultiClassSuccess(:,:,3);wsMultiClassSuccess(:,:,4)];
%[wsSConcatRegError;wsRegError;rtRegError;randRegError];
%[wsSConcatClassSuccess;wsClassSuccess;rtClassSuccess;randClassSuccess];

%[wsSConcatEnsError;wsEnsError;wsMultiEnsError;rtEnsError;randEnsError];
%[wsSConcatEnsSuccess;wsEnsSuccess;wsMultiEnsSuccess;rtEnsSuccess;randEnsSuccess];

%reshape(mean(wsMultiEnsBeta,2), 3,[])

%-------------------------------------------------------------------
% Significance testing
%------------------------------------------------------------------
ttestScript

%-------------------------------------------------------------------
% Save results to Excel
%-------------------------------------------------------------------
if doSave == 1
    saveResults;
end
%-------------------------------------------------------------------
% Plot Performance
%-------------------------------------------------------------------
if doPlot == 3 %never happens
    %Plot
    %bar(clError)
    xPlot = [1:numCategories];
    scrsz = get(0,'ScreenSize');

    figure('Position',[scrsz(4)/4, scrsz(4)/2, scrsz(3)/1.5, scrsz(4)/2]-50)
    plot(xPlot, clError(1,:) * 100, '-ro');
    hold on
    plot(xPlot, clError(2,:) * 100, '-bo');
    plot(xPlot, clError(3,:) * 100, '-go');
    plot(xPlot, clError(4,:) * 100, '-ko');
    plot(xPlot, clError(5,:) * 100, '-mo');
    hold off
    xlabel('Category');
    ylabel('Percent Error');
    set(gca,'XTickLabel',categories, 'YLim',[0 80]);
    title('Classification Success Rate');
    %legend('DT 1 to 1','DT Largest Area', 'DT Group to Mean', 'DT Mean to Mean', 'NN');
    legend(clHeader{1}, clHeader{2}, clHeader{3}, clHeader{4}, clHeader{5});

    %make a new figure %Chech the contents of this graph. Probably changed
    %figure('Position',[scrsz(4)/4, 0, scrsz(3)/1.5, scrsz(4)/2]-50)
    %plot(xPlot, nnError, '-ro');
    %set(gca,'XTickLabel',categories);
    %title('Multiple Classification ??');
    %legend('NN');

    %sim(net,Xaverage')'
end

%clear unecessary data
clear rebuildMatrices reloadFeatures minAgreement doLearning doTrees doBagging doNN  ...
    doSVM  doPlot  doSave numTrees errorVector i testCat runMeta row numCategories ...
    categories j option tBag newRowOrder nnError

%Save X and Y data for repeated runs
save('sourceData.mat', 'Xraw', 'Yraw', 'instanceID', 'settings', 'data', 'histos', 'Xlargest', 'Yaverage', 'Xws', 'XwsMulti', 'YwsMulti', 'numSegments'); 

%send message to email
if toc/60 > 5
    targetAddress = 'yourEmail@google.com'; %put your email here
    message = strcat('Script Done. ', num2str(toc/60));
    matlabMail(targetAddress, message);
end
fprintf('*********************************************************************\n');

%misc code fragments
%Cross validation
%cv = fitensemble(X,Y,'Bag',200,'Tree','type','classification','kfold',5)
%Make bags
%bag = fitensemble(Xtrain,Ytrain,'Bag',200,'Tree', 'type','classification
%Test and train sets
%cvpart = cvpartition(Y,'holdout',0.3);
%Xtrain = X(training(cvpart),:);
%Ytrain = Y(training(cvpart),:);
%Xtest = X(test(cvpart),:);
%Ytest = Y(test(cvpart),:);