function [ allImages ] = runRegionGrowing( directoryName,...
                            thresholdBegin, thresholdEnd, increment )
%runRegionGrowing 
%   Summary: Run the region growing code based on the parameters provided
%       at the end, an array of all image segmentations will be returned
%   param directoryName
%       pass a string directory name that contains dicom images to be used
%       for segmentation
%   param thresholdBegin
%       pass the beginning threshold value that will do the following:
%           "Start region growing until distance between region and posible 
%           new pixels become higher than a certain treshold"
%       From here, the threshold will be passed to regiongrowing and
%       incremented on by the increment variable
%   param thresholdEnd
%       pass the end threshold value that will do the following:
%       "Start region growing until distance between region and posible 
%           new pixels become higher than a certain treshold"
%       This will mark the end of the incrementation, no more region
%       growing will be run
%   param increment
%       pass value in which the threshold will be incremented on.
%       Example: thresholdBegin = 0.2 and increment = .05 
%             first iteration threshold = 0.2
%             second iteration threshold = 0.25
%             third iteration threshold = 0.3
%             etc...
%
%   return allSegmentations
%       returns all segmentations created by region growth as a
%       two-dimensional cell array
%
%   return originalImages
%       return all original dicom images as a one-dimensional cell array
%
%   Author: Patrick Stein 7/1/2013


    %% Parameter validation

    % Validate the following parameters: 
    % thresholdBegin, thresholdEnd, increment
    % thresholdBegin and thresholdEnd > 0
    % thresholdBegin != thresholdEnd
    % thresholdEnd > thresholdBegin
    % increment > 0
    % Directory is an actual directory

    %Test the following conditions: 
    %"thresholdBegin != thresholdEnd && thresholdEnd > thresholdBegin"
    if(thresholdEnd <= thresholdBegin)
        invalidParam = MException('RunRegionGrowing:InvalidParam:p2_3', ...
            'Invalid Parameter: thresholdEnd must be >= thresholdBegin');
        throw(invalidParam);
    end

    %Test the following condition: increment > 0
    if(increment <= 0)
        invalidParam = MException('RunRegionGrowing:InvalidParam:p4', ...
            'Invalid Parameter: increment must be >= 0'); 
        throw(invalidParam);
    end

    %Test the following condition: thresholdBegin and thresholdEnd > 0
    if(thresholdBegin <= 0 || thresholdEnd <= 0)
        invalidParam = MException('RunRegionGrowing:InvalidParam:p2_3', ...
        'Invalid Parameter: thresholdBegin/End must >= 0');
        throw(invalidParam);
    end

    %Test to see if directoryName is a folder
    %exists docs: http://www.mathworks.com/help/matlab/ref/exist.html
    if(exist(directoryName,'dir') ~= 7)
        invalidParam = MException('RunRegionGrowing:InvalidParam:p1', ...
        'Invalid Parameter: directoryName is not a  valid directory');
        throw(invalidParam);
    end

    %% Pre-processing
    
    %append \*.dcm to the end of the string so it will only load dicom
    %files
    directoryNameNew = strcat(directoryName,'\*.dcm');
    
    % set the directory where nodule crops are stored
    imageFiles = dir(directoryNameNew);
    
  
    %get size of directory
    sizeDir = size(imageFiles,1);
   
    %create structure array of all dicom info and segmentations
    allImages = struct('imageNumber',0,'imageName',char,...
                       'originalImage',[],'segmentations',cell(1,1),...
                       'dicomInfo',struct([]),'map',[],'alpha',[],...
                       'overlay',[],'segmentationType',char,'masks',...
                       cell(1,1));
    %Segmentation type    
    sg = 'rg';
    %% DICOM Segmentation
    
    %for each file in the directory, do the following
    parfor i = 1:sizeDir
        
        %get image name
        in = char(imageFiles(i).name);
        
        %Construct the file name and path needed to open the file
        fn = sprintf('%s/%s', directoryName, in);
        
        %Load dicom image into matlab, see loadDicom for more information
        try
            [dicomImage,info,m,a,o] = loadDicom(fn);
        catch ME
            % TODO: Handle this exception
            %rethrow(ME);
        end 
             
        %save segmentation type
        allImages(i).segmentationType = sg; 
        %save name
        allImages(i).imageName = in;
        %save image number
        allImages(i).imageNumber = str2num( in(1:(strfind(in,'.')-1)) );           
        %save dicom image
        allImages(i).originalImage = dicomImage;
        %save org dicom information
        allImages(i).dicomInfo = info;
        %save org dicom map
        allImages(i).map = m;
        %save org dicom alpha
        allImages(i).alpha = a;
        %save org dicom overlay
        allImages(i).overlay = o;
        allImages(i).segmentations = getAllSegsRG(dicomImage,thresholdBegin,...
                                        thresholdEnd, increment);
    end

    %% Wrap up
    %sort the structure array
    allImages = nestedSortStruct(allImages, 'imageNumber');
       
end 

