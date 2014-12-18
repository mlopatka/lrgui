function martinFeatureSelection2(feature_data,loc)

global distance_same distance_diff h

temp = get(h.cb_labels, 'Value');
if isa(temp,'double')
    y = loc{logical([temp(:)]')}(1:size(feature_data,1)); 
elseif isa(temp, 'cell')
    y = loc{logical([temp{:}]')}(1:size(feature_data,1));
    %labels defined
else
   disp('something has gone teribly awry');     
end
x = feature_data;

feats_ind = TreeRegressMethod(x,y);

for i = 1:numel(feats_ind)
    set(h.cb_features(i), 'Value', double(feats_ind(i)));
end

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
%fit_figure_call(h.t,h.rb_samedistribution,h.rb_diffdistribution,h.ax1,distance_diff,distance_same,h.cb_plots);


disp('feature selection by random forest completed.');
end