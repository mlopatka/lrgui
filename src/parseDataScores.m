function [data, labels, labelNames, featureNames] = parseDataScores(path2DataFile)

LAB_STRING = '_lab_'; %hardcode the label header indicator string

% error handling
if ~exist(path2DataFile, 'file')
    disp('Warning! The data file path is incorrect, please provide a valid data source.');
    [fileName,path2DataFile] = uigetfile({'*.mat;*.xls;*.csv;*.dat;*.txt'},'Select Data File');
    path2DataFile = [path2DataFile,fileName]; 
    clear fileName;
end

s2 = regexp(path2DataFile, '\.', 'split');
filetype = s2{end}; clear s2;    

switch filetype
    case 'xls'
        disp 'Microsoft Excel format detected...'
        error('format not yet accepted for new label convention!');    
    case 'csv'
        disp 'Delimited text format detected...'
        delimiter = ',';
        startRow = 2;
        endRow = inf;
       
        fileID = fopen(path2DataFile,'r');
        Row1 = fgetl(fileID);  
        Row1 = regexp(Row1, delimiter, 'split');
        
        anyText = ~cellfun(@isempty, Row1);
        labText = strfind(Row1, '_lab_');
        labText = ~cellfun(@isempty, labText);
        
        labelNames = {Row1{and(anyText, labText)}}';
        featureNames = {Row1{and(anyText, ~labText)}}';
        fclose(fileID);
        
        formatSpec = '';
        for jk = 1:numel(labelNames)
            formatSpec = [formatSpec, '%s'];
        end
        for jk = 1:numel(featureNames)
            formatSpec = [formatSpec, '%f'];
        end
        formatSpec = [formatSpec, '%[^\n\r]'];
        %dynamic columns numbers based on delimeter count.
        
        %% Read columns of data according to format string.
        fileID = fopen(path2DataFile,'r');
        
        dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);

        %% Close the text file.
        fclose(fileID);
        labels = dataArray(:,labText);
        labels = [labels{:}];
        data = dataArray(:,and(anyText, ~labText));
        data = [data{:}];
        
    case 'dat'
        error('format not yet supported');
    case 'txt'
        error('format not yet supported');
        
end

end
