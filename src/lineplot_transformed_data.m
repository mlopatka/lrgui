function lineplot_transformed_data( transformed_data, h_c, labels, h_c_labels )
   
    figure('name','lineplot transformed data');
            vals = get(h_c,'Value');
            checked=logical([vals{:}]);
            names = get(h_c(checked),'String');
            temp_checked_labs = get(h_c_labels, 'Value');
            if ~isa(temp_checked_labs, 'cell')
                temp_checked_labs = {temp_checked_labs};
            end
            labChecks = sum(logical(cell2mat(temp_checked_labs)));
            if  size(labels,2) > 1
                if sum(labChecks)>=1
                    temp = ([strtrim(num2str(labels{1})), strtrim(num2str(labels{2}))]);
                    temp(isspace(temp))='1';
                    labels = str2num(temp);
                else
                    labels = [labels{:,labChecks}];
                    labels = [labels{:}];
                end
    
            end
            
            if isa(labels, 'cell');
                labels = [labels{:}];
            end
            labs = unique(labels);
            c = lines;
            
            if size(c,1) < numel(labs)
                c = repmat(c, [ceil(numel(labs)/size(c,1)), 1]);
            end
            
            if(size(names,1)==size(transformed_data,2))
                for i = 1:numel(labs)
                   hold on;
                   plot([1:size(transformed_data,2)],transformed_data(labels==labs(i), :), 'color', c(i,:));
                end
            else
               disp('something went wrong') 
            end
            grid on
            set(gca,'XTick',[1:size(transformed_data,2)]);
            set(gca,'XTickLabel',[names{:}]);
            rotateXLabels(gca, 90);
            hold off;         
end