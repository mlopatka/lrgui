function post_params_to_gui(h, parameters_same, parameters_diff, num_distance_diff, num_distance_same, num_samples, location_information)

        
    line = {};
    vals = get(h.rb_samedistribution,'Value'); 
    checked = find([vals{:}]);
    line{1} = ['Distribution Same: ', get(h.rb_samedistribution(checked),'String')];
    if strcmpi( get(h.rb_samedistribution(checked),'String'), 'gamma')
        line{2} = ['a: ', num2str(parameters_same(1))]; 
        line{3} = ['b: ', num2str(parameters_same(2))];
    elseif strcmpi( get(h.rb_samedistribution(checked),'String'), 'lognormal')
        line{2} = ['mu:    ', num2str(parameters_same(1))];
        line{3} = ['sigma: ', num2str(parameters_same(2))];
    elseif strcmpi( get(h.rb_samedistribution(checked),'String'), 'weibull')
        line{2} = ['scale: ', num2str(parameters_same(1))]; 
        line{3} = ['shape: ', num2str(parameters_same(2))];
    elseif strcmpi( get(h.rb_samedistribution(checked),'String'), 'normal')
        line{2} = ['mu:    ', num2str(parameters_same(1))]; 
        line{3} = ['sigma: ', num2str(parameters_same(2))];
    elseif strcmpi( get(h.rb_samedistribution(checked),'String'), 'kde')
        line{2} = ['bandwidth: ', num2str(parameters_same(1))];
    end
    vals = get(h.rb_diffdistribution,'Value'); 
    checked = find([vals{:}]);
    
    line{4} = '';
    line{5} =  ['Distribution Diff: ', get(h.rb_diffdistribution(checked),'String')];
    
    if strcmpi( get(h.rb_diffdistribution(checked),'String'), 'gamma')
        line{6} = ['a: ', num2str(parameters_diff(1))]; 
        line{7} = ['b: ', num2str(parameters_diff(2))];
    elseif strcmpi( get(h.rb_diffdistribution(checked),'String'), 'lognormal')
        line{6} = ['mu:    ', num2str(parameters_diff(1))];
        line{7} = ['sigma: ', num2str(parameters_diff(2))];
    elseif strcmpi( get(h.rb_diffdistribution(checked),'String'), 'weibull')
        line{6} = ['scale: ', num2str(parameters_diff(1))]; 
        line{7} = ['shape: ', num2str(parameters_diff(2))];
    elseif strcmpi( get(h.rb_diffdistribution(checked),'String'), 'normal')
        line{6} = ['mu:    ', num2str(parameters_diff(1))]; 
        line{7} = ['sigma: ', num2str(parameters_diff(2))];
    elseif strcmpi( get(h.rb_diffdistribution(checked),'String'), 'kde')
        line{6} = ['bandwidth: ', num2str(parameters_diff(1))];
    end
    line{8} = ' ';
    line{9} = 'Data pre processing: ';
    line{10} = get(h.e1,'String');
    line{11} = ' ';
    vals = get(h.popup2, 'String');
    line{12} = ['Similarity Metric: ', vals(get(h.popup2, 'Value'),:)];
    line{13} = ['CLLR: ', get(h.t(12), 'String')];
    line{14} = ' ';
    line{15} = ['number of same source comparisons: ' num2str(num_distance_same)];
    line{16} = ['number of different source comparison :' num2str(num_distance_diff)];
    line{17} = ' ';
    line{18} = ['based on ' num2str(num_samples) ' samples'];
    line{19} = ' ';
    if ~strcmpi(get(h.t(21),'string'),'scores loaded')
        location_information = cell2mat(location_information);
    else
        location_information = 0;
    end
    
    line{20} = ['number of different batches based on label selection: ' num2str(length(unique(location_information,'rows')))];
    %labels_active = cell2mat(get(h.c_labels, 'Value'));
    %[exportLocaion, successFlag] = exportPopParams(wrkflw, distribution_same,distribution_diff,labels_active, 'write');
    
    set (h.t(20), 'String', line); 
end