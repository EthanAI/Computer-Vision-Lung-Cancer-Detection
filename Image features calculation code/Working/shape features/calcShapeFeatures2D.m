 function STATS = calcShapeFeatures2D(bwImage)
        %% compute shape features 
        
        % given an image region and returns a structure with the results.         
        STATS = regionprops (bwImage,'Area', 'Extent', 'Perimeter', ...
            'Centroid', 'ConvexArea', 'ConvexImage','ConvexHull',...
            'Solidity', 'Eccentricity', 'MajorAxisLength', ...
            'EquivDiameter','MinorAxisLength');      
       
        %Call custom perimeter and convex perimeter method, because it is more precise 
	    STATS.Perimeter = FacetMidpointPerim(bwImage);                              
        STATS.ConvexPerimeter = ConvexPerim(bwImage);
	
        %Circularity
	    STATS.Circularity = (4*pi*STATS.Area)/(STATS.ConvexPerimeter^2); 
        %Roughness
        STATS.Roughness = STATS.ConvexPerimeter/STATS.Perimeter; 
        %Elongation
        STATS.Elongation = STATS.MajorAxisLength/STATS.MinorAxisLength;
        %Compactness 
        STATS.Compactness = STATS.Perimeter^2/(4*pi*STATS.Area);                   
        
        %% Compute Maximum Chord Length
        
        convexHullVertices = STATS.ConvexHull;
        maxChordLength = 0;
        
        for j = 1:size(convexHullVertices,1)-1
            for k = j+1: size(convexHullVertices,1)
               
                chordLength =  sqrt( ( convexHullVertices(j,1) - convexHullVertices(k,1) )^2 + ( convexHullVertices(j,2)- convexHullVertices(k,2) )^2 ) ;
               if chordLength  >  maxChordLength 
                   maxChordLength = chordLength;
               end
                
            end
        end
        STATS.MaxChordLength = maxChordLength;         
        
        %% Compute Radial distance Standard Deviation
        
        I3=bwmorph(bwImage,'remove'); % Nodule Outline
        DR = NaN;   % Vector of Outline Distance for RadialDistanceSD
        j = 0;
        for r = 1:size(I3,1)
            for c = 1:size(I3,2)
                if (I3(r,c) == 1)
                    j = j + 1;
                    % Distance
                    DR(j) = sqrt((c-STATS.Centroid(1))^2+(r-STATS.Centroid(2))^2);   
                end
            end
        end
        % RadialDistanceSD
        STATS.RadialDistanceSD = nanstd(DR(:));          
        
        %% Compute 2nd Moment 
        % Vector of Distance to every pixel in the region for 2nd Moment
        DSM = NaN;  
        k = 0;
        for r1 = 1:size(bwImage,1)
            for c1 = 1:size(bwImage,2)
                if (bwImage(r1,c1) == 1)
                    k = k + 1;
                    % Distance Square
                    DSM(k) = (c1-STATS.Centroid(1))^2+(r1-STATS.Centroid(2))^2;   
                end
            end
        end
        % SecondMoment (Variance)/Area
        STATS.SecondMoment = sum(DSM)/(STATS.Area)^2;    
        
        
end
