function intensityFeatures( allImages,saveFileLocation )
%INTENSITYFEATURES Calculates all intensity features for all image
%segmentations.
%   Parameter explanantion:
%
%   param allImages
%       A structure that contains all image segmentations, must include a 
%       mask and  
%   param saveFileLocation
%       A file location that you wish to save the CSV file to, make sure 
%       to include a final slash or the file will not be saved with the 
%       correct name. It should not corrupt the file.


    %% Pre-processing

    %set up save file
%     saveFileLocation = ['C:\Users\PSTEIN4\Desktop\matlab-code-summer-' ...
%       'research-2013\Image features calculation code\Working\Combined' ...
%       ' Features\2K image dataset\'];

    %Generate the labels based on the intensity feature structure provided,
    %all of the features should be constant so using the first entry should
    %be fine
    baseLabels = fieldnames(calcIntensityFeatures(...
                allImages(1).originalImage,allImages(1).masks{1})).';
            
    %Generate the segmentation type, this should be unique to the entire
    %image set
    segType = allImages(1).segmentationType;

    %This array contains any image features that you don't want calculated.                   
    unwantedValues = {};
  
    %Concatenate segmentation type onto file name
    saveFileLocation = sprintf('%s%s%s',saveFileLocation,...
           segType,'_nodules_intensity_features.txt');
    
    %set the location of output csv file
    fid1 = fopen(saveFileLocation, 'w+');

    %Total number of segmentations produced for this image set, this should
    %be a constant number in the array of images.
    numSegs = size(allImages(1).masks,2);
    
    %Total number of images being passed in
    imageTotal = size(allImages,2);
    
    
    %Write all of the labels provided above to the file just opened, the
    %file descriptor is "fid1"
    createLabels(baseLabels,unwantedValues,numSegs,fid1,segType);
    
    %% generate intensity features for each segmentation
    for i = 1:imageTotal
        
        %grab the nodule masks
        maskArray = allImages(i).masks;
        %grab the original DICOM image
        orgImage = allImages(i).originalImage;
        
        %Iterate through each segmentation
        for x = 1:numSegs
            %get the mask
            mask = maskArray{x};
            %Calculate intensity features
            INTENSITY = calcIntensityFeatures(orgImage,mask);

            %get the labels
            labels = fieldnames(INTENSITY);
            
            %save members of INTENSITY structure
            for j = 1:numel(labels)
                %extract a field name from INTENSITY
                fieldName = labels{j};
                %if the field name is not a member of the unwanted values
                if (~ismember(fieldName,unwantedValues))
                    fprintf(fid1,'%f,',INTENSITY.(fieldName) );
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

