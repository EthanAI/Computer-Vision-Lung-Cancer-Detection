%test same order
%Was used to verify all the labels and features matched after reordering
%things to match the order of the largest slice features extracted by the
%feature extraction modules.
for i = 1:length(IDsToUse)
    agreement(i) =  ismember(IDsToUse(i), instanceOrder(i,:));
end

