function [ images ] = createMasks(images)
%extractNodules takes the original image and all segmentations on the image
%and extracts the structure provided by the segmentation
%   param orgImage
%       a the original image that will be segmented
% 
% 
%   param segmentedImages
%       a cell array of each image segmentation
%   
    %% Pre-process
    %Get the size of images
    dimensions = size(images);
    imageTotal = dimensions(2);
    
 
    %% Extraction of the nodules
    %I want a factory
    for i=1:imageTotal
        %check to see if otsu and extract that
        if(strcmp(images(i).segmentationType,'otsu')) 
        %run through all otsu image segmentations and extract the nodule
           images(i).masks = maskCreationOtsu( images(i).segmentations);
        %check to see if region growing and run region growing                   
        else if(strcmp(images(i).segmentationType,'rg'))
           %run through all region growing image segmentations 
           %extract the nodule
           images(i).masks = ...
                maskCreationRegionGrowing(images(i).segmentations);
            end
        end
    end

end

