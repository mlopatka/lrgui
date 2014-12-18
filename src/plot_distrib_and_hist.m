function [sucess_flag] = plot_distrib_and_hist

global h;
global distance_diff parameters_diff;
global distance_same parameters_same;
global pdf_out_same pdf_out_diff;

% what_to_display: must be a 1x4 binary vector
handle_axis1    = h.ax1;
what_to_display = logical(cell2mat(get(h.cb_plots, 'Value'))); %what are we plotting?

[distance_same, distance_diff] = trim_data_for_kde(distance_same, distance_diff, h.rb_samedistribution, h.rb_diffdistribution);
% throw away data if KDE is used at any point.

n = 1000; % default bin size

cla(handle_axis1);
hold on;

t = sum(what_to_display);
% we set green backgroundcolors to the used distributions
set(h.rb_samedistribution(:),'backgroundcolor','default','fontweight','n');
set(h.rb_samedistribution(logical(cell2mat(get(h.rb_samedistribution, 'Value')))),'backgroundcolor',[.7,.9,.7],'fontweight','b');
set(h.rb_diffdistribution(:),'backgroundcolor','default','fontweight','n');
set(h.rb_diffdistribution(logical(cell2mat(get(h.rb_diffdistribution, 'Value')))),'backgroundcolor',[.7,.9,.7],'fontweight','b');


sameName = get(h.rb_samedistribution, 'String');% the index of distribution for same batch
sameName = sameName{find(cell2mat(get(h.rb_samedistribution, 'Value')))};% the string value of distribution for same match, gotta love dynamic typing
difName = get(h.rb_diffdistribution, 'String');% the index of distribution for different batch
difName = difName{find(cell2mat(get(h.rb_diffdistribution, 'Value')))};% the string value of distribution for same match, gotta love dynamic typing

