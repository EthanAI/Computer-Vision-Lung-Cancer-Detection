tic
files = dir('\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\nodules\*.dcm');
count = 0;
fid = fopen ('\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\nodules_features_new_per2.txt', 'wt');
fid2 = fopen ('\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\nodules_many_regions_new_per2.txt', 'wt');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n','ImageName','Area','ConvexArea','Circularity','Perimeter','ConvexPerimeter','Roughness','EquivDiameter','MajorAxisLength','MinorAxisLength','Elongation','Compactness','Eccentricity','Solidity','Extent','RadialDistanceSD','MinIntensity','MaxIntensity','MeanIntensity','SDIntensity','MinIntensityBG','MaxIntensityBG','MeanIntensityBG','SDIntensityBG','IntesityDifference');
fprintf(fid2,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n','ImageName','Area','ConvexArea','Circularity','Perimeter','ConvexPerimeter','Roughness','EquivDiameter','MajorAxisLength','MinorAxisLength','Elongation','Compactness','Eccentricity','Solidity','Extent','RadialDistanceSD','MinIntensity','MaxIntensity','MeanIntensity','SDIntensity','MinIntensityBG','MaxIntensityBG','MeanIntensityBG','SDIntensityBG','IntesityDifference');
for i = 1:size(files,1)
    i
    fn = sprintf('%s/%s', '\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\nodules', char(files(i).name));
    fn2 = sprintf('%s/%s', '\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\backgroungs', char(files(i).name));
    if exist(fn, 'file')

        info = dicominfo(fn);
        info4 = dicominfo(fn2);
        I = dicomread(info);
        I4 = dicomread(info4);
        BW = (I~=-2000);
        L = bwlabel(BW);
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
        b = double(I);
        b(b==0) = NaN;
        b4 = double(I4);
        b4(b4==0) = NaN;
        STATS.MinIntensity = nanmin(b(:));
        STATS.MaxIntensity = nanmax(b(:));
        STATS.MeanIntensity = nanmean(b(:));
        STATS.SDIntensity = nanstd(b(:));
        STATS.MinIntensityBG = nanmin(b4(:));
        STATS.MaxIntensityBG = nanmax(b4(:));
        STATS.SDIntensityBG = nanstd(b4(:));    
        STATS.MeanIntensityBG = nanmean(b4(:));
        STATS.IntensityDifference = abs(STATS.MeanIntensity - STATS.MeanIntensityBG);
        fprintf(files(i).name,',',STATS(1).Area,',', STATS(1).Extent,',', STATS(1).Perimeter,'\n');
        count = count+1;
        fn2 = sprintf('%s/%s', '\\ailab03\LIDC\LIDC_FULL\LIDC-IDRI\exctract\outlines', char(files(i).name));
        info2 = dicominfo(fn2);
        I2 = dicomread(info2);
        I2=bwmorph(I2,'remove');
        d = NaN;
        j = 0;
        for r = 1:size(I2,1)
            for c = 1:size(I2,2)
                if (I2(r,c) > 0)
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
                if (I3(r,c) > 0)
                    j = j + 1;
                end
            end
        end
        STATS.ConvexPerimeter = j;
        STATS.Roughness = STATS.ConvexPerimeter/STATS.Perimeter;
        STATS.Compactness = STATS.Perimeter^2/(4*pi*STATS.Area);
        if (flag == 0)
            fprintf(fid,'%s,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f \n',files(i).name,STATS.Area,STATS.ConvexArea,STATS.Circularity,STATS.Perimeter,STATS.ConvexPerimeter,STATS.Roughness,STATS.EquivDiameter,STATS.MajorAxisLength,STATS.MinorAxisLength,STATS.Elongation,STATS.Compactness,STATS.Eccentricity,STATS.Solidity,STATS.Extent,STATS.RadialDistanceSD,STATS.MinIntensity,STATS.MaxIntensity,STATS.MeanIntensity,STATS.SDIntensity,STATS.MinIntensityBG,STATS.MaxIntensityBG,STATS.MeanIntensityBG,STATS.SDIntensityBG,STATS.IntensityDifference);
        else
            fprintf(fid2,'%s,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f \n',files(i).name,STATS.Area,STATS.ConvexArea,STATS.Circularity,STATS.Perimeter,STATS.ConvexPerimeter,STATS.Roughness,STATS.EquivDiameter,STATS.MajorAxisLength,STATS.MinorAxisLength,STATS.Elongation,STATS.Compactness,STATS.Eccentricity,STATS.Solidity,STATS.Extent,STATS.RadialDistanceSD,STATS.MinIntensity,STATS.MaxIntensity,STATS.MeanIntensity,STATS.SDIntensity,STATS.MinIntensityBG,STATS.MaxIntensityBG,STATS.MeanIntensityBG,STATS.SDIntensityBG,STATS.IntensityDifference);
        end
    end
end
fclose(fid);
fclose(fid2);
toc