%% mean distances per feature
function feature_selection_distance_discrimination_per_feature(h,loc,labChecks, checked_data,perc_tile)
global distance_same distance_diff feature_data
mean_ratio = zeros(size(checked_data,2),1);

%% determine which locations are considered to be 'the same' under the selected labels
loc2 = zeros(1,length(pdist(loc{1},'cityblock')));
for i = 1:length(labChecks)
    if(labChecks(i)>0)
        loc2 = loc2 + pdist(loc{i},'cityblock');
    end
end

for i = 1:size(checked_data,2)
    if(std(checked_data(:,i))~=0)
        distt = pdist(checked_data(:,i));
        mean_ratio(i) = mean(distt(loc2~=0))./mean(distt(loc2==0));
    else
        mean_ratio(i) = 0;
    end
end

old_vals = get(h.cb_features,'value');
new_vals = zeros(size(h.cb_features,2),1);
update_vals = (mean_ratio>=prctile(mean_ratio,perc_tile));
t2 = 1;
for i = 1:size(h.cb_features,2)
    if(old_vals{i}==1)
        new_vals(i) = update_vals(t2);
        t2 = t2+1;
    else
        new_vals(i) = 0;
    end
end

set(h.cb_features(:),'value',0','backgroundcolor','default');
set(h.cb_features(logical(new_vals)),'value',1','backgroundcolor',[.7,.9,.7]);

checked_data = check_features_call(h.cb_features,h.t,feature_data);
[transformed_data, exitFlag]= transform_data_call(checked_data,get(h.e1,'String'));
 if exitFlag
     set(h.t(2),'backgroundcolor',[.7,.9,.7],'string','transformation complete');
 end                   %else
 t =get(h.cb_labels, 'Value');
 if ~isa(t, 'double')
     t = [t{:}];
 end
[distance_same, distance_diff, exitFlag] = metric_call(t,{get(h.popup2,'string'),get(h.popup2,'value')}, transformed_data, loc, h.rb_samedistribution, h.rb_diffdistribution);
                               %            metric_call(labChecks,metric_information, transformed_data, loc, h_rb_samedistribution, h_rb_diffdistribution)

if exitFlag
    clear t; set(h.t(3),'backgroundcolor',[.7,.9,.7],'string','distances computed');
end
