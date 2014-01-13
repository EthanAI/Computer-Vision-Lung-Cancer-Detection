%Take imageSOPs and put them in imageSOP_UIDs matrix


for i=1573:size(coords, 1)
    s1 = coords{i,:};
    imname = paths(i);

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

    maxx= max(b);
    maxy= max(d);
    minx= min(b);
    miny= min(d);

    if exist(imname{:})>0
        I = dicomread(imname{:});
        J=dicominfo(imname{:});
        RI=J.RescaleIntercept;
        Icropped = I(minx:maxx,miny:maxy)-RI;
        contour=zeros(size(Icropped));
        Ibg=int16(zeros(size(Icropped)));
        Inod=int16(zeros(size(Icropped)));
        for f=1:size(s2,2)-1
            x=b(f)-minx;
            y=d(f)-miny;       
            contour(x+1,y+1)= 1; 
        end
        contour=im2bw(contour);
        I3=imfill(contour,'holes');
        for l=1:size(contour,1)
            for m=1:size(contour,2)
                if I3(l,m)==0
                   Ibg(l,m)=Icropped(l,m);
                   Inod(l,m)=0;
                else if I3(l,m)==1
                        Ibg(l,m)=0;
                        Inod(l,m)=Icropped(l,m);
                    end
                end            
            end
        end

        %imshow(Icropped, [min(min(Icropped)) max(max(Icropped))]);
        dicomwrite(Icropped, strcat('new/crop/',int2str(i),'.dcm'));
        dicomwrite(contour, strcat('new/contours/',int2str(i),'.dcm'));
        dicomwrite(int16(Ibg), strcat('new/segmented_background/',int2str(i),'.dcm'));
        dicomwrite(int16(Inod), strcat('new/segmented_nodules/',int2str(i),'.dcm'));
        i
        clear I;
        clear I3;    
    end
    clear d;
    clear b;    

end
                        fclose(fid);
                        fclose(fid2);
%end

