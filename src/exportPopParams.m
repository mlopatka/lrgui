function [exportLocation, successFlag] =exportPopParams(wrkflw, distribution_same, distribution_diff, labels_active, flag)
global transformed_data feature_data distance_same distance_diff loc parameters_diff parameters_same h

exportLocation = 0; successFlag = 0;
switch flag
    case 'write'
        [fileName, filePath] = uiputfile('../*.mat', 'Please define an output file in which to store your population and workflow parameters', 'population');
        if isnumeric(fileName)
            disp('invalid export location or filename');
        else
            popParams = struct;
            
            popParams.timestamp = datestr(now);
            popParams.serialWorkflow = strtrim(regexp(wrkflw, '>', 'split'));
            temp1 = get(h.popup2, 'String');
            popParams.metric = temp1(get(h.popup2, 'Value'),:);
            
            popParams.sameClass.modelType = distribution_same;
            popParams.differentClass.modelType = distribution_diff;
            
            popParams.featureIndex = h.featInd;
            popParams.featureNames = get(get(h.bg_features, 'Children'), 'String');
            popParams.featureNames = flipud(popParams.featureNames); % corrected error where the names are reversed
            
            popParams.sameClass.params = parameters_same;
            popParams.differentClass.params = parameters_diff;
            
            popParams.labelsUsed = labels_active;
            popParams.labels = loc;
            popParams.data.raw = feature_data;
            popParams.data.mean = mean(transformed_data);
            popParams.data.std = std(transformed_data);
            popParams.data.size = size(transformed_data);
            
            popParams.distances.same = distance_same;
            popParams.distances.diff = distance_diff;
            
            save([filePath,fileName], 'popParams');
            exportLocation = [filePath,fileName];
            
            successFlag = true;
        end
    case 'txt'
        [fileName, filePath] = uiputfile('../*.txt', 'Please define an output file in which to store your population and workflow parameters', 'population');
        if isnumeric(fileName)
            disp('invalid export location or filename');
        else
            fileID = fopen([filePath fileName],'w');
            
            fprintf(fileID,['time stamp                                          : ' datestr(now) '\r\n']);
            fprintf(fileID,['workflow                                            : ' wrkflw '\r\n']);
            temp1 = get(h.popup2, 'String');
            fprintf(fileID,['metric                                              : ' temp1(get(h.popup2, 'Value'),:) '\r\n']);
            fprintf(fileID,['same distribution                                   : ' distribution_same '\r\n']);
            fprintf(fileID,['same distribution parameters                        : ' num2str(parameters_same) '\r\n']);
            fprintf(fileID,['diff distribution                                   : ' distribution_diff '\r\n']);
            fprintf(fileID,['diff distribution parameters                        : ' num2str(parameters_diff) '\r\n']);
            temp2 = get(h.cb_features,'string'); temp2 = [temp2{:}];
            temp3 = find(cell2mat(get(h.cb_features,'value')));  temp2 = temp2(temp3);
            fprintf(fileID,['selected features                                   : ' strjoin(temp2,',') '\r\n' ]);
            if isa(get(h.cb_labels,'string'), 'char')
                temp4 = {get(h.cb_labels,'string')}; 
                temp4 = temp4(find((get(h.cb_labels,'value'))));
            else
                temp4 = get(h.cb_labels,'string')'; 
                temp4 = temp4(find(cell2mat(get(h.cb_labels,'value'))));
            end
            fprintf(fileID,['active labels                                       : ' strjoin(temp4,',') '\r\n' ]);
            fprintf(fileID,['false positive rate                                 : ' get(h.t(10),'string') '\r\n']);
            fprintf(fileID,['false negative rate                                 : ' get(h.t(11),'string') '\r\n']);
            fprintf(fileID,['log likelihood ratio cost                           : ' get(h.t(12),'string') '\r\n']);
            fprintf(fileID,['number of same source comparisons                   : ' num2str(size(distance_same,2)) '\r\n']);
            fprintf(fileID,['number of different source comparisons              : ' num2str(size(distance_diff,2)) '\r\n']);
            
            if isa(get(h.cb_labels,'value'), 'double')
                temp5 = loc(find(cell2mat({get(h.cb_labels,'value')}))); temp5 = cell2mat(temp5);
            else
                temp5 = loc(find(cell2mat(get(h.cb_labels,'value')))); temp5 = cell2mat(temp5);
            end
            
            fprintf(fileID,['number of different batches based on label selection: ' num2str(length(unique(temp5,'rows'))) '\r\n']);
            [~,~,temp6] = unique(temp5,'rows');
            fprintf(fileID,['number of samples per batch                         : ' num2str(histc(temp6,unique(temp6,'rows'))') '\r\n']);

            fclose(fileID);
            
            exportLocation = [filePath,fileName];
            successFlag = true;
        end
    case 'consolidate'
        popParams = struct;
        
        popParams.timestamp = datestr(now);
        popParams.serialWorkflow = strtrim(regexp(wrkflw, '>', 'split'));
        temp_1 = get(h.popup2, 'String');
        popParams.serialWorkflow{end+1} = temp_1(get(h.popup2, 'Value'), :);
        popParams.sameClass.modelType = distribution_same;
        popParams.differentClass.modelType = distribution_diff;
        
        popParams.featureIndex = h.featInd;
        popParams.featureNames = get(get(h.bg_features, 'Children'), 'String');
        
        popParams.sameClass.params = parameters_same;
        popParams.differentClass.params = parameters_diff;
        
        popParams.labels = loc;
        popParams.data.raw = feature_data;
        popParams.data.mean = mean(transformed_data);
        popParams.data.std = std(transformed_data);
        popParams.data.size = size(transformed_data);
        
        popParams.distances.same = distance_same;
        popParams.distances.diff = distance_diff;
        
        exportLocation = popParams;
        
        successFlag = true;
end
end
