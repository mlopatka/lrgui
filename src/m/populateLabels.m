function populateLabels(labelNames,pos_l)
%% This can be put back in the main LR_GUI file later as a seperate function
global h

labelNames=strrep(labelNames, char(34), '');
labelNames=strrep(labelNames, char(39), '');

max_rows = min(22,size(labelNames,1));
numb_of_columns = ceil(size(labelNames,1)/max_rows);

if ~isempty(labelNames)
    for i = 1:numb_of_columns
        for j = 1:max_rows
            label = labelNames{j};
            h.cb_labels(max_rows*(i-1)+j) = uicontrol('style','checkbox','units','normalized',...
                'pos',[0.01+(i-1)*0.98/numb_of_columns,0.99-0.98/max_rows-(j-1)*0.98/max_rows,0.98/numb_of_columns,0.98/max_rows],...
                'string',label(6:end),'parent',h.bg_labels);
        end
    end
else
    h.cb_labels = [];
    delete(h.bg_labels);
    
    h.bg_labels = uibuttongroup('visible','on','Title','Labels','units','normalize','pos',pos_l);
    set(h.t(2),'string','no transformation selected','backgroundcolor',[.8,.3,.3]);
    set(h.t(3),'string','no metric selected','backgroundcolor',[.8,.3,.3]);
    set(h.t(11),'string','...');
end