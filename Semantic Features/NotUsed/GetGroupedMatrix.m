function [ GroupedMatrix ] = GetGroupedMatrix( InputMatrix, ratingRow )
%GroupedMatrix Converts matrix from raw format to concatenated format
%   Takes an X or Y matrix and ratingRow(which describes how many rows per
%   nodule) and puts all the data from the related group on the same line
%   (can be modified if we want 1 1 1 2 2 2 instead of 123 123 123)

j = 1;
i = 1;
del = 3;
while i <= size(InputMatrix,1)
    if i == ratingRow(3)
        del = del-1;
    end
    if i == ratingRow(2)
        del = del-1;
    end
    if i == ratingRow(1)
        del = del-1;
    end
    GroupedMatrix(j,1:(del+1)*size(InputMatrix,2)) = reshape(InputMatrix(i:i+del,:)', 1,[]);
    i = i + del + 1;
    j = j+1;
end