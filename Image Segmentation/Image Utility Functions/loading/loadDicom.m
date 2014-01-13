function [ dicomImage,dicomInfo,map,alpha,overlays ] = loadDicom(imageName)
%LoadDICOM Summary of this function goes here
%   Simple script that loads a dicom image and provides the header 
%   information in one function call
%   param imageName
%             imageName should be a string that contains the path to the 
%             dicom image, include the file extension also (*.dcm)
%   return dicomInfo
%            Returns dicom image headers information
%   return dicomImage
%            Returns the actual dicom image to be used
%   
%   [X, MAP, ALPHA, OVERLAYS] = DICOMREAD(...) also returns any overlays
%   from the DICOM file.  Each overlay is a 1-bit black and white image
%   with the same height and width as X.  If multiple overlays are present
%   in the file, OVERLAYS is a 4-D multiframe image.  If no overlays are in
%   the file, OVERLAYS is empty.
%
%Path to an example image:
%\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\crops\1.dcm


%PFS 2:38 6/25/2013
%Try/Catch block for file validation
%WHEN YOU READ IN A FILE YOU MIGHT WANT TO CHECK IT, BRO
try
    %Gather the information on the dicom file and read it
    dicomInfo = dicominfo(imageName);
    [dicomImage,map,alpha, overlays] = dicomread(dicomInfo);
catch ME
    %If the file is not a dicom file, then print out the warning
    warning(ME.message);
    rethrow(ME);
end


end

