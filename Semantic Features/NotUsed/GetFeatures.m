function [ FEATURES ] = GetFeatures( data, rowNumber , featureColumn, numFeatures)
%GetFeatures creates a nice structure with all the features for a nodule
%   Takes the location of the Excel file with the features already stored.
%   Returns a structure with a unique identifier and all the ratings given
%   for that nodule

%find how many ratings for this nodule 
noduleID = data(rowNumber,6);
i = 1;
while rowNumber+i <= size(data,1) && strcmp(cell2mat(data(rowNumber + i, 6)), noduleID) == 1
    i = i+1;
end
totalRatings = i;
matchingRows = (rowNumber:rowNumber + totalRatings - 1);
%grab the features
%markov1	markov2	markov3	markov4	markov5	MinIntensity	MaxIntensity	MeanIntensity	SDIntensity	MinIntensityBG	MaxIntensityBG	MeanIntensityBG	SDIntensityBG	IntesityDifference	gabormean_0_0	gaborSD_0_0	gabormean_0_1	gaborSD_0_1	gabormean_0_2	gaborSD_0_2	gabormean_1_0	gaborSD_1_0	gabormean_1_1	gaborSD_1_1	gabormean_1_2	gaborSD_1_2	gabormean_2_0	gaborSD_2_0	gabormean_2_1	gaborSD_2_1	gabormean_2_2	gaborSD_2_2	gabormean_3_0	gaborSD_3_0	gabormean_3_1	gaborSD_3_1	gabormean_3_2	gaborSD_3_2	Contrast	Correlation	Energy	Homogeneity	Entropy	@3rdordermoment	Inversevariance	Sumaverage	Variance	Clustertendency	MaxProbability	Area	ConvexArea	Circularity	Perimeter	ConvexPerimeter	Roughness	EquivDiameter	MajorAxisLength	MinorAxisLength	Elongation	Compactness	Eccentricity	Solidity	Extent	RadialDistanceSD	SecondMoment
FEATURES.totalRatings = totalRatings;
noduleID = data(rowNumber,6);
FEATURES.noduleID = cell2mat(noduleID);
FEATURES.numFeatures = numFeatures;
FEATURES.features = cell(FEATURES.numFeatures,1);
for i = 1:numFeatures
    FEATURES.features{i} = cell2mat(data(matchingRows, i + featureColumn - 1));
end



end

