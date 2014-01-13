
function finalPerimeter  = EuclideanPerim( I )

    % This procedure calculates perimeter by traversing the boundary pixels 
    % in order and counting 1 for each horizontal or vertical move, and 
    % sqrt(2) for each diagonal move. 

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
    Icontour = bwboundaries(I, 'noholes');
    pixelIndex = Icontour{1};

    % Traverse the contour in order, counting perimeter according to the number
    % of horizontal and vertical moves
    diagonalWeight = sqrt(2);
    perimeter = 0;
    
    
    for i= 2: size(pixelIndex,1);

        % if next move is diagonal (both row and column change), add sqrt(2)
        if pixelIndex(i,1) ~= pixelIndex(i-1,1) 
            if pixelIndex(i,2) ~= pixelIndex(i-1,2)
                perimeter = perimeter + diagonalWeight;
            end

        end
        % if next move is vertical (column didn't change), add 1 
        if pixelIndex(i,2) == pixelIndex(i-1,2) 
            perimeter = perimeter + 1;
        end
       % if next move is horizontal (row didn't change); add 1
        if pixelIndex(i,1) == pixelIndex(i-1,1) 
            perimeter = perimeter + 1;
        end
        
    end
    finalPerimeter = perimeter;
end

