function [transformed_data,distance_same,distance_diff,parameters_same,parameters_diff] =  jacob_feature_selection(h,feature_data,loc)
%% here we set everything we only need to set once
% labels:
set(h.t(16),'string',get(h.t(13),'string'),'userData',get(h.t(13),'userData'));
set(h.t(17),'string',get(h.t(14),'string'));
set(h.t(18),'string',get(h.t(15),'string'));

set(h.t(13),'string',get(h.t(10),'string'),'userData',get(h.t(10),'userData'));
set(h.t(14),'string',get(h.t(11),'string'));
set(h.t(15),'string',get(h.t(12),'string'));
if(isfield(h,'cb_labels'))
    labChecks = get(h.cb_labels, 'Value');
    % we set labChecks in the appropriate format
    if size(labChecks) > 1
        labChecks = [labChecks{:}];
    elseif isa(labChecks, 'cell')
        labChecks = cell2mat(labChecks);
    else
        labChecks = logical(labChecks);
    end
    if sum(labChecks) < 1 % check if labels have been selected
        set(h.t(3),'backgroundcolor',[.8,.3,.3],'string','no labels selected');
    else % if selected, we release the metric!
        set(h.cb_labels(labChecks==1),'backgroundcolor',[.7,.9,.7],'fontweight','b');
    end
else % there are no labels
    set(h.t(3),'backgroundcolor',[.8,.3,.3],'string','there are no labels');
end

% distribution_same and diff
vals = get(h.rb_samedistribution,'Value');
checked = logical([vals{:}]);
distribution_same = get(h.rb_samedistribution(checked),'String');
vals = get(h.rb_diffdistribution,'Value');
checked = logical([vals{:}]);
distribution_diff = get(h.rb_diffdistribution(checked),'String');

