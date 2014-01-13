function [fileData] = haral( allImages,saveFileLocation )
%HARAL calculates the original 13 Haralick features for images and saves 
%them in a file.
%
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

    %base feature labels
    baseLabels = {'angular_Second_Moment', 'Contrast', 'Correlation',...
        'SoSVariance','inverse_Diff_Moment','sum_Average',...
        'sum_Variance','sum_Entropy','Entropy','diff_Variance',...
        'diff_Entropy','info_M_Correlation_1','info_M_Correlation_2'};

    %set up save file
%     saveFileLocation = ['C:\Users\PSTEIN4\Desktop\matlab-code-summer-' ...
%     'research-2013\Image features calculation code\Working\Combined' ...
%     ' Features\'];

    %Generate the segmentation type, this should be unique to the entire
    %image set
    segType = allImages(1).segmentationType;

    %This array contains any image features that you don't want calculated.                    
    unwantedValues = {};
    
    %Concatenate segmentation type onto file name
    saveFileLocation = sprintf('%s%s%s',saveFileLocation,...
            segType,'_nodules_har_features.txt');

    %set the location of output csv file
    fid1 = fopen(saveFileLocation, 'w+');

    %Total number of segmentations produced for this image set, this should
    %be a constant number in the array of images.
    numSegs = size(allImages(1).masks,2);
    
    %Total number of images being passed in
    imageTotal = size(allImages,2);
    
    %create string array size of images
    haralickInfo = cell(1,imageTotal);
    
    %Write all of the labels provided above to the file just opened, the
    %file descriptor is "fid1"
    createLabels(baseLabels,unwantedValues,numSegs,fid1,segType);
    
    %open up matlab thread pool
    if(matlabpool('size') == 0) 
       matlabpool open 4
    end

    %% calculate haralick features on each image segmentation
    %This is using a parfor loop to calculate features in parallel, to
    %change just remove the "parfor" and change to "for"
    parfor i = 1:imageTotal

        %grab the nodule masks
        maskArray = allImages(i).masks;
        %grab the original DICOM image
        orgImage = allImages(i).originalImage;
        %Preallocate string for speed
        s = '';
        %Iterate through each segmentation
        for x = 1:numSegs
            
            %get the mask
            mask = maskArray{x};
            
            %Change image to a double
            b = double(orgImage);
            b(b==-2000) = 0;
            
            % calculate Haralick descriptors
            H = cooccurfeatures(b,mask);

            % Combine the Haralick feature calculations together, this
            % will be written into the file opened by fid1. This makes it
            % slightly eaiser as the bottleneck is not file writing but
            % acutal feature calculation. For large image sets, watch for
            % memory issues. 
            for j = 1:size(H,2)
               s = strcat(s,num2str(H(j)),',');
            end
        end
        
        %add a newline and the image name to the end of the string
        tempString = sprintf('%s', allImages(i).imageName);
        %save the Haralick information to a file for later use. 
        haralickInfo{i} = strcat(s,tempString);

    end
    
    %% wrap up
    %close thread pool if there is a pool still open
    if(matlabpool('size') > 0)
        matlabpool close;
    end
    
    %save return value, this is used primarily for debugging purposes
    fileData = haralickInfo;
    
    %write array to file
    for w=1:imageTotal
       fprintf(fid1,'%s\n', haralickInfo{w});  
    end
    

    %PFS 2:38 6/25/2013
    %Close the file
    fclose(fid1);
