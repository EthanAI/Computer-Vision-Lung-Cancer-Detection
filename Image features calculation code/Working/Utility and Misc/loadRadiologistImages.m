function [ allImages ] = loadRadiologistImages( dirIc, dirIn )
%LOADRADIOLOGISTSIMAGES Takes two directories of images and creates an
%structure array with all information from those DICOM images

%Path to crops:  '\\ailab03\WeakSegmentation\6K largest slice crops'
%Path to nodules: '\\ailab03\WeakSegmentation\6k largest slice nodules'


%% Pre-process

    %append \*.dcm to the end of the string so it will only load dicom
    %files
    dirIcNew = strcat(dirIc,'\*.dcm');
    
    %append \*.dcm to the end of the string so it will only load dicom
    %files
    dirInNew = strcat(dirIn,'\*.dcm');
    


    % set the directory where nodule crops are stored
    imageCrops = dir(dirIcNew);
    % set the directory where nodule are stored
    imageNodules = dir(dirInNew);
    
    
    %get size of directory
    sizeDir = size(imageCrops,1);

    %create structure array of all dicom info and masks
    allImages = struct('imageNumber',0,'imageName',char,...
                       'originalImage',[],'segmentations',cell(1,1),...
                       'dicomInfo',struct([]),'map',[],'alpha',[],...
                       'overlay',[],'segmentationType',char,'masks',...
                       cell(1,1));
               
    sg = 'org';

%% load images and masks

    for i = 1:sizeDir

        %get image crop name
        ic = char(imageCrops(i).name);
        %Construct the file name and path needed to open the file
        icfn = sprintf('%s/%s', dirIc, ic);
        %load image crop
        try
            [dicomImage,info,m,a,o] = loadDicom(icfn);
        catch ME
            % TODO: Handle this exception 
        end 
        
        %get image nodule name
        in = char(imageNodules(i).name);
        %Construct the file name and path needed to open the file
        infn = sprintf('%s/%s', dirIn, in);
        %load image nodule
        try
            mask = loadDicom(infn);
        catch ME
            % TODO: Handle this exception 
        end 
        
        
        %change mask to a binary image
        mask = logical(mask);
        
        %save in the structure
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
        %save the mask
        allImages(i).masks{1} = mask;
        
    end
    

end

