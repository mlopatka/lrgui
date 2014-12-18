function martinFeatureSelection1(feature_data,loc)
global distance_same distance_diff h
killInd = (std(feature_data)==0);
[loadings, ~, explained] = pcacov(feature_data(:,~killInd));
killInd2 = find(cumsum(explained)>90, 1, 'first');

properLoadings = loadings(:,[1:killInd2]);
findInd = prctile(reshape(abs(properLoadings), [numel(properLoadings),1]), 75);
feats_ind = sum(properLoadings>=findInd,2)>0;
%x = unique(x);

%potentials = loadings(cumsum(explained)<90,:); %these are the loadings for the PC's that are actually doig something useful.
%usefullBounds = prctile(potentials(:), [30,70]); %isolate the 30th and 70th percentile as bounds for how big a loading should be to deem mthis feature worthy

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

disp 'pca based feature selection performed.'