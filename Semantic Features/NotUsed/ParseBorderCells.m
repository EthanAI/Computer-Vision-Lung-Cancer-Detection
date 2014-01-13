function [ BORDERS ] = ParseBorderCells( borderCells )
%ParseBorderCells gets numberical values of the coordinates of the
%boundaries
%   borderCells contain coordinates in text format. This function converts
%   it into an acceptable formatting, then switches each line of text to be
%   a nx2 array of x,y coordinates. Arrays vary in length so BORDERS stores
%   each one in a cell.

%Note: Turns out the border data in the .xlsx and possibly the XML files
%are corrupted. Maxing out at 255 characters, its not the whole border..
BORDERS = cell(1,length(borderCells)); % allocate memory

strings = char(borderCells); %Convert from cell to string
for i = 1:length(borderCells)
    strings(i,:) = strrep(strrep(strings(i,:), ';', ' '), '|', ';'); %Adjust formatting
    BORDERS{i} = str2num(strings(i,:)); %convert from text to matrices
end


end

