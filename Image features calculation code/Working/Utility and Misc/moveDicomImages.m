%Moves files from one folder to another
num = xlsread('LIDC all radiologists cases for largest slice cleaned modified (Image Names only).xlsx');

num = num';

%replace sometime
imageNames = strread(num2str(num),'%s');

imageNames = imageNames';

folderLocation = '\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\nodules\';

fileExt = '.dcm';

for i=1:size(imageNames,2) 
   t = strcat(folderLocation,imageNames{i},fileExt);
   copyfile(t,'\\ailab03\WeakSegmentation\6k largest slice nodules');
end