function saveValidationResults(dCell)
[FileName,PathName] = uiputfile({'*.csv'},'Select location to save LR values form validation set...', 'validation');
if isnumeric(FileName)
    disp('invlaid export location or filename')
else
    dCell_with_header_row = [{'sample 1','sample 2','distance','likelihood ratio'};dCell];
    
    for i  = 1:size(dCell_with_header_row,2)
       for j = 1:size(dCell_with_header_row,1)
           if isa(dCell_with_header_row{j,i}, 'char')
                dCell_with_header_row{j,i} = strrep(dCell_with_header_row{j,i},'"','');
                dCell_with_header_row{j,i} = strrep(dCell_with_header_row{j,i},'''','');
           end
       end
    end
    
    lang = get(0, 'Language'); %get system language
    
    if strfind(lang, 'en')
        cell2csv([PathName,FileName], dCell_with_header_row, ',');
    elseif strfind(lang, 'nl')
        cell2csv([PathName,FileName], dCell_with_header_row, ';');
    else
        disp('warning system can not determine appropriate spreadsheet delimiter, using decimal notation!');
        cell2csv([PathName,FileName], dCell_with_header_row, ';');
    end
end

fclose all


