function features = cooccurfeatures( I , mask)
%COOCCURFEATURES Calculates Haralick features from co-occurrance matrices
%
%   Mike Lam
%   27 June 2006
%
% Returns a feature vector of Haralick descriptors given a grayscale
% image. This vector is formed by calculating the Haralick descriptors
% for all four directions and several distances. These values are
% then averaged by distance and then direction for the final vector.

    
% parameters
mindist = 1;
maxdist = 1;
%fuck you and your hard-coded size param
ndescriptors = 13;

% prepare image
if isa(I,'double') ~= 1 
    I = double(I);
end

% calculate [direction x distance x descriptor] matrix
allharalick = zeros(4,maxdist-mindist+1,ndescriptors);
for dir = 0:3
    for dist = mindist:maxdist
        ch = cooccur(I,mask,dir*45,dist);
        for i = 1:ndescriptors
            allharalick(dir+1,dist,i) = ch(i);
        end
    end
end

% average values by distance into [direction x descriptor] matrix
average = zeros(4,6);
for dir = 0:3
    for i = 1:ndescriptors
        average(dir+1,i) = mean(allharalick(dir+1,:,i));
    end
end

% take average values by direction for descriptor matrix
features = zeros(1,ndescriptors);
for i = 1:ndescriptors
    features(i) = mean(average(:,i));
end
