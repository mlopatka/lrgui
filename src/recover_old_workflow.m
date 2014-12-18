function success_flag = recover_old_workflow(userData)
global h
checked_features  = userData{1};
checked_labels    = userData{2};
workflow          = userData{3};
metric            = userData{4};
same_distribution = userData{5};
diff_distribution = userData{6};
for i = 1:length(checked_features)
    set(h.cb_features(i),'value',cell2mat(checked_features(i)))
end
for i = 1:length(checked_labels)
    if(iscell(checked_labels))
        set(h.cb_labels(i),'value',cell2mat(checked_labels(i)))
    else
        set(h.cb_labels(i),'value',checked_labels(i))
    end
end
set(h.e1,'string',cell2mat(workflow))
set(h.popup2,'value',cell2mat(metric))
for i = 1:length(same_distribution)
    set(h.rb_samedistribution(i),'value',cell2mat(same_distribution(i)))
    set(h.rb_diffdistribution(i),'value',cell2mat(diff_distribution(i)))
end



