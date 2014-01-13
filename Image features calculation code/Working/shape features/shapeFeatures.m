function shapeFeatures( allImages,saveFileLocation )
%shapeFeatures calculates all shape features for images and saves them in a
%file.
%   param allImages
%       structure array provided by one of the segmentation algorithms


    %% Pre-processing

    %base feature labels
    baseLabels = fieldnames(calcShapeFeatures2D( ...
                            allImages(1).masks{1})).';

    %array of unwanted values                    
    unwantedValues = {'Centroid','ConvexHull','ConvexImage'};

    %set up save file
%     saveFileLocation = ['C:\Users\PSTEIN4\Desktop\matlab-code-summer-' ...
%     'research-2013\Image features calculation code\Working\Combined' ...
%     ' Features\'];

    %seg type
    segType = allImages(1).segmentationType;
    
    %concat segmentation type onto file name
    saveFileLocation = sprintf('%s%s%s',saveFileLocation,...
            segType,'_nodules_shape_features.txt');

    %set the location of output csv file
    fid1 = fopen(saveFileLocation, 'w+');

    %size of segmentation array
    numSegs = size(allImages(1).masks,2);
    
    %size of images
    imageTotal = size(allImages,2);
    
    %produce labels for segmentation
    createLabels(baseLabels,unwantedValues,numSegs,fid1,segType);
    
    %% generate shape/size features for each segmentation
    for i = 1:imageTotal
        
        imageArray = allImages(i).masks;
        
        for x = 1:numSegs
            
            %get the image
            I = imageArray{x};

            %Calculate shape/size features
            STATS = calcShapeFeatures2D(I);

            %get the labels
            labels = fieldnames(STATS);
            
            %save members of STATS structure
            for j = 1:numel(labels)
                %extract a field name from STATS
                fieldName = labels{j};
                %if the field name is not a member of the unwanted values
                if (~ismember(fieldName,unwantedValues))
                    fprintf(fid1,'%f,',STATS.(fieldName) );
                end
            end
        end
        
        %add a newline and the image name
        fprintf(fid1, '%s\n', allImages(i).imageName);

    end

    %% wrap up
    %PFS 1:55 6/25/2013
    %Close the file which shape/size features are being saved in
    fclose(fid1);


end

