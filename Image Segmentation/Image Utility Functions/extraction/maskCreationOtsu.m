function [ masks ] = maskCreationOtsu(segmentedImages)
%noduleExtractionOtsu extract the nodule based on the segmented images
%   hardcoded values, you might need to change them in the future
%
%   param orgImage
%       the original image that will be segmented
% 
%   param segmentedImages
%       a cell array of each image segmentation
% 
    %% Pre-process
    %Get the number of segmentations
    segTotal = 1;
    
    %total class
    totalClass = 5;
    
    %set up cell array for images
    masks = cell(1,1);
    
    x = 1;
    
    %% extract nodule
    for i=1:segTotal
        
        %get segmented image
        s = segmentedImages{i};

        %iterate through classes
        for j=2:totalClass
            
            %create temp image
            tempImage = s;     
            %erase background pixels
            for e=1:j-1
                tempImage(s == e) = 0;
            end            
            
            %remove any components that aren't part of the nodule and save
            %the nodule as a binary image
            tempImage = im2bw(removeDisjointStructures(tempImage));
            
            %fill the holes and save the mask
            masks{x} = imfill(tempImage,'holes');   
            
            %increment position in image array
            x = x + 1;

        end
        
    end


end

