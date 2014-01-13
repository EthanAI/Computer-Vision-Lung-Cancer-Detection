function [ pixelVector ] = guardImage( image, mask, maskNumber)
%GUARDIMAGE applies a logical mask to an image and returns a
%one-dimensional array of the valid pixels
%   param maskNumber
%       maskNumber indicates what value in the image you are looking to
%       guard on. For example, if you want to guard on the foreground you
%       can provide a 1. If you want to get the background, then provide a
%       0. The default value is for the foreground, or a 1.


    %%Pre-process
    %check if a maskNumber is provided
    if ~exist('maskNumber','var')
        maskNumber=1;
    end
    
    %make an array of zeros
    pixelVector = zeros;
    
    %get size of image
    sizeImage = size(image);
    
    %array pos
    x = 1;
    
    %% create pixel vector from the mask
    for i=1:sizeImage(1)
       for j=1:sizeImage(2)
           if(mask(i,j) == maskNumber)
               %if part of the mask, then add to pixel vector
               pixelVector(x) = image(i,j);
               %increment
               x = x + 1;
           end
       end
    end

