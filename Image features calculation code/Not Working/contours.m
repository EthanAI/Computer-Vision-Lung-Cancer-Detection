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

            I3 = int16(zeros(n_rows,n_cols));
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
           dicomwrite(I3, strcat('contours/',fn2),info);
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
