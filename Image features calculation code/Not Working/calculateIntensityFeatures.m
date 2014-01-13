function calculateIntensityFeatures(pixelCoords, images, boxSize)

range = (boxSize-1)/2;

fid = fopen ('intensity_features.txt', 'a');
fprintf(fid, '%s,%s,%s,%s,%s \n','intense', 'maxInt', 'minInt', 'meanInt', 'SDInt');


%intensityFeatures = zeros( size(pixelCoords, 2) , 5);

for i=1:size(images,2)
    if i==1 || (strcmp(images(i-1), images(i))==0)
        %CTimage = retrieveImage(char(images(i)));
        CTimage = preProcessDicom(char(images(i)));
    end
    
    bBox = double(CTimage(pixelCoords(2,i)-range:pixelCoords(2,i)+range,pixelCoords(1,i)-range:pixelCoords(1,i)+range));
    
    intense = bBox(range+1, range+1);
    maxInt = max(max(bBox));
    minInt = min(min(bBox));
    meanInt = mean2(bBox);
    SDInt = std2(bBox);
    
    fprintf(fid, '%d,%d,%d,%d,%d \n', intense, maxInt, minInt, meanInt, SDInt);
    
    %intensityFeatures(i,:) = [intense maxInt minInt meanInt SDInt];
    disp(i)
end

fclose(fid);

%xlswrite(filename, [{'intense'} {'maxInt'} {'minInt'} {'meanInt'} {'SDInt'}], 'A1:E1');
%success = xlswrite(filename, intensityFeatures, 'Sheet1', 'A2');

