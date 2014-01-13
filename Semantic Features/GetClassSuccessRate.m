function [ classSuccessRate ] = GetClassSuccessRate( classValue, label )
%GetClassSuccessRate Convert decimals to (integer) classes, get % matching
%the label matrix

classSuccessRate = sum(round(classValue) == round(label))/size(label,1);

end

