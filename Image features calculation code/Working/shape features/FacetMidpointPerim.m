
function finalPerimeter  = FacetMidpointPerim( I )

    % Create an n x 2 matrix representing an ordered set of boundary pixels.
    % - The row  of the matrix represents the index of each boundary pixel.
    % - The first column contains the row index of the boundary pixel in the 
    %   original image.
    % - The second column contains the column index of the boundary pixel in the 
    %    original image.
    % - Single pixel wide strands are listed twice in the ordered list, once
    %   going up the strand and once coming down the other side.
    % - the last member of the list is the first member, so for n pixles,
    %   there are at least n+1 members of the list
    

    % Traverse the contour in order, counting perimeter according to the 
    %relative location of the pixel with respect to the previous one and 
    % the next one.  
    
    Icontour = bwboundaries(I, 'noholes');
    pixel = Icontour{1};
    perimeter = 0;
    for i= 1: size(pixel,1)-1;
        
        if i == 1
            lastPixelIndex = size(pixel,1)-1;
        end
        if i ~=1
            lastPixelIndex = i-1;
        end
        
       %%%%%%%  Determine relative location of last Pixel  %%%%%%%%%%
        lastPixel = 'Void';
        if pixel(lastPixelIndex,1) == pixel(i,1) -1 
            if pixel(lastPixelIndex,2) == pixel(i,2)-1
                lastPixel = 'TL';
            end
        end
        
        if pixel(lastPixelIndex,1) == pixel(i,1)-1
            if pixel(lastPixelIndex,2) == pixel(i,2)
                lastPixel = 'T';
            end
        end
        
        if pixel(lastPixelIndex,1) == pixel(i,1)-1
            if pixel(lastPixelIndex,2) == pixel(i,2)+1
                lastPixel = 'TR';
            end
        end
        
        if pixel(lastPixelIndex,1) == pixel(i,1)
            if pixel(lastPixelIndex,2) == pixel(i,2)-1
                lastPixel = 'L';
            end
        end
        
        if pixel(lastPixelIndex,1) == pixel(i,1)
            if pixel(lastPixelIndex,2) == pixel(i,2)+1
                lastPixel = 'R';
            end
        end
        
        if pixel(lastPixelIndex,1) == pixel(i,1)+ 1
            if pixel(lastPixelIndex,2) == pixel(i,2)-1
                lastPixel = 'BL';
            end
        end
        
        if pixel(lastPixelIndex,1) == pixel(i,1)+ 1
            if pixel(lastPixelIndex,2) == pixel(i,2)
                lastPixel = 'B';
            end
        end
        
         if pixel(lastPixelIndex,1) == pixel(i,1)+ 1
            if pixel(lastPixelIndex,2) == pixel(i,2)+1
                lastPixel = 'BR';
            end
         end
         
         %%%%%%%  Determine relative location of next Pixel  %%%%%%%%%%
        nextPixel = 'void';
        if pixel(i+1,1) == pixel(i,1) -1 
            if pixel(i+1,2) == pixel(i,2)-1
                nextPixel = 'TL';
            end
        end
        
        if pixel(i+1,1) == pixel(i,1)-1
            if pixel(i+1,2) == pixel(i,2)
                nextPixel = 'T';
            end
        end
        
        if pixel(i+1,1) == pixel(i,1)-1
            if pixel(i+1,2) == pixel(i,2)+1
                nextPixel = 'TR';
            end
        end
        
        if pixel(i+1,1) == pixel(i,1)
            if pixel(i+1,2) == pixel(i,2)-1
                nextPixel = 'L';
            end
        end
        
        if pixel(i+1,1) == pixel(i,1)
            if pixel(i+1,2) == pixel(i,2)+1
                nextPixel = 'R';
            end
        end
        
        if pixel(i+1,1) == pixel(i,1)+ 1
            if pixel(i+1,2) == pixel(i,2)-1
                nextPixel = 'BL';
            end
        end
        
        if pixel(i+1,1) == pixel(i,1)+ 1
            if pixel(i+1,2) == pixel(i,2)
                nextPixel = 'B';
            end
        end
        
         if pixel(i+1,1) == pixel(i,1)+ 1
            if pixel(i+1,2) == pixel(i,2)+1
                nextPixel = 'BR';
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(lastPixel,'TL')
        if strcmp(nextPixel,'TL')
            perimeter = perimeter + 4*sqrt(0.5);
        end
        if  strcmp(nextPixel, 'T')
            perimeter = perimeter + (0.5 + (5/2) * sqrt(0.5));
        end
        if  strcmp(nextPixel, 'TR')
            perimeter = perimeter + sqrt(0.5);
        end
        if  strcmp(nextPixel, 'R')
            perimeter = perimeter + (0.5 + 0.5*sqrt(0.5) );
        end
        if  strcmp(nextPixel, 'BR')
            perimeter = perimeter + 2*sqrt(0.5);
        end
        if  strcmp(nextPixel, 'B')
            perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5); 
        end
        if  strcmp(nextPixel, 'BL')
            perimeter = perimeter + 3*sqrt(0.5);
        end
        if  strcmp(nextPixel, 'L')
            perimeter = perimeter + (0.5 + (5/2) * sqrt(0.5));
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'T')
            if strcmp(nextPixel,'TL')
                  perimeter = perimeter + (0.5 + (5/2) * sqrt(0.5));
            end
            if  strcmp(nextPixel, 'T')
                    perimeter = perimeter + (1 + 2*sqrt(0.5) );
            end
            if  strcmp(nextPixel, 'TR')
                    perimeter = perimeter + (0.5 + (5/2) * sqrt(0.5));
            end
            if  strcmp(nextPixel, 'R')
                    %not possible
            end
            if  strcmp(nextPixel, 'BR')
                    perimeter = perimeter + 0.5+0.5*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'B')
                    perimeter = perimeter + 1;
            end
            if  strcmp(nextPixel, 'BL')
                    perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'L')
                    perimeter = perimeter + 1+sqrt(0.5);
            end

    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'TR')
            if strcmp(nextPixel,'TL')
                perimeter = perimeter + 3*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'T')
                perimeter = perimeter + (0.5 + (5/2) * sqrt(0.5));
            end
            if  strcmp(nextPixel, 'TR')
                perimeter = perimeter + 4*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'R')
                 perimeter = perimeter + (0.5 + (5/2) * sqrt(0.5));
            end
            if  strcmp(nextPixel, 'BR')
                 perimeter = perimeter + sqrt(0.5);
            end
            if  strcmp(nextPixel, 'B')
                    perimeter = perimeter + 0.5 + 0.5*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BL')
                    perimeter = perimeter + 2*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'L')
                    perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end


    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'R')
            if strcmp(nextPixel,'TL')
                perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'T')
                perimeter = perimeter + 1 + sqrt(0.5);
            end
            if  strcmp(nextPixel, 'TR')
                perimeter = perimeter + 0.5 + (5/2)* sqrt(0.5);
            end
            if  strcmp(nextPixel, 'R')
                perimeter = perimeter + 1+ 2* sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BR')
                % not possible
            end
            if  strcmp(nextPixel, 'B')
                % no contribution
            end
            if  strcmp(nextPixel, 'BL')
                perimeter = perimeter + 0.5 + 0.5*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'L')
                perimeter = perimeter + 1;
            end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'BR')
            if strcmp(nextPixel,'TL')
                perimeter = perimeter + 2*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'T')
                perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'TR')
                perimeter = perimeter + 3*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'R')
                perimeter = perimeter + 0.5 + (5/2) * sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BR')
                perimeter = perimeter + 4*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'B')
                %no contribution
            end
            if  strcmp(nextPixel, 'BL')
                perimeter = perimeter + sqrt(0.5);
            end
            if  strcmp(nextPixel, 'L')
                perimeter = perimeter + 0.5 + 0.5*sqrt(0.5);
            end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'B')
            if strcmp(nextPixel,'TL')
                perimeter = perimeter + 0.5 + 0.5*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'T')
                perimeter = perimeter + 1;
            end
            if  strcmp(nextPixel, 'TR')
                perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'R')
                perimeter = perimeter + 1+ sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BR')
                perimeter = perimeter + 0.5 + (5/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'B')
                perimeter = perimeter + 1 + 2*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BL')
                %No contribution
            end
            if  strcmp(nextPixel, 'L')
                %No contribution
            end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'BL')
           if strcmp(nextPixel,'TL')
                perimeter = perimeter + sqrt(0.5);
            end
            if  strcmp(nextPixel, 'T')
                perimeter = perimeter + 0.5 + 0.5*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'TR')
                perimeter = perimeter + 2*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'R')
                perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BR')
                perimeter = perimeter + 3*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'B')
                perimeter = perimeter + 0.5 + (5/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'BL')
                perimeter = perimeter + 4*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'L')
                %no contribution
            end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  strcmp(lastPixel, 'L')
            if strcmp(nextPixel,'TL')
                %No contribution
            end
            if  strcmp(nextPixel, 'T')
                %No Contribution
            end
            if  strcmp(nextPixel, 'TR')
                perimeter = perimeter + 0.5 + 0.5*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'R')
                perimeter = perimeter + 1;
            end
            if  strcmp(nextPixel, 'BR')
                perimeter = perimeter + 0.5 + (3/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'B')
                perimeter = perimeter + 1 + sqrt(0.5);
                
                
            end
            if  strcmp(nextPixel, 'BL')
                perimeter = perimeter + 0.5 + (5/2)*sqrt(0.5);
            end
            if  strcmp(nextPixel, 'L')
                perimeter = perimeter + 1 + 2*sqrt(0.5); 
            end
           
    end
    
    
    
    end
    finalPerimeter = perimeter;
    
    % In three cases, P^2 < 4*pi*A, which is not possible in Euclidean geometry
    % so we adjust the perimeter to equal a value which satisfies this relationship
        
    % if it is just one pixel, make the perimeter equal to the perimeter of
    % a circle with area equal to 1
    if size(pixel,1)== 2
        finalPerimeter = 2*sqrt(pi); %3.544908;
    end
    %If it is two pixels aligned, make the perimeter equal to the perimeter of 
    %an ellipse with ara equal to 2 and minor axis = 0.5
    if size(pixel,1) == 3 && ( pixel(1,1) == pixel(2,1) || pixel(1,2) == pixel(2,2) )
        finalPerimeter =  6.0774;
    end
    %If it is four pixels arranged as a square
    if(size(pixel, 1) == 5) 
        if (perimeter < 6.8285)
            finalPerimeter = 7.089815;
        end
    end
    
end








