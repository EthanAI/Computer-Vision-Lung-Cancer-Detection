function [ RATINGS ] = GetRadiologistsRatings( data, rowNumber )
%GetRadiologistsRatings Collects radiologists ratings belonging to all the
%borders related to the same nodule image. 
%   Takes the location of the Excel file with the doctors semantic ratings,
%   and the name of the outline file you are interested in. Finds the name
%   of the source image, then collects the radiologists ratings for that
%   source image. Returns everything in the RATINGS structure. Easier than
%   using dicominfo('1.dcm') since we need the rating .xlsx or we're stuck
%   anyway. 
%   Gives the # of ratings, ID of source image, IDs of related border
%   images, and the ratings: subtlety,internalStructure,calcification,sphericity,
%   margin,lobulation,spiculation,texture,malignancy.

%modified column numbers 
%find how many ratings for this nodule 
noduleID = cell2mat(data(rowNumber,6));
i = 1;
while rowNumber+i <= size(data,1) && strcmp(cell2mat(data(rowNumber + i, 6)), noduleID) == 1
    i = i+1;
end
totalRatings = i;
matchingRows = (rowNumber:rowNumber + totalRatings - 1);
%1 subtlety, 2 calcification, 3 sphericity, 4 margin, 5 lobulation, 
%6 spiculation, 7 texture, 8 malignancy
RATINGS.totalRatings = totalRatings;
RATINGS.noduleID = noduleID;
RATINGS.relatedInstances = cell2mat(data(matchingRows, 1));
RATINGS.subtlety = cell2mat(data(matchingRows, 10));
RATINGS.calcification = cell2mat(data(matchingRows, 11)); %not a 'ranking' number
RATINGS.sphericity = cell2mat(data(matchingRows, 12));
RATINGS.margin = cell2mat(data(matchingRows, 13));
RATINGS.lobulation = cell2mat(data(matchingRows, 14));
RATINGS.spiculation = cell2mat(data(matchingRows, 15));
RATINGS.texture = cell2mat(data(matchingRows, 16));
RATINGS.malignancy = cell2mat(data(matchingRows, 17));
%RATINGS.internalStructure = cell2mat(data(matchingRows, 11)); %useless also not a ranking number
RATINGS.sourceID = RATINGS.noduleID(1:30);
RATINGS.sourceDirectory = char(data(matchingRows, 9)); %only need one of the identical entries

RATINGS.stdev = [std(RATINGS.subtlety), std(RATINGS.calcification), ...
    std(RATINGS.sphericity), std(RATINGS.margin), std(RATINGS.lobulation),...
    std(RATINGS.spiculation), std(RATINGS.texture), std(RATINGS.malignancy)];
RATINGS.rows = [rowNumber, rowNumber+totalRatings-1];
%Get borders in numerical form. 
borderCells = data(matchingRows, 21);
RATINGS.borders = ParseBorderCells(borderCells); 
RATINGS.area = cell2mat(data(matchingRows, 71));


%Get extrema from x,y coordinates in the borders
minCorner = min(RATINGS.borders{1}); %initialize
maxCorner = max(RATINGS.borders{1});
for i = 2:length(RATINGS.borders) %iterate
    minCorner = min([minCorner; RATINGS.borders{i}]);
    maxCorner = max([maxCorner; RATINGS.borders{i}]);
end
RATINGS.boundingBox = [minCorner; maxCorner];

end

