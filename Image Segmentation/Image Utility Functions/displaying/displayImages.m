function [ ] = displayImages( allImages, map )
%displayImages Summary of this function goes here
%   Displays a given list of images


    %total number of images
    totalSize = size(allImages);
    totalSize = totalSize(2);

    %calculate the number of rows you will need
    numberOfRows = ceil( ( totalSize + 1 ) / 4 );


    figure;
    %loop through segmented images
    for i = 1:totalSize
       %extract from cell array
       image = allImages{i};
       subplot(numberOfRows,4,i);
       %display
       imshow(image,map);
    end


end

