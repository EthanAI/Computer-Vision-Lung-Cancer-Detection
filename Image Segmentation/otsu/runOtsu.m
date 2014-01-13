function [allImages] = runOtsu( directoryName, numOfClass)
%runOtsu Summary: Run the Otsu code on a directory of images with a select
%   number of classes.
%   
%   param directoryName
%       must be a string, don't put any special formating at the end such 
%       \*.dcm . This will be done inside the function.
%   param numOfClass
%       Indicates the number of classes you will be providing for otsu to
%       do segmentation on. Must be greater than 1. Starts at 2 classes
%       then goes to 3 etc...
% 
%         
%   return allSegmentations
%       returns all segmentations created by region growth as a
%       two-dimensional cell array
%
%   return originalImages
%       return all original dicom images as a one-dimensional cell array
%
%   Building and managing a cell array of images:
%   http://stackoverflow.com/questions/6496696/build-an-array-of-images-in-matlab
%   Author: Patrick Stein 7/3/2013


    %% Parameter validation

    
    %Test to make sure numOfClasses exceeds 0
    if(numOfClass <= 0)
        invalidParam = MException('runOtsu:InvalidParam:p2', ...
        'Invalid Parameter: numOfClass must be >= 1');
        throw(invalidParam);
        
    end
    
    %Test to see if directoryName is a folder
    %exists docs: http://www.mathworks.com/help/matlab/ref/exist.html
    if(exist(directoryName,'dir') ~= 7)
        invalidParam = MException('runOtsu:InvalidParam:p1', ...
        'Invalid Parameter: directoryName is not a  valid directory');
        throw(invalidParam);
    end
    
    %% Pre-process
    
    %append \*.dcm to the end of the string so it will only load dicom
    %files
    directoryNameNew = strcat(directoryName,'\*.dcm');
    
    % set the directory where nodule crops are stored
    imageFiles = dir(directoryNameNew);
    
    %% DICOM Segmentation

    %get size of directory
    sizeDir = size(imageFiles,1);
    
    %create structure array of all dicom info and segmentations
    allImages = struct('imageNumber',0,'imageName',char,...
                       'originalImage',[],'segmentations',cell(1,1),...
                       'dicomInfo',struct([]),'map',[],'alpha',[],...
                       'overlay',[],'segmentationType',char,'masks',...
                       cell(1,1));
         
    sg = 'otsu';
    %TODO: WRITE MORE DOCUMENTATION
    parfor i = 1:sizeDir
        
        %get image name
        in = char(imageFiles(i).name);
        
        %Construct the file name and path needed to open the file
        fn = sprintf('%s/%s', directoryName, in);
        % Load dicom image into matlab, see loadDicom for more information
        try
            [dicomImage,info,m,a,o] = loadDicom(fn);
        catch ME
            % TODO: Handle this exception 
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
        %so in the future I won't have to change the extraction
        tempCell = cell(1,1);
        tempCell{1} = otsu(dicomImage,numOfClass);
        allImages(i).segmentations = tempCell; 
    end

    %% Wrap up
    %sort the structure array
    allImages = nestedSortStruct(allImages, 'imageNumber');
    
end

