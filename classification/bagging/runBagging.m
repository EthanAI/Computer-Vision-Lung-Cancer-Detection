function [ bags ] = runBagging( X,Y,numIterations,minLeafs,rf )
%RUNBAGGING Summary of this function goes here
%   Detailed explanation goes here


    bags = cell(1,1);
    
    options = statset('UseParallel',true);
    
    numPrint = numIterations/10;

    for i=1:size(minLeafs,2)
        disp(strcat('Running leaf parameter: ', num2str(minLeafs(i))));
        if(rf)
            bags{i} = TreeBagger(numIterations,X,Y,'Method',...
            'classification','OOBPred','on','minleaf',minLeafs(i),...
            'NVarToSample','all','NPrint',numPrint,'Options',options);
        else
            bags{i} = TreeBagger(numIterations,X,Y,'Method',...
            'classification','OOBPred','on','minleaf',minLeafs(i),...
            'NPrint',numPrint,'Options',options);
        end
    end

end

