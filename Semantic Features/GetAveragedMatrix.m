function [ AveragedMatrix, instanceOrder ] = GetAveragedMatrix( InputMatrix, ratingRow, instanceID )
%GetAveragedRows Converts matrix from raw format to averaged format
%   Takes an X or Y matrix and ratingRow(which describes how many rows per
%   nodule) and averages each set of rows into a single row. 

j = 1;
i = 1;
del = 3;
while i <= size(InputMatrix,1)
    instanceOrder(j,:) = zeros(1,4); %Make a new empty row
    if i == ratingRow(3)
        del = del-1;
    end
    if i == ratingRow(2)
        del = del-1;
    end
    if i == ratingRow(1)
        del = del-1;
    end
    instanceOrder(j,1:1+del) = instanceID(i:i+del)';
    AveragedMatrix(j,:) = mean(InputMatrix(i:i+del,:),1);
    i = i + del + 1;
    j = j+1;
end