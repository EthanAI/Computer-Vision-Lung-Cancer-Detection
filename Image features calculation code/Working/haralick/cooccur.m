function h = cooccur( m,mask,dir,dist )
%COOCCUR Calculate a co-occurrence matrix
%
%   Mike Lam
%   27 June 2006
%
%   Calculates the co-occurrence matrix of m taken dist units along 
%   the direction given by dir.
    
    % convert data array to 16-bit signed integers
    m = int16(m);
    
    % convert direction to offset vector [dr,dc]
    % take the negative of the row element because
    % rows are the inverse of the y-axis
    radians = dir/180*pi;
    dr = int16(-round(sin(radians)));
    dc = int16(round(cos(radians)));
    
    % find size of matrix and range of values
    mcols = int16(size(m,2));
    mrows = int16(size(m,1));
        
    % find size of matrix and range of values (again)
    mmin = min(m(:));
    mmax = max(m(:));
    
    % initialize co-occurrence matrix
    crows = int16(mmax-mmin)+1;
    ccols = int16(mmax-mmin)+1;
    com = int16(zeros(crows,ccols));
    
    % build co-occurrence matrix
    for r = 1:int16(mrows)
        for c = 1:int16(mcols)  
            %PFS 7/15/2013
            %guard on nodule extraction, only allow pixels in the
            %segmentation to be used
            if( mask(r,c) )
                for d = 1:dist
                    % given direction
                    nr = r+(dr*int16(d));
                    nc = c+(dc*int16(d));
                    if (nr > 0 && nr <= mrows && nc > 0 && nc <= mcols)
                        i = m(r,c)-int16(mmin)+1;
                        j = m(nr,nc)-int16(mmin)+1;
                        com(i,j) = com(i,j) + 1;
                    end
                end
            end
        end
    end    
    
    %convert to floating-point data for analysis
    com = double(com);
    
    % return feature vector
    h = calcHaralick(com); 
    
end
