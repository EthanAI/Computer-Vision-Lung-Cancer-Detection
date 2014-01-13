%M = csvread('C:\Documents and Settings\dzinovev\Desktop\parsed_xml.csv',1,1);
%data = textread('\\ailab03\NEW_LIDC\LIDC\dataset.csv', '', 'delimiter', ',');
%fid = fopen('\\ailab03\NEW_LIDC\LIDC\dataset.csv');
%C = textscan(fid, '%s /n', 'delimiter', ',', 'treatAsEmpty', {'NA', 'na'}, 'commentStyle', '//');
%M = dlmread('\\ailab03\NEW_LIDC\LIDC\dataset.csv', ',');

A=fopen('\\ailab03\NEW_LIDC\LIDC\dataset.csv');
fid = fopen ('\\ailab03\NEW_LIDC\LIDC\dataset_big.csv', 'wt');
fid1 = fopen ('\\ailab03\NEW_LIDC\LIDC\missing.csv', 'wt');
fid2 = fopen ('\\ailab03\NEW_LIDC\LIDC\pmaps.csv', 'wt');
tline = fgetl(A);
current = 0;
missing = 0;
for r = 1:14927
    tline = fgetl(A);
    B=textscan(A,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s /n', 'delimiter',',');
    name = strcat(B{6},B{18},'.dcm');        
    filename = strcat(B{18});    
    noduleid = strcat(B{5});
    pts = strcat(B{19});
    lobul = B{12};
    malig = B{15};
    margin = B{11};
    spher = B{10};
    spicul = B{13};
    subtl = B{7};
    textur = B{14};
    data(r,1)=name;
    data(r,2)=filename;
    data(r,3)=noduleid;
    data(r,4)=pts;
    data(r,5) = lobul;
    data(r,6) = malig;
    data(r,7) = margin;
    data(r,8) = spher;
    data(r,9) = spicul;
    data(r,10) = subtl;
    data(r,11) = textur;
end
check = 1;%need two counters: 1 for going through the list, another for naming purposes
%name = 1;
while (check<14927)
    if (exist(char(data(check,1)),'file'))
        I = dicomread(data{check,1});
        m = data{check,4};
        points = strread(m,'%s','delimiter','*|'); 
        [k,l]=size(points);
        for pts=1:k
            point = strread(points{pts,1},'%d','delimiter','*;');
            xcoord(pts)=point(1);
            ycoord(pts)=point(2);
            %I(point(2),point(1))=2215;
        end;   
        ymax = max(xcoord);    
        ymin = min(xcoord);    
        xmax = max(ycoord);    
        xmin = min(ycoord);
        width = xmax-xmin;
        heigth = ymax-ymin;
        if(width > 4 && heigth > 4)
            current=current+1;
            %cropped = I(xmin:xmax,ymin:ymax);
            BW=zeros(size(I));
            %fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n',num2str(current),char(B{1,2}),char(B{1,3}),char(B{1,4}),char(B{1,5}),char(B{1,6}),char(B{1,7}),char(B{1,8}),char(B{1,9}),char(B{1,10}),char(B{1,11}),char(B{1,12}),char(B{1,13}),char(B{1,14}),char(B{1,15}),char(B{1,16}),char(B{1,17}),char(B{1,18}));
            for pts=1:k
                point = strread(points{pts,1},'%d','delimiter','*;');
                BW(point(2),point(1))=1;
            end; 
            pmap = imfill(BW,'holes');
            cntr = 1;
            lob(cntr)=data(check,5);
            mal(cntr)=data(check,6);
            mar(cntr)=data(check,7);
            sph(cntr)=data(check,8);
            spi(cntr)=data(check,9);
            sub(cntr)=data(check,10);
            tex(cntr)=data(check,11);
            for n=1:14927
                if(n~=check)
                    b=1;
                    if((strcmp(data{check,1},data{n,1})==1)&&(strcmp(data{check,3},data{n,3})==1))
                        cntr = cntr+1;
                        lob(cntr)=data(n,5);
                        mal(cntr)=data(n,6);
                        mar(cntr)=data(n,7);
                        sph(cntr)=data(n,8);
                        spi(cntr)=data(n,9);
                        sub(cntr)=data(n,10);
                        tex(cntr)=data(n,11);
                        a='preved!';
                        m = data{n,4};
                        points = strread(m,'%s','delimiter','*|'); 
                        [k,l]=size(points);
                        BW=zeros(size(I));
                        for pts=1:k
                            point = strread(points{pts,1},'%d','delimiter','*;');
                            xcoord(pts)=point(1);
                            ycoord(pts)=point(2);
                            %I(point(2),point(1))=2215;
                            BW(point(2),point(1))=1;
                        end;   
                        BW = imfill(BW,'holes');
                        a
                        pmap=pmap+BW;
                        data(n)=cellstr('NaN');
                    end
                end
            end
            %check=check+1;
             for curthresh=1:4
                 binar = im2bw(pmap/10, (curthresh-1)/10);
                 if(sum(sum(binar))>0);
                     contur = bwmorph(binar,'remove');
                     [r,c]=find(pmap);
                     maxx = max(c);
                     minx = min(c);
                     maxy = max(r);
                     miny = min(r);
                     cropped = I(minx:maxx,miny:maxy);
                     BW = contur(minx:maxx,miny:maxy);
                %BW = imfill(BW,'holes');
                %imshow(BW,[0 1]);
                     [rows,cols]=size(cropped);
                     for m=1:rows
                         for n=1:cols
                             if(BW(m,n)==1)
                                 croppednod(m,n)=cropped(m,n);
                                 croppedback(m,n)=-2000;
                             else
                                 croppednod(m,n)=-2000;
                                 croppedback(m,n)=cropped(m,n);
                             end;
                         end;
                     end;
%                  figure;
%                  imshow(croppednod,[0 2215]);
%                  figure;
%                  imshow(croppedback,[0 2215]);
%                  figure;
%                  imshow(cropped,[0 2215]);
%                  figure;
%                  imshow(contur,[0 1]);
%                  figure;
%                  imshow(I);
                     fname = strcat(data(check,3),'_',data(check,2),'.dcm');
                     dicomwrite(int16(cropped), strcat('\\Ailab03\NEW_LIDC\LIDC\extract LIDC\pmap\',num2str(curthresh),'\crop\',fname{:}));        
                     dicomwrite(int16(croppednod), strcat('\\Ailab03\NEW_LIDC\LIDC\extract LIDC\pmap\',num2str(curthresh),'\segmented_nodules\',fname{:}));        
                     dicomwrite(int16(croppedback), strcat('\\Ailab03\NEW_LIDC\LIDC\extract LIDC\pmap\',num2str(curthresh),'\segmented_background\',fname{:}));            
                     dicomwrite(int16(BW), strcat('\\Ailab03\new_lidc\LIDC\extract LIDC\pmap\',num2str(curthresh),'\contours\',fname{:}));
                 end;
                % ceil(median(lob));
                 if(size(lob,2)>1)
                     fprintf(fid2,'%s,%s,%s,%s,%s,%s,%s,%s \n',fname{:},num2str(ceil(median(str2double(lob)))),num2str(ceil(median(str2double(mal)))),num2str(ceil(median(str2double(mar)))),num2str(ceil(median(str2double(sph)))),num2str(ceil(median(str2double(spi)))),num2str(ceil(median(str2double(sub)))),num2str(ceil(median(str2double(tex)))));
                 else
                     fprintf(fid2,'%s,%s,%s,%s,%s,%s,%s,%s \n',fname{:},str2double(lob{:}),str2double(mal{:}),str2double(mar{:}),str2double(sph{:}),str2double(spi{:}),str2double(sub{:}),str2double(tex{:}));
                 end                     
             end;
             %name=name+1;
        end;
        clear lob;
        clear mal;
        clear mar;
        clear sph;
        clear spi;
        clear sub;
        clear tex;
        clear xcoord;    
        clear ycoord;
        clear cropped;
        clear croppednod;
        clear croppedback;
        clear BW;
    else
        missing = missing + 1;
        fprintf(fid1,'%s,%s,%s \n',num2str(r+1),char(B{1,6}),char(B{1,18}));
    end;
    check=check+1;
    r
end;
missing
fclose(fid);
fclose(fid1);
fclose(fid2);
fclose(A);