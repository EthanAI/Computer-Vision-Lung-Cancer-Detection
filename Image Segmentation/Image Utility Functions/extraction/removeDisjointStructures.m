function [ image ] = removeDisjointStructures( image )
%removeDisjointStructures 
%Otsu thresholding may not always provide a single structure that would 
%represent a nodule, this function will attempt to remove additional 
%structures.
%
%    param Image
%         Must be an image that has had otsu segmentation done on it.
%    return fixedImage
%         an image with a single class to be used for segmentation

    %find all connected components
    CC = bwconncomp(image);

    %Count the number of pixels belonging to each component
    numPixels = cellfun(@numel,CC.PixelIdxList);
    
    %find the maximum area connected component, provides index and count
    [biggest,idx] = max(numPixels);
    
    
    %remove all other connected components that are not the largest
    %component
    for i=1:CC.NumObjects
        if(i == idx)
            continue;
        end
        %erase smaller components
        image(CC.PixelIdxList{i}) = 0;
    end




end

