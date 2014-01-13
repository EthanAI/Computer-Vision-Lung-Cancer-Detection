%Take imageSOPs and put them in imageSOP_UIDs matrix


for i=1:size(coords1, 1)
    s1 = coords1{i,:};

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
       %  a(1,k)=x-287;
       %  a(2,k)=y-87;

    end


        contour=zeros(512,512);
        for f=1:size(s2,2)-1
            x=b(f);
            y=d(f);       
            contour(x,y)= 1; 
        end
        contour=im2bw(contour);
figure;
imshow(contour);
        clear I;
        clear I3;    

    clear d;
    clear b;    
end

