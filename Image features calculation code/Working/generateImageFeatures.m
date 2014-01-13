function generateImageFeatures(images, saveLocation)
%GENERATEIMAGEFEATURES Summary of this function goes here
%   calls three functions that calculate all image features


%shape and size features
shapeFeatures(images,saveLocation);

%intensity features
intensityFeatures(images,saveLocation);

%gabor texture features
gab(images,saveLocation);


end

