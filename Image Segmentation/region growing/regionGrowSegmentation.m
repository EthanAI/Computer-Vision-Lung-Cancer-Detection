function [ segmentedImage ] = regionGrowSegmentation( image , threshold)
%regionGrowSegmentation 
%     Summary: This function takes an image and converts it into its double 
%          representation.It then performs region growing on the new double 
%          image and returns a logical image highlighting the region grown.
%     param image
%        This can be any image, this is primarily written with dicom images 
%        in mind so beware.
%     param threshold
%         This is the threshold distance used to halt the region growing 
%         algorithm.
%     
%     return segmentedImage
%         The segmented image will be returned as a logical 
%         2-dimensional array.
%         
%   Author: Patrick Stein 7/2/2013


    %TODO: Validate incoming params

    %Change to a image double
    imageDouble = im2double(image);
            
    %Calculate center
    %TODO: Replace this with some other data point (provided with 
    %the ROI rather than a calculation, add factory capabilities
    
    center = size(image)/2+.5;
    %run region growing
    segmentedImage = regiongrowing(imageDouble,...
        floor(center(1)),...
        floor(center(2)),...
        threshold);
    %save the newly segmented image in a 2 dimensional array of
    %images

end