switch t
    case 4
        %four boxes checked
        tot_dat_temp = [distance_same(:);distance_diff(:)];
        b_centers = calcBins(tot_dat_temp);
        %need bins that accomodate all data same and diff distances.
        [f_s_1,~] = hist(distance_same, b_centers);
        [f_d_1,x1] = hist(distance_diff, b_centers);
        [~, b_t] = hist(tot_dat_temp, (numel(b_centers)*10));
        
        [pdf_out_same, parameters_same] = fit_distrib_to_data(distance_same, b_t, sameName);
        [pdf_out_diff, parameters_diff] = fit_distrib_to_data(distance_diff, b_t, difName);
        bar(x1,f_s_1/trapz(x1,f_s_1),'FaceColor','r');
        bar(x1,f_d_1/trapz(x1,f_d_1),'FaceColor','b');
        plot(linspace(x1(1), x1(end), numel(pdf_out_diff)/10),pdf_out_diff(round(linspace(1,numel(pdf_out_diff), numel(pdf_out_diff)/10))),'color',[0.4219 0.6286 1],'linewidth',2);
        plot(linspace(x1(1), x1(end), numel(pdf_out_same)/10),pdf_out_same(round(linspace(1,numel(pdf_out_same), numel(pdf_out_same)/10))),'color',[1 .5 .5],'linewidth',2);
        
    case 3
        % three boxes checked
        tot_dat_temp = [distance_same(:);distance_diff(:)];
        b_centers = calcBins(tot_dat_temp);
        %need bins that accomodate all data same and diff distances.
        [f_s_1,x1] = hist(distance_same, b_centers);
        [f_d_1,x1] = hist(distance_diff, b_centers);
        [~, b_t] = hist([0;tot_dat_temp], (numel(b_centers)*10));
        if(what_to_display(1)) % histogram same
            bar(x1,f_s_1/trapz(x1,f_s_1),'FaceColor','r');
        end
        
        if(what_to_display(3)) % histogram different
            bar(x1,f_d_1/trapz(x1,f_d_1),'FaceColor','b');
        end
        
        if(what_to_display(2)) % distribution same
            [~, b_t] = hist([0;tot_dat_temp], (numel(b_centers)*10));
            [pdf_out_same, parameters_same] = fit_distrib_to_data(distance_same, b_t, sameName);
            plot(linspace(x1(1), x1(end), n),pdf_out_same(round(linspace(1,numel(pdf_out_same), n))),'color',[1 .5 .5],'linewidth',2);
        end
        
        if(what_to_display(4)) % distribution different
            [~, b_t] = hist([0;tot_dat_temp], (numel(b_centers)*10));
            [pdf_out_diff, parameters_diff] = fit_distrib_to_data(distance_diff, b_t, difName);
            plot(linspace(x1(1), x1(end), n),pdf_out_diff(round(linspace(1,numel(pdf_out_diff), n))),'color',[0.4219 0.6286 1],'linewidth',2);
        end
        
    case 2
        % two boxes checked
        if(what_to_display(1) || what_to_display(2)) && ~(what_to_display(3) || what_to_display(4))
            % we dont need to look at the different distances
            b_centers = calcBins(distance_same);
            [f_s_1,x1] = hist(distance_same, b_centers);
            bar(x1,f_s_1/trapz(x1,f_s_1),'FaceColor','r');
            [pdf_out_same, parameters_same] = fit_distrib_to_data(distance_same, linspace(b_centers(1),b_centers(end),1000), sameName);
            plot(linspace(x1(1), x1(end), n),pdf_out_same(round(linspace(1,numel(pdf_out_same), n))),'color',[1 .5 .5],'linewidth',2);
            
        elseif(what_to_display(3) || what_to_display(4)) && ~(what_to_display(1) || what_to_display(2))
            b_centers = calcBins(distance_diff);
            % we dont need to look at the same distances
            [f_d_1,x1] = hist(distance_diff, b_centers);
            bar(x1,f_d_1/trapz(x1,f_d_1),'FaceColor','b');
            [pdf_out_diff, parameters_diff] = fit_distrib_to_data(distance_diff, linspace(b_centers(1),b_centers(end),1000), difName);
            plot(linspace(x1(1), x1(end), n),pdf_out_diff(round(linspace(1,numel(pdf_out_diff), n))),'color',[0.4219 0.6286 1],'linewidth',2);
        else
            tot_dat_temp = [distance_same(:);distance_diff(:)];
            b_centers = calcBins(tot_dat_temp);
            %need bins that accomodate all data same and diff distances.
            [f_s_1,x1] = hist(distance_same, b_centers);
            [f_d_1,x1] = hist(distance_diff, b_centers);
            [~, b_t] = hist([0;tot_dat_temp], (numel(b_centers)*10));
            if(what_to_display(1)) % histogram same
                bar(x1,f_s_1/trapz(x1,f_s_1),'FaceColor','r');
            end
            
            if(what_to_display(3)) % histogram different
                bar(x1,f_d_1/trapz(x1,f_d_1),'FaceColor','b');
            end
            
            if(what_to_display(2)) % distribution same
                [pdf_out_same, parameters_same] = fit_distrib_to_data(distance_same, b_t, sameName);
                plot(linspace(x1(1), x1(end), n),pdf_out_same(round(linspace(1,numel(pdf_out_same), n))),'color',[1 .5 .5],'linewidth',2);
            end
            
            if(what_to_display(4)) % distribution different
                [pdf_out_diff, parameters_diff] = fit_distrib_to_data(distance_diff, b_t, difName);
                plot(linspace(x1(1), x1(end), n),pdf_out_diff(round(linspace(1,numel(pdf_out_diff), n))),'color',[0.4219 0.6286 1],'linewidth',2);
            end
        end
    case 1
        % one boxes checked
        if(what_to_display(1))
            %% print the bar graph of data 1
            nbins = ceil((max(distance_same)-min(distance_same))/(2*diff(prctile(distance_same, [25; 75]))*length(distance_same)^(-1/3)));
            % determine the best number of bins
            if(~isinf(nbins))
                [f_s_1,x1] = hist(distance_same, nbins);
            else
                [f_s_1,x1] = hist(distance_same, 100); %default option is 100 bins
            end
            bar(x1,f_s_1/trapz(x1,f_s_1),'FaceColor','r');
            %%%%% gca?
        end
        
        if(what_to_display(2))
            nbins = ceil((max(distance_same)-min(distance_same))/(2*diff(prctile(distance_same, [25; 75]))*length(distance_same)^(-1/3)));
            b_centers = linspace(0, max(distance_same), nbins);
            if(~isinf(nbins))
                b_t = b_centers;
            else
                [~, b_t] = hist(distance_same, nbins);
            end
            temp = get(h.rb_samedistribution, 'String');% the index of distribution for same batch
            t = get(h.rb_samedistribution, 'Value');
            temp = temp([t{:}]==1);
            
            [pdf_out_same, parameters_same] = fit_distrib_to_data(distance_same, linspace(b_t(1), b_t(end), n), temp);
            plot(pdf_out_same,'color',[1 .5 .5],'linewidth',2);
        end
        
        if(what_to_display(3))
            %% print the bar graph of data 2
            nbins = ceil((max(distance_diff)-min(distance_diff))/(2*diff(prctile(distance_diff, [25; 75]))*length(distance_diff)^(-1/3)));
            if(~isinf(nbins))
                [f_s_1,x1] = hist(distance_diff, nbins);
            else
                [f_s_1,x1] = hist(distance_diff, 100); %default option is 100 bins
            end
            bar(x1,f_s_1/trapz(x1,f_s_1),'FaceColor','b');
        end
        
        if(what_to_display(4))
            nbins = ceil((max(distance_diff)-min(distance_diff))/(2*diff(prctile(distance_diff, [25; 75]))*length(distance_diff)^(-1/3)));
            b_centers = linspace(0, max(distance_diff), nbins);
            if(~isinf(nbins))
                b_t = b_centers;
            else
                [~, b_t] = hist([0;tot_dat_temp], (numel(b_centers)*10));
            end
            temp = get(h.rb_diffdistribution, 'String');% the index of distribution for same batch
            t = get(h.rb_samedistribution, 'Value');
            temp = temp([t{:}]==1);
            
            [pdf_out_same, parameters_diff] = fit_distrib_to_data(distance_diff, linspace(b_t(1), b_t(end), n), temp);
            plot(pdf_out_same,'color',[0.4219 0.6286 1],'linewidth',2);
        end
end

if(what_to_display(1)||what_to_display(3))
    histo = findobj(gca,'Type','patch');
    %we make the histograms slightly transparent
    set(histo,'FaceAlpha',0.2)
    if(what_to_display(1)&&what_to_display(3))
        [legh,objh,~,~]=legend(histo,'different source','same source');
        set(legh,'Fontsize',13)
        set(objh,'linewidth',2)
    elseif(what_to_display(1))
        [legh,objh,~,~]=legend(histo,'same source');
        set(legh,'Fontsize',13)
        set(objh,'linewidth',2)
    else
        [legh,objh,~,~]=legend(histo,'different source');
        set(legh,'Fontsize',13)
        set(objh,'linewidth',2)
    end
end

% we color the checkboxes corresponding to the shown plots
set(h.cb_plots(:),'backgroundcolor','default','fontweight','n');
set(h.cb_plots(what_to_display),'backgroundcolor',[.7,.9,.7],'fontweight','b');

axis tight;
sucess_flag = true;
end
