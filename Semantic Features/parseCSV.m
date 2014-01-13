function [ valueArray headerArray dcmArray ] = parseCSV( fileName )
%parseCSV Returns a nice numerical matrix with all the values and a cell
%array with all the headers
%  Note this is customized to expect the last cell to hold an image name
%  and automatically chops off the extension to turn it into an integer

textData = importdata(fileName);
headerText = textData{1};

%Get array of all the header's
[value, remainder] = strtok(headerText, ',');
headerArray = {value};
while length(remainder) > 0
    %fprintf('%s\n', value);
    [value, remainder] = strtok(remainder, ',');
    headerArray{length(headerArray) + 1} = value;
    
end
%fprintf('%s\n', value);

%Get the data
valueArray = zeros(length(textData)-1, length(headerArray));
for i = 2:length(textData); %for each row in the file
    [value, remainder] = strtok(textData{i}, ',');
    valueArray(i-1, 1) = str2num(value);
    for j = 2:length(headerArray)-1 %last one is filename
        %fprintf('%s\n', value);
        [value, remainder] = strtok(remainder, ',');
        valueArray(i-1, j) = str2num(value);

    end %Special case to handle the file name ID at the end
    [value, remainder] = strtok(remainder, ',');
    value = value(1:end-4);
    %fprintf('%s\n', value);
    valueArray(i-1, j+1) = str2num(value);
end

dcmArray = valueArray(:,end);
headerArray = headerArray(:,1:end-1);
valueArray = valueArray(:,1:end-1);

clear textData headerText