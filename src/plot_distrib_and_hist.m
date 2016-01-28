function [sucess_flag] = plot_distrib_and_hist

global h;
global distance_diff parameters_diff;
global distance_same parameters_same;
global pdf_out_same pdf_out_diff;

% what_to_display: must be a 1x4 binary vector
handle_axis1 = h.ax1;
what_to_display = logical(cell2mat(get(h.cb_plots, 'Value'))); %what are we plotting?

[distance_same, distance_diff] = trim_data_for_kde(distance_same, distance_diff, h.rb_samedistribution, h.rb_diffdistribution);
% throw away data if KDE is used at any point.

n = 1000; % default bin size

cla(gca);
legend('')
hold on;

% we set green backgroundcolors to the used distributions
set(h.rb_samedistribution(:),'backgroundcolor','default','fontweight','n');
set(h.rb_samedistribution(logical(cell2mat(get(h.rb_samedistribution, 'Value')))),'backgroundcolor',[.7,.9,.7],'fontweight','b');
set(h.rb_diffdistribution(:),'backgroundcolor','default','fontweight','n');
set(h.rb_diffdistribution(logical(cell2mat(get(h.rb_diffdistribution, 'Value')))),'backgroundcolor',[.7,.9,.7],'fontweight','b');


sameName = get(h.rb_samedistribution, 'String');% the index of distribution for same batch
sameName = sameName{find(cell2mat(get(h.rb_samedistribution, 'Value')))};% the string value of distribution for same match, gotta love dynamic typing
difName = get(h.rb_diffdistribution, 'String');% the index of distribution for different batch
difName = difName{find(cell2mat(get(h.rb_diffdistribution, 'Value')))};% the string value of distribution for same match, gotta love dynamic typing

if strcmpi(sameName,'kde')
    if get(h.cb_kde_samesource, 'Value') == 1
        bandwidth_same = str2double(get(h.e2, 'String'));
    else
        bandwidth_same = double.empty;
    end
else
    bandwidth_same = [];
end

if strcmpi(difName,'kde')
    if get(h.cb_kde_diffsource, 'Value') == 1
        bandwidth_diff = str2double(get(h.e3, 'String'));
    else
        bandwidth_diff = double.empty;
    end
else
    bandwidth_diff = double.empty;
end


%% set all parameters
nbins_same = ceil((max(distance_same)-min(distance_same))/(2*diff(prctile(distance_same, [25; 75]))*length(distance_same)^(-1/3)));
b_centers_same = linspace(0, max(distance_same), nbins_same);
% determine the best number of bins
if(~isinf(nbins_same))
    [f_s_1,x1_same] = hist(distance_same, nbins_same);
    b_t_same = b_centers_same;
else
    [f_s_1,x1_same] = hist(distance_same, 100); %default option is 100 bins
    [~, b_t_same] = hist(distance_same, nbins_same);
end

nbins_diff = ceil((max(distance_diff)-min(distance_diff))/(2*diff(prctile(distance_diff, [25; 75]))*length(distance_diff)^(-1/3)));
b_centers_diff = linspace(0, max(distance_diff), nbins_diff);
if(~isinf(nbins_diff))
    [f_d_1,x1_diff] = hist(distance_diff, nbins_diff);
    b_t_diff = b_centers_diff;
else
    [f_d_1,x1_diff] = hist(distance_diff, 100); %default option is 100 bins
    [~, b_t_diff] = hist([0;tot_dat_temp], (numel(b_centers)*10));
end

%% plot everything separately
if(what_to_display(1)) % histogram same label data
    %% print the bar graph of same label data
    b_same = bar(x1_same,f_s_1/trapz(x1_same,f_s_1),'hist');
    set(b_same,'FaceColor','red','FaceAlpha',0.2);
end

if(what_to_display(2))
    same_distan = get(h.rb_samedistribution, 'String');% the index of distribution for same batch
    t = get(h.rb_samedistribution, 'Value');
    same_distan  = same_distan ([t{:}]==1);
    
    [pdf_out_same, parameters_same] = fit_distrib_to_data(distance_same, linspace(b_t_same(1), b_t_same(end), n), same_distan , bandwidth_same);
    plot(linspace(b_t_same(1), b_t_same(end), n),pdf_out_same,'color',[1 .5 .5],'linewidth',2);
end

if(what_to_display(3))
    %% print the bar graph of the diff label data
    b_diff = bar(x1_diff,f_d_1/trapz(x1_diff,f_d_1),'hist');
    set(b_diff,'FaceColor','blue','FaceAlpha',0.2);
end

if(what_to_display(4))
    diff_distan = get(h.rb_diffdistribution, 'String');% the index of distribution for same batch
    t = get(h.rb_diffdistribution, 'Value');
    diff_distan = diff_distan([t{:}]==1);
    
    [pdf_out_diff, parameters_diff] = fit_distrib_to_data(distance_diff, linspace(b_t_diff(1), b_t_diff(end), n), diff_distan, bandwidth_diff);
    plot(linspace(b_t_diff(1), b_t_diff(end), n),pdf_out_diff,'color',[0.4219 0.6286 1],'linewidth',2);
end

%% make and display legend
if(sum(what_to_display)>0)
    legend_1 = cell(sum(what_to_display),1);
    k = 1;
    if(what_to_display(1)==1)
        legend_1{k} = 'same source histogram';
        k = k + 1;
    end
    if(what_to_display(2)==1)
        legend_1{k} = 'same source distribution';
        k = k + 1;
    end
    if(what_to_display(3)==1)
        legend_1{k} = 'diff source histogram';
        k = k + 1;
    end
    if(what_to_display(4)==1)
        legend_1{k} = 'diff source distribution';
    end
    [leg,~,~,~]=legend(gca,legend_1);
    set(leg,'Fontsize',13)
end


%update the kde parameter box even if it hasnt changed or is nt in use
if strcmpi(sameName,'kde')
    set(h.e2, 'String', num2str(parameters_same(1)));
end
if strcmpi(difName,'kde')
    set(h.e3, 'String', num2str(parameters_diff(1)));
end

% we color the checkboxes corresponding to the shown plots
set(h.cb_plots(:),'backgroundcolor','default','fontweight','n');
set(h.cb_plots(what_to_display),'backgroundcolor',[.7,.9,.7],'fontweight','b');

axis tight;
sucess_flag = true;
end
