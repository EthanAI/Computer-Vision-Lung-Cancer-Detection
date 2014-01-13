function [ bestOfArray ] = bestOfArray( array, num )
%bestOfArray Returns array of the same size with all but the top num items
%reduced to zero


sorted = sort(array,'descend');
bestOfArray = zeros(size(array,1), size(array,2));
for i = 1:num
    keep = (array == sorted(i));
    bestOfArray = bestOfArray + keep .* array;
end

end

