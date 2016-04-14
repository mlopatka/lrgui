function export_scores_call(distance_same,distance_diff)
[fileName, filePath] = uiputfile('../*.csv', 'Please define an output file in which to save the different and same source scores', 'scores');
if isnumeric(fileName)
    disp('invalid export location or filename');
else
    fid = fopen([filePath,fileName], 'w');
    fprintf(fid, '_lab_source, score \n');
    fclose(fid);
    
    score_data = [zeros(size(distance_same))',distance_same';ones(size(distance_diff))',distance_diff'];

    dlmwrite([filePath,fileName], score_data, '-append', 'precision', '%.6f', 'delimiter', '\t');
end
end