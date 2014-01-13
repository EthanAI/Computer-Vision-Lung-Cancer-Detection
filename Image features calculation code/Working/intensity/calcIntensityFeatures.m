function [ INTENSITY ] = calcIntensityFeatures( greyImage,mask )
%IntensityFeatures - Features from intensity values
%   Returns the maximum, minimum, average and stdev intensity of the the
%   pixels in the region

    
    %% Pre-processing
    
    %get foreground or nodule segmentation pixels only
    fgPixelVector = guardImage( greyImage, mask, 1);
    %get background pixels
    bgPixelVector = guardImage( greyImage, mask, 0);
    %sort both for easier calculation of intensity features
    fgPixelVector = double(sort(fgPixelVector));
    bgPixelVector = double(sort(bgPixelVector));
    
    %% Calculate foreground and background intensity features
    
    %calculate foreground intensity features
    INTENSITY.fgMax = max(fgPixelVector);
    INTENSITY.fgMin = min(fgPixelVector);
    INTENSITY.fgStdev = std(fgPixelVector);
    INTENSITY.fgMean = mean(fgPixelVector);
    INTENSITY.fgMedian = median(fgPixelVector);

    %calculate background intensity features
    INTENSITY.bgMax = max(bgPixelVector);
    INTENSITY.bgMin = min(bgPixelVector);
    INTENSITY.bgStdev = std(bgPixelVector);
    INTENSITY.bgMean = mean(bgPixelVector);
    INTENSITY.bgMedian = median(bgPixelVector);
    
    %Intensity Difference
    INTENSITY.sumIntensity = abs(INTENSITY.fgMean - INTENSITY.bgMean);

end

