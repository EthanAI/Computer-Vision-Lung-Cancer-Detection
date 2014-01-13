function [allSegs] = getAllSegsOtsu(dicomImage,numOfClass )
%getAllSegsOtsu Summary of this function goes here
%   Detailed explanation goes here
 
    allSegs = cell(1,1);  
    %Segment using otsu on the range of classes provided in param
    %numOfClass
    for n = 1:numOfClass     
        %Temp variable to indicate the current class count
        nc = n + 1;
        %run otsu on the image
        allSegs{n} = otsu(dicomImage,nc);   
    end

end