%% the actual program
%set(h.cb_plots,'value',0)
changes_0 = 1;
changes_1 = 1;
type = '0';
runs = 0;
max_runs = 20;
while((changes_1==1||changes_0==1)&&runs<max_runs)
    runs = runs + 1;
    switch type
        % in this setting we try to increase our performance by using less features.
        case '0'
            %we set the value of changes to 0, if nothing changes, the program stops.
            changes_0 = 0;
            %we make a random vector giving the order in which we will try to increase our performance.
            [~,j] = sort(rand(1,size(h.cb_features,2)));
            for i = 1:size(h.cb_features,2)
                %we check if the feature is currently used
                if(get(h.cb_features(j(i)),'value')==1&&std(feature_data(:,j(i)))~=0&&strcmp(get(h.p11,'string'),'Cancel')&&(sum(cell2mat(get(h.cb_features,'value')))>1))
                    % we set the checkbox of this feature to `do not include' and select the new set of features
                    set(h.cb_features(j(i)),'Value',0);
                    [checked_data] = check_features_call(h.cb_features,h.t,feature_data);
                    drawnow
                    
                    % transform the data
                    [transformed_data,~,~]= transform_data_call(checked_data,get(h.e1,'String'));
                    
                    % compute the distances and set same and diff vectors.
                    [distance_same, distance_diff, ~, ~] = metric_call(logical(labChecks),{get(h.popup2,'string'),get(h.popup2,'value')},transformed_data, loc, h.rb_samedistribution, h.rb_diffdistribution);
                    
                    %CHECK THE CHOICE OF N = 1000!!
                    
                    if((strcmp(distribution_same,'KDE'))||(strcmp(distribution_diff,'KDE')))
                        [distance_same, distance_diff] = trim_data_for_kde(distance_same, distance_diff, h.rb_samedistribution, h.rb_diffdistribution);
                        
                        tot_dat_temp = [distance_same(:);distance_diff(:)];
                        b_centers = calcBins(tot_dat_temp);
                        %need bins that accomodate all data same and diff distances.
                        [~,~] = hist(distance_same, b_centers);
                        [~,~] = hist(distance_diff, b_centers);
                        [~, b_t] = hist(tot_dat_temp, (numel(b_centers)*10));
                        
                                                if strcmpi(distribution_same,'kde')
                            if get(h.cb_kde_samesource, 'Value') == 1
                                bandwidth_same = str2double(get(h.e2, 'String'));
                            else
                                bandwidth_same = double.empty;
                            end
                        else
                            bandwidth_same = [];
                        end
                        
                        if strcmpi(distribution_diff,'kde')
                            if get(h.cb_kde_diffsource, 'Value') == 1
                                bandwidth_diff = str2double(get(h.e3, 'String'));
                            else
                                bandwidth_diff = double.empty;
                            end
                        else
                            bandwidth_diff = double.empty;
                        end
                        
                        [~, parameters_same] = fit_distrib_to_data(distance_same,b_t,distribution_same,bandwidth_same);
                        [~, parameters_diff] = fit_distrib_to_data(distance_diff,b_t,distribution_diff,bandwidth_diff);
                    else
                        [~, parameters_same] = fit_distrib_to_data(distance_same,1000,distribution_same);
                        [~, parameters_diff] = fit_distrib_to_data(distance_diff,1000,distribution_diff);
                    end
                    [confusion_matrix, cllr] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution,1);
                    
                    pfp = confusion_matrix(2,1)/(confusion_matrix(2,1)+confusion_matrix(2,2));
                    pfn = confusion_matrix(1,2)/(confusion_matrix(1,1)+confusion_matrix(1,2));
                    
                    % check if the performance of the new method it better
                    
                    if(str2double(get(h.t(12),'string'))>cllr)
                        set(h.t(10),'string',num2str(pfp));
                        set(h.t(11),'string',num2str(pfn));
                        set(h.t(12),'string',num2str(cllr));
                        changes_0 = 1;
                    else
                        set(h.cb_features(j(i)),'Value',~get(h.cb_features(j(i)),'Value'))
                    end
                end
            end
            type = '1';
            % in this setting we try to increase our performance by using more features.
        case '1'
            %we set the value of changes to 0, if nothing changes, the program stops.
            changes_1 = 0;
            %we make a random vector giving the order in which we will try to increase our performance.
            [~,j] = sort(rand(1,size(h.cb_features,2)));
            for i = 1:size(h.cb_features,2)
                %we check if the feature is currently used
                if(get(h.cb_features(j(i)),'value')==0&&std(feature_data(:,j(i)))~=0&&strcmp(get(h.p11,'string'),'Cancel'))
                    %we set the checkbox of this feature to `do not include' and select the new set of features
                    set(h.cb_features(j(i)),'Value',1)
                    [checked_data] = check_features_call(h.cb_features,h.t,feature_data);
                    drawnow
                    
                    %transform the data
                    [transformed_data,~,~]= transform_data_call(checked_data, get(h.e1,'String'));
                    
                    % compute the distances and set same and diff vectors.
                    [distance_same, distance_diff, ~, ~] = metric_call(logical(labChecks),{get(h.popup2,'string'),get(h.popup2,'value')},transformed_data, loc, h.rb_samedistribution, h.rb_diffdistribution);
                    
                    %CHECK THE CHOICE OF N = 1000!!
                    if((strcmp(distribution_same,'KDE'))||(strcmp(distribution_diff,'KDE')))
                        [distance_same, distance_diff] = trim_data_for_kde(distance_same, distance_diff, h.rb_samedistribution, h.rb_diffdistribution);
                        
                        tot_dat_temp = [distance_same(:);distance_diff(:)];
                        b_centers = calcBins(tot_dat_temp);
                        %need bins that accomodate all data same and diff distances.
                        [~,~] = hist(distance_same, b_centers);
                        [~,~] = hist(distance_diff, b_centers);
                        [~, b_t] = hist(tot_dat_temp, (numel(b_centers)*10));
                        
                        if strcmpi(distribution_same,'kde')
                            if get(h.cb_kde_samesource, 'Value') == 1
                                bandwidth_same = str2double(get(h.e2, 'String'));
                            else
                                bandwidth_same = double.empty;
                            end
                        else
                            bandwidth_same = [];
                        end
                        
                        if strcmpi(distribution_diff,'kde')
                            if get(h.cb_kde_diffsource, 'Value') == 1
                                bandwidth_diff = str2double(get(h.e3, 'String'));
                            else
                                bandwidth_diff = double.empty;
                            end
                        else
                            bandwidth_diff = double.empty;
                        end
                        
                        [~, parameters_same] = fit_distrib_to_data(distance_same,b_t,distribution_same,bandwidth_same);
                        [~, parameters_diff] = fit_distrib_to_data(distance_diff,b_t,distribution_diff,bandwidth_diff);
                    else
                        [~, parameters_same] = fit_distrib_to_data(distance_same,1000,distribution_same);
                        [~, parameters_diff] = fit_distrib_to_data(distance_diff,1000,distribution_diff);
                    end
                    [confusion_matrix, cllr] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, 1);
                    
                    pfp = confusion_matrix(2,1)/(confusion_matrix(2,1)+confusion_matrix(2,2));
                    pfn = confusion_matrix(1,2)/(confusion_matrix(1,1)+confusion_matrix(1,2));
                    
                    % check the performance of the new method is better
                    
                    if(str2double(get(h.t(12),'string'))>cllr)
                        set(h.t(10),'string',num2str(pfp));
                        set(h.t(11),'string',num2str(pfn));
                        set(h.t(12),'string',num2str(cllr));
                        changes_1 = 1;
                    else
                        set(h.cb_features(j(i)),'Value',~get(h.cb_features(j(i)),'Value'))
                    end
                end
            end
            type = '0';
    end
end
set(h.t(10),'userData',{get(h.cb_features,'value'),get(h.cb_labels,'value'),{get(h.e1,'string')},{get(h.popup2,'value')},get(h.rb_samedistribution,'Value'),get(h.rb_diffdistribution,'Value')})
if(~isempty(get(h.t(13),'userData')))
    set(h.t(13),'enable','on')
end
if(~isempty(get(h.t(16),'userData')))
    set(h.t(16),'enable','on')
end
end