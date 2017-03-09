function [checked_data] = check_features_call(h_c,h_t,feature_data)
global h
vals = get(h_c,'Value');
checked = find([vals{:}]);
if(isempty(checked))
    set(h_t(1),'backgroundcolor',[.8,.3,.3],'string','no features selected');
    checked_data = [];
else
    set(h_t(1),'backgroundcolor',[.7,.9,.7],'string','features selected');
    checked_data = feature_data(:,checked);
    h.featInd = logical([vals{:}]);
    set(h_c(:),'BackgroundColor','default','fontweight','n')
    set(h_c(checked),'fontweight','b','backgroundColor',[.7,.9,.7])
end
end