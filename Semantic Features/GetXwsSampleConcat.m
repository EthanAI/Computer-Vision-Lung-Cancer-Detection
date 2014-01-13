function [XwsSampleConcat, YSampleConcat] = GetXwsSampleConcat(X, Y, numSegments)
%GetXwsSampleConcat Creates a proper X and Y matrix suitable for the
%ensemble learning processes we had designed. (2 levels). 
%  Rearranges the raw Xws data so the segments are each listed one after
%  the other sample wise down the rows. To match it, an Y matrix is made
%  with the same values copied so the rows for each segmenetation match the
%  row it belongs to for labels. Probably should have made this into an
%  array of X matrixes (3d) but this worked. 

newWidth = size(X,2) / numSegments;

XwsSampleConcat = X(:,1:newWidth);
YSampleConcat = Y;
for i = 2:numSegments
    XwsSampleConcat = vertcat(XwsSampleConcat, X(:,(i-1)*newWidth+1:i*newWidth));
    YSampleConcat = vertcat(YSampleConcat, Y);
end

end