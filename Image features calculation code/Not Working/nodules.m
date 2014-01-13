function extractnodules( )
%EXTRACTNODULES Extract nodule images from lung CT scans
%
%   Ekarin Varutbangkul
%   July 8, 2006
%
%   Reads nodule data from 'DCMInfo2.txt' in working directory and pulls
%   individual nodule images from DICOM images referenced in the data
%   file, writing them to new DICOM images in the 'nodules/' directory.
%   Also saves all Haralick and annotation data to 'haralick.txt' in the
%   same directory.

tic

fid = fopen('contours.txt', 'rt');
% read line from data file
tline = fgetl(fid);
% extract nodule information
[pk n_filename n_minx n_maxx n_miny n_maxy n_x n_y ] ...
     = strread(tline, '%d %s %d %d %d %d %d %d');
%cn = 1;
%while cn<4 
while feof(fid) == 0
    
%    k1 = n_file;
%    k2 = n_id;
    k1 = pk;
    s_minx = n_minx;
    s_maxx = n_maxx;
    s_miny = n_miny;
    s_maxy = n_maxy;
    fn = sprintf('%s', char(n_filename));
    fn2 = sprintf('%d.dcm', pk);
    fprintf(1,'    Processing: %d  (x=[%d,%d] y=[%d,%d]) ...\n', pk, n_minx, n_maxx, n_miny, n_maxy);
  
    % make sure file exists
    if (exist(fn,'file'))
        
        % read image
        info = dicominfo(fn);
        I = dicomread(info);

        % get nodule range
        n_rows = n_maxy - n_miny + 1;
        n_cols = n_maxx - n_minx + 1;

        % minimum nodule size is 5x5 pixels
        if (n_rows > 4 && n_cols > 4)

            % extract nodule data
            I2 = int16(zeros(n_rows,n_cols));
            I3 = int16(zeros(n_rows,n_cols));
            I4 = int16(zeros(n_rows,n_cols));
            for r = 1:n_rows
                for c = 1:n_cols
                    I2(r,c) = I(n_miny+(r-1),n_minx+(c-1));
                end
            end                
            bg = -2000;
            k_minx = n_minx;
            k_miny = n_miny;
           while (k1 == pk) & (feof(fid) == 0)
                I3((n_y-n_miny)+1,(n_x-n_minx)+1)= 1;  
                if feof(fid) == 0
                    tline = fgetl(fid);
                    [pk n_filename n_minx n_maxx n_miny n_maxy n_x n_y ] ...
                    = strread(tline, '%d %s %d %d %d %d %d %d');   
                end
           end
           BW = zeros(n_rows,n_cols);
           BW = imfill(I3,'holes');
           I3 = BW;
           I3(I3 == 0) = bg;
           I4 = BW;
% old segmentation code 
%{ 
            for r = 1:n_rows
                for c = 1:n_cols
                    if (I3(r,c) ~= 1)
                        I3(r,c) = bg;
                    else
                        break;
                    end
                end
            end
            for r = 1:n_rows
                for c = n_cols:-1:1
                    if (I3(r,c) ~= 1)
                        I3(r,c) = bg;
                    else
                        break;
                    end
                end
            end
            for c = 1:n_cols
                for r = 1:n_rows
                    if (I3(r,c) ~= 1)
                        I3(r,c) = bg;
                    else
                        break;
                    end
                end
            end
            for c = 1:n_cols
                for r = n_rows:-1:1
                    if (I3(r,c) ~= 1)
                        I3(r,c) = bg;
                    else
                        break;
                    end
                end
            end
%}
            for r = 1:n_rows
                for c = 1:n_cols
                    if I3(r,c)~= bg
                        I3(r,c) = I(k_miny+(r-1),k_minx+(c-1));
                    end
                end
            end 
            for r = 1:n_rows
                for c = 1:n_cols
                    if I4(r,c)== 0
                        I4(r,c) = I(k_miny+(r-1),k_minx+(c-1));
                    else
                        I4(r,c) = bg;
                    end
                end
            end 

            % save nodule image
            info.Width = n_cols;
            info.Height = n_rows;
            info.Rows = n_rows;
            info.Columns = n_cols;
            dicomwrite(I2, strcat('crop/',fn2),info);
            dicomwrite(I3, strcat('segmented_nodules/',fn2),info);
            dicomwrite(I4, strcat('segmented_background/',fn2),info);
            
%            fprintf(1,'    Saving data ...\n');
         else
%            fprintf(1,'%s is too small (less than 5x5) -- skipping ...\n',fn2)
            epk = pk;
            while (feof(fid) == 0) & (epk == pk)        
                tline = fgetl(fid);
                    [pk n_filename n_minx n_maxx n_miny n_maxy n_x n_y ] ...
                    = strread(tline, '%d %s %d %d %d %d %d %d');   
            end
        end
    else
        fprintf(1,'    File does not exist: %s -- skipping ...\n', fn)
        while (feof(fid) == 0) & (epk == pk)  
            tline = fgetl(fid);
                    [pk n_filename n_minx n_maxx n_miny n_maxy n_x n_y ] ...
                    = strread(tline, '%d %s %d %d %d %d %d %d');   
        end
    end
%    cn = cn+1;
end
fclose(fid);
toc
