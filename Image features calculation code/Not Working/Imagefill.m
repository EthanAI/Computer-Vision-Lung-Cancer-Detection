%filename = 'C:\Documents and Settings\akim2\Desktop\IMFILL\new_parsed_xml.csv';
filename = '\\ailab03\NEW_LIDC\LIDC\extract LIDC\new_parsed_xml.csv';
excelSheet = csvread_mod(filename);
count= 1;
for t= 1:size(excelSheet,1) 
    R = rem(t,18);
    if R==0
    coor(count,1)=excelSheet(t,1) ;
    count = count+1;
    end
end
counter =1;
%Take imageSOPs and put them in imageSOP_UIDs matrix


%for t=1:size(excelSheet, 1)
                        fid = fopen ('nodules_features.txt', 'wt');
                        fid2 = fopen ('nodules_many_regions.txt', 'wt');
                        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s \n','ImageName','Circularity','Roughness','Elongation','Compactness','Eccentricity','Solidity','Extent','RadialDistanceSD');
                        fprintf(fid2,'%s,%s,%s,%s,%s,%s,%s,%s,%s \n','ImageName','Circularity','Roughness','Elongation','Compactness','Eccentricity','Solidity','Extent','RadialDistanceSD');

for i=2:size(excelSheet, 1)
    s1 = coor{i,:};
   

    s2 = regexp(s1, '\|', 'split');
 

    s2(:);
    for j= 1:size(s2,2)
        s3(j) = regexp(s2(j), '\;', 'split');
    end
    
    for k=1:size(s2,2)-1
        c=s3{k};
        y=c{1};
        x=c{2};
        x=str2num(x);
        y=str2num(y);
        b(k)=x;
        d(k)=y;
        a(1,k)=x-287;
        a(2,k)=y-87;

    end
    maxx=0; 
    maxy=0;
    minx=0;
    miny=0;
    %for c= 1:k
            maxx= max(b);
            maxy= max(d);
            minx= min(b);
            miny= min(d);
            I= zeros((maxx-minx)+1,(maxy-miny)+1);  
    %end
    for f=1:size(s2,2)-1
    x=b(f)-minx;
    y=d(f)-miny;       
    I(x+1,y+1)= 1; 
    end
    I2=im2bw(I);
    I3=imfill(I2,'holes');
    %figure;
    %imshow(I3);
    
    %HERE GOES FEATURE CALCULATION STUFF
                        count = 0;
                        %for i = 1:size(files,1)
%                             fn = sprintf('%s/%s', 'segmented_nodules', char(files(i).name));
%                             fn2 = sprintf('%s/%s', 'segmented_background', char(files(i).name));
%                             info = dicominfo(fn);
%                             info4 = dicominfo(fn2);
%                             I = dicomread(info);
%                             I4 = dicomread(info4);
%                             BW = (I~=-2000);
                            L = bwlabel(I3);
                            a = L;
                            flag = 0;
                            if (nanmax(a(:)) > 1)
                                flag = 1;
                            end
                            a(a~=0 & a~=1) = 0;
                            STATS = regionprops (a,'Area', 'Extent', 'Perimeter', 'Centroid', 'ConvexArea', 'ConvexImage', 'Solidity', 'Eccentricity', 'MajorAxisLength', 'EquivDiameter', 'MinorAxisLength');
                            STATS.ConvexPerimeter = 2 * (sqrt(pi*STATS.ConvexArea));
                            STATS.Circularity = (4*pi*STATS.Area)/(STATS.ConvexPerimeter .^ 2);
                            STATS.Elongation = STATS.MajorAxisLength/STATS.MinorAxisLength;
%                             b = double(I);
%                             b(b==-2000) = NaN;
%                             b4 = double(I4);
%                             b4(b4==-2000) = NaN;
%                             STATS.MinIntensity = nanmin(b(:));
%                             STATS.MaxIntensity = nanmax(b(:));
%                             STATS.MeanIntensity = nanmean(b(:));
%                             STATS.SDIntensity = nanstd(b(:));
%                             STATS.MinIntensityBG = nanmin(b4(:));
%                             STATS.MaxIntensityBG = nanmax(b4(:));
%                             STATS.SDIntensityBG = nanstd(b4(:));    
%                             STATS.MeanIntensityBG = nanmean(b4(:));
%                             STATS.IntensityDifference = abs(STATS.MeanIntensity - STATS.MeanIntensityBG);
%                             fprintf(files(i).name,',',STATS(1).Area,',', STATS(1).Extent,',', STATS(1).Perimeter,'\n');
%                             count = count+1
%                             fn2 = sprintf('%s/%s', 'contours', char(files(i).name));
%                             info2 = dicominfo(fn2);
%                             I2 = dicomread(info2);
                            d = NaN;
                            j = 0;
                            for r = 1:size(I3,1)
                                for c = 1:size(I3,2)
                                    if (I2(r,c) == 1)
                                        j = j + 1;
                                        d(j) = sqrt(double((c-(STATS.Centroid(1)^2))+(r-(STATS.Centroid(2)^2))));
                                    end
                                end
                            end
                            STATS.RadialDistanceSD = nanstd(d(:));
                            STATS.Perimeter = j;
                            I3 = bwperim(STATS.ConvexImage);
                            j = 0;
                            for r = 1:size(I3,1)
                                for c = 1:size(I3,2)
                                    if (I3(r,c) == 1)
                                        j = j + 1;
                                    end
                                end
                            end
                            STATS.ConvexPerimeter = j;
                            STATS.Roughness = STATS.ConvexPerimeter/STATS.Perimeter;
                            STATS.Compactness = STATS.Perimeter^2/(4*pi*STATS.Area);
                            if (flag == 0)
                                fprintf(fid,'%s,%f,%f,%f,%f,%f,%f,%f,%f \n',files(i).name,STATS.Circularity,STATS.Roughness,STATS.Elongation,STATS.Compactness,STATS.Eccentricity,STATS.Solidity,STATS.Extent,STATS.RadialDistanceSD);
                            else
                                fprintf(fid2,'%s,%f,%f,%f,%f,%f,%f,%f,%f \n',files(i).name,STATS.Circularity,STATS.Roughness,STATS.Elongation,STATS.Compactness,STATS.Eccentricity,STATS.Solidity,STATS.Extent,STATS.RadialDistanceSD);
                            end
                        %end

    
    clear I;
    clear d;
    clear b;    
    clear I3;
end
                        fclose(fid);
                        fclose(fid2);
%end

