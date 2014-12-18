function cell2csv(fileName, cellArray, separator)

%% Write file
datei = fopen(fileName, 'w');

for z=1:size(cellArray, 1)
    if z == 1 
        row1 = ['"',cellArray{z,1},'"',separator,'"',cellArray{z,2},'"',separator,'"',cellArray{z,3}, '"',separator,'"',cellArray{z,4},'"'];
    else
        row1 = ['"',cellArray{z,1},'"',separator,'"',cellArray{z,2},'"',separator,'"',num2str(cellArray{z,3}), '"',separator,'"',num2str(cellArray{z,4}),'"'];
    end
    
    fprintf(datei, '%s%s%s%s', row1);
    fprintf(datei, '\n');
end
% Closing file
fclose(datei);
% END