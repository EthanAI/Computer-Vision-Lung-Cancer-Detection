function [Xraw, Yraw, instanceID, ratingRow, data, histos ] = GetRadData(minAgreement)
%getRadData Generates the various X, Y matrices based on the radiologists
%   Can be tweaked based on the minimum number of radiologists giving a
%   rating for the data to be kept. Gets the feature data and makes an X
%   matrix, gets the rating data and makes a Y matrix. Also gives you a
%   histogram distribution of the ratings. 

%Load data
fprintf('Reading excel file\n'); %This read is the slow part
[~, ~, rawData] = xlsread('C:\Users\esmith2\Documents\Ethans Code\gitCode\Semantic Features\LIDC_All_Radiologist_Cases_For_Largest_Slice cleaned modified ES recalc Features by PS.xlsx');

ratingColumn = [9,11,12,13,14,15,16]; %columns where the ratings we want are found
numCategories = length(ratingColumn);

%Get colums of special headers
for i = 1:size(rawData,2)
    if strcmp(rawData{1,i}, 't1.coords') == 1
        featureColumn = i + 1;
    end
end
numFeatures = size(rawData,2) - (featureColumn - 1);

%[~, ~, rawData] = xlsread('C:\Ethan\Dropbox\MedIX\Lung Segmentation\Repo\Semantic Features\cleaned data in order with features.xlsx');
rawData = rawData(2:end, :); %Remove headers 

%Sort numRatings
fprintf('Only looking at data with at least %d ratings\n' , minAgreement);
currentID = rawData(1,6);
dupCount = 1;
goodRows = cell(1,4);
rowStart = 0;
rowStop = 0;
for i = 2:size(rawData,1)
    %fprintf('%d %d %d %d\n', i, strcmp(currentID, rawData(i,6)), dupCount, minAgreement);
    if strcmp(currentID, rawData(i,6)) == 1 %Still part of existing line
        dupCount = dupCount + 1;
    else %Found new set, process it
        rowStart = rowStop + 1;
        rowStop = i-1;
        goodRows{dupCount} = vertcat(goodRows{dupCount}, [rowStart:rowStop]');

        currentID = rawData(i,6);%start new count
        dupCount = 1;
    end
end
%process last set
rowStart = rowStop + 1;
rowStop = i;
goodRows{dupCount} = vertcat(goodRows{dupCount}, [rowStart:rowStop]');

%form sorted data   
data = rawData(goodRows{4},:);
for i = 3:-1:minAgreement
    data = vertcat(data, rawData(goodRows{i},:) );
end
%fprintf('4 %d 3 %d 2 %d 1 %d Total %d\n', length(goodRows{4}), length(goodRows{3}), length(goodRows{2}), length(goodRows{1}), length(goodRows{4}) + length(goodRows{3}) + length(goodRows{2}) + length(goodRows{1}));

%Get indexes for where each group starts and stops (all the 4s, all the
%3s etc..
ratingRow = zeros(1,4);
ratingRowGroup = zeros(1,4);
ratingRow(1,4) = 1;
ratingRowGroup(1,4) = 1;
for i = 3:-1:1
    ratingRow(1,i)      = length(goodRows{i+1}) + ratingRow(1,i+1);
    ratingRowGroup(1,i) = length(goodRows{i+1}) / (i+1) + ratingRowGroup(1,i+1);
end
%Get instance IDs for each row so we can match up with features
%extracted in a different order
instanceID = cell2mat(data(:,1));

fprintf('Selecting all data\n'); 
%Get strait one to one values
Xraw = cell2mat(data(:,featureColumn:featureColumn+numFeatures-1));
Yraw = cell2mat(data(:,ratingColumn));

%Make histograms for check against broken clock/noise
%tabulate(Ytest(:,1)) function is better :-(
histos = zeros(numCategories, 5);
for i = 1:numCategories
    YVectors = Y2YVectors(Yraw(:,i), 5);
    histos(i,:) = sum(YVectors)/ sum(sum(YVectors));
end
%histos = [histos, zeros(numCategories, 1)];
%histos = horzcat(histos, max(histos,[], 2));

clear localDirectoryName serverDirectoryName lidcDirectoryName directoryName dataFileFullName YVectors ...
    categories currentID dupCount featureColumn featureDirectory i message numCategories 
    
%clear rawData goodRows
end

