function createLabels(baseLabels,unwantedValues,numSegs,fid1,segType)
%CREATELABELS makes a set of labels for a text file
%   Takes a file descriptor, a segmentationType, and a set of baseLabels to
%   create the first line of headers

    %size of base labels
    baseSize = size(baseLabels,2);

    %generate labels 
    for i=1:numSegs     
        
        for j=1:baseSize
            fn = baseLabels{j};
            if (~ismember(fn,unwantedValues))
                newLabel = strcat(fn,segType,num2str(i));
                fprintf(fid1,'%s,',newLabel);
            end
        end    
    end

    %insert newline
    fprintf(fid1,'%s\n', 'ImageName');

end

