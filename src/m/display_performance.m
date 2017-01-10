function success_flag = display_performance(confusion_matrix, cllr, h_t)
global h
% called from gui when making a new plot
if(sum([get(h.t(13),'value'),get(h.t(16),'value')])==0)
    set(h_t(16),'string',get(h_t(13),'string'),'userData',get(h_t(13),'userData'));
    set(h_t(17),'string',get(h_t(14),'string'));
    set(h_t(18),'string',get(h_t(15),'string'));


    set(h_t(13),'string',get(h_t(10),'string'),'userData',get(h_t(10),'userData'));
    set(h_t(14),'string',get(h_t(11),'string'));
    set(h_t(15),'string',get(h_t(12),'string'));

    set(h_t(10),'string',num2str(confusion_matrix(2,1)/(confusion_matrix(2,1)+confusion_matrix(2,2))))% false positive
    set(h_t(11),'string',num2str(confusion_matrix(1,2)/(confusion_matrix(1,1)+confusion_matrix(1,2))))% false negative
    set(h_t(12),'string',num2str(cllr))% is passed in in cllr
    
    if ~strcmpi(get(h.t(21),'string'),'scores loaded')
        set(h.t(10),'userData',{get(h.cb_features,'value'),get(h.cb_labels,'value'),{get(h.e1,'string')},{get(h.popup2,'value')},get(h.rb_samedistribution,'Value'),get(h.rb_diffdistribution,'Value')})
    else
        set(h.t(10),'userData', {'User provided scores utilized',{get(h.popup2,'value')},get(h.rb_samedistribution,'Value'),get(h.rb_diffdistribution,'Value')})
    end
        
    if(~isempty(get(h.t(13),'userData')))
        set(h.t(13),'enable','on')
    end
    if(~isempty(get(h.t(16),'userData')))
        set(h.t(16),'enable','on')
    end
else %called from restoring old workflows
    button_pressed = sum([get(h.t(10),'value'),get(h.t(13),'value'),get(h.t(16),'value')].*[10,13,16]);
    tempData = get(h.t(10),'userData');
    temp_performance = {get(h.t(10),'string'),get(h.t(11),'string'),get(h.t(12),'string')};
    set(h.t(10),'userData',get(h.t(button_pressed),'userData'),'string',get(h.t(button_pressed),'string'));
    set(h.t(10+1),'string',get(h.t(button_pressed+1),'string'));
    set(h.t(10+2),'string',get(h.t(button_pressed+2),'string'));
    set(h.t(button_pressed),'userData',tempData,'string',temp_performance{1})
    set(h.t(button_pressed+1),'string',temp_performance{2})
    set(h.t(button_pressed+2),'string',temp_performance{3})
end
