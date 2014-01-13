function [ masks ] = maskCreationRegionGrowing(segmentedImages)
%noduleExtractionRegionGrowing Summary of this function goes here
%   param orgImage
%       a the original image that will be segmented
% 
% 
%   param segmentedImages
%       a cell array of each image segmentation
% 
% 
%     

    %% Pre-process

    %Get the number of segmentations
    dimensions = size(segmentedImages);
    segTotal = dimensions(2);
    
    %set up cell array for images
    masks{segTotal} = [];
    

    %% extract nodule
    for i=1:segTotal
        
        %get segmented image
        s = segmentedImages{i};
        %fill holes in region growing
        s = imfill(s,'holes');
        %save the mask
        masks{i} = s;

        
    end





end

