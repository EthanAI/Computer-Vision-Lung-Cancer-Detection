function [allSegs] = getAllSegsRG(dicomImage,threshold,thresholdEnd,...
                                increment)
%GETALLSEGSRG Summary of this function goes here
%   Detailed explanation goes here

    %make cell array for segs
    allSegs = cell(1,1);   
    j = 1;
    %Loop through all possible parameters for region growing
    while(threshold <= thresholdEnd)
                     
        %call function to run region growing segmentation
        allSegs{j} = regionGrowSegmentation(dicomImage,threshold);
        %increment threshold
        threshold = threshold + increment;
        %increment array position
        j = j + 1;
    end

end

