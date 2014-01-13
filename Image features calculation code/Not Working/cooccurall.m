function haralick = cooccurall(m)
%COOCCURALL Calculate all co-occurrence matrices and Haralick descriptors
%
%   Mike Lam
%   20 June 2006
%
%   Calculates co-occurrence matrices of a matrix along four directions
%   (0, 45, 90 and 135 degrees) and five distances (1..5) and produces
%   an array of six Haralick descriptors: variance, entropy, energy,
%   homogeneity, 3rd order moment, inverse variance.

    tic
    
    disp(' ')
    disp('original matrix:')
    disp(m)
    
    % calculate [direction x distance x descriptor] matrix
    allharalick = zeros(4,5,6);
    for dir = 0:3
        for dist = 1:5
            ch = cooccur(m,dir*45,dist,0);
            for i = 1:6
                allharalick(dir+1,dist,i) = ch(i);
            end
        end
    end
    
    % average values by distance into [direction x descriptor] matrix
    average = zeros(4,6);
    for dir = 0:3
        for i = 1:6
            average(dir+1,i) = mean(allharalick(dir+1,:,i));
        end
    end
    
    % take min values for descriptor matrix
    haralick = [0 0 0 0 0 0];
    for i = 1:6
        haralick(i) = min(average(:,i));
    end
    
    fprintf('  variance \t\t\t= %f\n', haralick(1))
    fprintf('  entropy \t\t\t= %f\n', haralick(2))
    fprintf('  energy \t\t\t= %f\n', haralick(3))
    fprintf('  homogeneity \t\t= %f\n', haralick(4))
    fprintf('  3rd order moment \t= %f\n', haralick(5))
    fprintf('  inverse variance \t= %f\n', haralick(6))
    fprintf('\n')
    
    toc
end