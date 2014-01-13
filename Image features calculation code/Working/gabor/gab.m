function gab(allImages, saveFileLocation)
%GAB calculates a set of gabor image features based on the mean and
%standard deviation of the nodule and saves these results to a file.
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
    baseLabels = {'gabormean_0_0', 'gaborSD_0_0', 'gabormean_0_1',... 
        'gaborSD_0_1', 'gabormean_0_2', 'gaborSD_0_2', 'gabormean_1_0',...
        'gaborSD_1_0', 'gabormean_1_1', 'gaborSD_1_1', 'gabormean_1_2',...
        'gaborSD_1_2', 'gabormean_2_0', 'gaborSD_2_0', 'gabormean_2_1',...
        'gaborSD_2_1', 'gabormean_2_2', 'gaborSD_2_2', 'gabormean_3_0',...
        'gaborSD_3_0', 'gabormean_3_1', 'gaborSD_3_1', 'gabormean_3_2',...
        'gaborSD_3_2'};

%     %set up save file
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
            segType,'_nodules_gab_features.txt');

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


    %% generate gabor features for each segmentation
    for i = 1:imageTotal
        
        %grab the nodule masks
        maskArray = allImages(i).masks;
        %grab the original DICOM image
        orgImage = allImages(i).originalImage;
        
        %iterate through all of the segmentations provided
        for x = 1:numSegs
            
            %get a mask from the array
            mask = maskArray{x};
            
            %Convert image into a double
            b = double(orgImage);
            b(b<0) = 0;
            %Calculate Gabor features
            H = gaborfeatures(b,mask);
            [a,b,~]=size(H);
            
            %Iterate through the 
            for j = 1:a
                for k = 1:b
                    fprintf(fid1, '%f,%f,', H(j,k,1), H(j,k,2));
                end
            end
        end
        
        %add a newline and the image name
        fprintf(fid1, '%s\n', allImages(i).imageName);

    end

    %% wrap up
    %PFS 1:55 6/25/2013
    %Close the file which Gabor Features are being saved in
    fclose(fid1);
