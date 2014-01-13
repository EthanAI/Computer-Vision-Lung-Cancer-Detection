function [XwsRaw numSegments] = GetXws(instanceID)
%GetXws Gets the X matrix of feature data from the weak segmentations
%   Just reads in data from CSVs created by Patrick's extraction software

%get features from our weak segmentors %FYI 4 Otsu and 6 Region Growing

fprintf('Reading calculated feature data from text files.\n');
featureDirectory = 'C:\Users\esmith2\Documents\Ethans Code\gitCode\Image features calculation code\Features for Production\2K image dataset\';
%featureDirectory = 'C:\Users\esmith2\Documents\Ethans Code\gitCode\Image features calculation code\Features for Production\6K org image dataset\';
%featureDirectory = 'C:\Ethan\repos\Image features calculation code\Features for Production\\6K org image dataset\';

%get otsu features
%[markovValues markovHeaders]
fprintf('Reading Otsu segmentation features\n');
fprintf('\tReading intensity values.\n');
[intensityValuesO intensityHeadersO intensityDCMOrderO] = parseCSV(strcat(featureDirectory, 'otsu_nodules_intensity_features.txt'));
fprintf('\tReading gabor values.\n');
[gaborValuesO gaborHeadersO gaborDCMOrderO] = parseCSV(strcat(featureDirectory, 'otsu_nodules_gab_features.txt'));
fprintf('\tReading haralick values.\n');
[haralickValuesO haralickHeadersO haralickDCMOrderO] = parseCSV(strcat(featureDirectory, 'otsu_nodules_har_features.txt'));
fprintf('\tReading shape values.\n');
[shapeValuesO shapeHeadersO shapeDCMOrderO] = parseCSV(strcat(featureDirectory, 'otsu_nodules_shape_features.txt'));

%get region grown features and horizontally concatenate them. 
%[markovValues markovHeaders]
fprintf('Reading Region Growing segmentation features\n');
fprintf('\tReading intensity values.\n');
[intensityValuesRG intensityHeadersRG intensityDCMOrderRG] = parseCSV(strcat(featureDirectory, 'rg_nodules_intensity_features.txt'));
fprintf('\tReading gabor values.\n');
[gaborValuesRG gaborHeadersRG gaborDCMOrderRG] = parseCSV(strcat(featureDirectory, 'rg_nodules_gab_features.txt'));
fprintf('\tReading haralick values.\n');
[haralickValuesRG haralickHeadersRG haralickDCMOrderRG] = parseCSV(strcat(featureDirectory, 'rg_nodules_har_features.txt'));
fprintf('\tReading shape values.\n');
[shapeValuesRG shapeHeadersRG shapeDCMOrderRG] = parseCSV(strcat(featureDirectory, 'rg_nodules_shape_features.txt'));

%concatenate
intensityValues = [intensityValuesO, intensityValuesRG];
gaborValues = [gaborValuesO, gaborValuesRG];
haralickValues = [haralickValuesO, haralickValuesRG];
shapeValues = [shapeValuesO, shapeValuesRG];

%This should happen before the reshaping of the matrices I think
%Rearrange the calculated features so they match with the appropriate rating
fprintf('Reorganizing data to match ratings.\n');
newRowOrder = 0;
for i = 1:size(instanceID)
    row = find( instanceID(i) == intensityDCMOrderO);
    if ~isempty(row)
        newRowOrder = vertcat(newRowOrder, row); 
    end
end
newRowOrder = newRowOrder(2:end,:);

%apply reordering
intensityValues     = intensityValues(newRowOrder,:);
gaborValues         = gaborValues(newRowOrder,:);
haralickValues      = haralickValues(newRowOrder,:);
shapeValues         = shapeValues(newRowOrder,:);

XwsRaw = [intensityValues, gaborValues, haralickValues, shapeValues]; 

%get number of segments
%Count Otsu segments
i = 1;
while intensityHeadersO{1}(end) == intensityHeadersO{i+1}(end)
    i = i+1;
end
numSegments = length(intensityHeadersO)/i;
%count region growing segments
i = 1; 
while intensityHeadersRG{1}(end) == intensityHeadersRG{i+1}(end)
    i = i+1;
end
numSegments = numSegments + length(intensityHeadersRG)/i;

%unused method of getting the largest boundary from each slice
%largeInstances = intensityValues(:,end);

end