function graphBags( bags, leafs, figureName )
%GRAPHBAGS Summary of this function goes here
%   Detailed explanation goes here


    labels = num2cell(leafs);
    labels = cellfun(@num2str,labels,'UniformOutput',0);

    col = 'rgbcmy';
    figure('name',figureName); 
    
    for i=1:size(bags,2)
        plot(oobError(bags{i}),col(i));
        hold on;
    end

    xlabel('number of grown trees');
    ylabel('out-of-bag classification error');
    legend(labels,'Location','NorthEast');
    hold off;

end

