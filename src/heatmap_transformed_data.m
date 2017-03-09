function heatmap_transformed_data( transformed_data, h_c )
    figure('name','Heatmap transformed data');
       vals = get(h_c,'Value');
        checked=logical([vals{:}]);
        names = get(h_c(checked),'String');
 
        if(size(names,1)==size(transformed_data,2))
            imagesc(transformed_data);
        else
           disp('someting went wrong') 
        end
        %set(gca,'YTick',[1:20:size(transformed_data,1)]);
        set(gca,'XTick',[1:size(transformed_data,2)]);
        set(gca,'XTickLabel',[names{:}]);
        %rotateXLabelsIMGSC(gca, -70);        
        
        hold off;         
end