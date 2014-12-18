function populateFeatures(s_features,pos_f)
%% This can be put back in the main LR_GUI file later as a seperate function
global h

s_features=strrep(s_features, char(34), ''); %regexp to clean up all the delimiters used in some text formats.
s_features=strrep(s_features, char(39), '');

max_rows=30; %this is the maximum number of rows we allow for aesthetic reasons.
numb_of_columns = ceil(length(s_features)/max_rows); %make sure it fits nicely in our parent button group

if ~isempty(s_features)
    if(size(s_features,1)>500)
        for i = 1:numb_of_columns
            if(i<numb_of_columns)
                for j = 1:max_rows
                    h.cb_features(max_rows*(i-1)+j) = uicontrol('style','checkbox','units','normalized',...
                        'pos',[0.01+(i-1)*0.98/numb_of_columns,0.99-0.98/max_rows-(j-1)*0.98/max_rows,0.98/numb_of_columns,0.98/max_rows],...
                        'string',s_features(max_rows*(i-1)+j),'parent',h.bg_features,'visible','off');
                end
            else
                for j = 1:(length(s_features)-(numb_of_columns-1)*max_rows)
                    h.cb_features(max_rows*(i-1)+j) = uicontrol('style','checkbox','units','normalized',...
                        'pos',[0.01+(i-1)*0.98/numb_of_columns,0.99-0.98/max_rows-(j-1)*0.98/max_rows,0.98/numb_of_columns,0.98/max_rows],...
                        'string',s_features(max_rows*(i-1)+j),'parent',h.bg_features,'visible','off');
                end
                
            end
        end
    else
        for i = 1:numb_of_columns
            if(i<numb_of_columns)
                for j = 1:max_rows
                    h.cb_features(max_rows*(i-1)+j) = uicontrol('style','checkbox','units','normalized',...
                        'pos',[0.01+(i-1)*0.98/numb_of_columns,0.99-0.98/max_rows-(j-1)*0.98/max_rows,0.98/numb_of_columns,0.98/max_rows],...
                        'string',s_features(max_rows*(i-1)+j),'parent',h.bg_features);
                end
            else
                for j = 1:(length(s_features)-(numb_of_columns-1)*max_rows)
                    h.cb_features(max_rows*(i-1)+j) = uicontrol('style','checkbox','units','normalized',...
                        'pos',[0.01+(i-1)*0.98/numb_of_columns,0.99-0.98/max_rows-(j-1)*0.98/max_rows,0.98/numb_of_columns,0.98/max_rows],...
                        'string',s_features(max_rows*(i-1)+j),'parent',h.bg_features);
                end
                
            end
        end
    end
else % this condition is for clearing the feature space
    h.cb_features = [];
    delete(h.bg_features);
    h.bg_features = uibuttongroup('visible','on','Title','Features','units','normalize','pos',pos_f);
    set(h.t(1),'backgroundcolor',[.8,.3,.3]);
    set(h.t(1),'string','no features selected');
end
