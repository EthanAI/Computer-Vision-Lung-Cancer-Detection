function perimeter = ConvexPerim( bwImage )

    
    STATS = regionprops(bwImage,'ConvexHull');  
    vertex = STATS.ConvexHull;
    perimeter = 0;
  
    if size(vertex,1) > 2
        for i=2:size(vertex,1)
            % if it is a vertical segment
            if vertex(i,1)== vertex (i-1,1) 
                if vertex(i,2) ~= vertex(i-1,2)
                    perimeter = perimeter + abs( vertex(i,2) - vertex(i-1,2) ); 
                end
            end
            % if it is a horizontal segment
            if vertex(i,1)~= vertex (i-1,1) 
                if vertex(i,2) == vertex(i-1,2)
                    perimeter = perimeter + abs( vertex(i,1) - vertex(i-1,1) ); 
                end
            end
            % if it is any other segment
            if vertex(i,1)~= vertex (i-1,1) 
                if vertex(i,2) ~= vertex(i-1,2)
                    perimeter = perimeter + sqrt( (vertex(i,1) - vertex(i-1,1) )^2 + (vertex(i,2) - vertex(i-1,2) )^2 ); 
                end
            end
           
        end
    end
  
    %Consider special cases, because very small objects have large
    %errors, so call the facet midpoint method for these, and the exceptional
    %cases will be handled correctly.
    Icontour = bwboundaries(bwImage, 'noholes');
    pixel = Icontour{1};
    % If the shape is a single pixel, make the perimeter equal to the perimeter of
    % a circle with area = 1
    if size(pixel,1)== 2
        perimeter = FacetMidpointPerim(bwImage);
    end
    
    %If the shape is two pixels aligned, make the perimeter equal to the perimeter
    % of an eliipse with area = 2 and minor axis equal to 0.5.  
    if size(pixel,1) == 3 && ( pixel(1,1) == pixel(2,1) || pixel(1,2) == pixel(2,2) )
        perimeter = 6.0774;
    end
    
    %If it is four pixels arranged as a square, make the perimeter equal to
    %the periemter of a circle with area = 4
    if(size(pixel, 1) == 5) 
        x = FacetMidpointPerim(bwImage);
        if x == 7.089815;
            perimeter = 7.089815;
        end
    end
end

