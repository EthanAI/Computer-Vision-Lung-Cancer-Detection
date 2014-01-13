function [ YVectors ] = Y2YVectors( y, maxClass )
%Y2YVectors converts a list of numercial classifications to an array
%representing the classifications (adds a dimention)
%   Example: Value 3 in a scale of 1-5 will become [0,0,1,0,0]

numExamples = size(y,1);

YVectors = zeros(numExamples, maxClass); 
for i = 1:maxClass
    YVectors(:,i) = (y == i);
end

end

