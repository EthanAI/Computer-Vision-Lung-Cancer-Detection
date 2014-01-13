std4 = zeros(1,7);
increment = 0;
for i = 5676:increment+1:6515
    firstRow = i;
    lastRow = i+increment;
    std4 = vertcat(std4, std(Yraw(firstRow:lastRow,:)) );
end
std4 = std4(2:end,:);
mean(std4);