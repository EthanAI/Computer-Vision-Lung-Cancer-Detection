%saveResults 
%Saves your favorite data to an excel file. Was useful when trying
%different settings to find trends on the optimum value.

%Save raw results to excel
excelName = 'results.xlsx';
%delete old file
if exist(excelName)
    delete(excelName);
end

%Form matrix
rowLabels = [randErrorHeaders; rtErrorHeaders; wsErrorHeaders; {''};randErrorHeaders; rtErrorHeaders; wsErrorHeaders];
allErrors = [randRegError; rtRegError; wsRegError; zeros(1,size(rtRegError),2);randClassSuccess;rtClassSuccess;wsClassSuccess];

%write new data
%rowLabels = {'DT 1 to 1';'DT Largest Area';'DT Mean';'Bag 1 to 1';'Bag Largest Area';'Bag Mean';'NN RMS (%%)'};
%xlswrite(excelName, categories);
%xlswrite(excelName, [clError; bagError; nnError]);

xlswrite(excelName,categories,'Sheet1','B1'); %Write column header
xlswrite(excelName,rowLabels,'Sheet1','A2'); %Write row header
xlswrite(excelName,allErrors,'Sheet1','B2'); %Write data

%clear excelName temp rowLabels allErrors