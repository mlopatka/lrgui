function boxplot_transformed_data( transformed_data, h_c )
            figure('name','Boxplot transformed data');
            vals    = get(h_c,'Value'); 
            checked = logical([vals{:}]); 
            names   = get(h_c(checked),'String');
            if(size(names,1)==size(transformed_data,2))
                boxplot(transformed_data,'plotstyle','compact','labels',[names{:}])
                grid on
            else
               disp('something went wrong')
            end
end

