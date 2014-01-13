function [ LargestMatrix ] = GetLargestMatrix( InputMatrix, largestIDs, instanceIDs )
%GetLargestMatrix 
%   Kind of a strange function. You feed this the IDs of the rows that you
%   want to use as 'largest area border of that slice' and it will get
%   those rows for you in order. Testing with another function confirmed
%   this is the same order as the Y matrix we're using, so no need to try
%   and reorder the data. 

%get the rows of the instance IDs that match the instance IDs to generate
%Patrick's segmentations (same order)
for i = 1:length(largestIDs)
   largestRows(i) = find(largestIDs(i) == instanceIDs); 
end

largestRows = largestRows';
LargestMatrix = InputMatrix(largestRows,:);


end