function [parameters_diff, parameters_same, distribution_diff, distribution_same] = fit_figure_call(h_t,h_rb_samedistribution,h_rb_diffdistribution,h_ax1,distance_diff,distance_same,h_cb_plots)
vals = get(h_rb_samedistribution,'Value');
checked = find([vals{:}]);
distribution_same = get(h_rb_samedistribution(checked),'String');

x_same = min([distance_same,0]):(max(distance_same)-min(distance_same))/10000:max(distance_same);
x_diff = min([distance_diff,0]):(max(distance_diff)-min(distance_diff))/10000:max(distance_diff);

x_min =  min(min(x_same),min(x_diff));
x_max =  max(max(x_diff),max(x_same));
x = x_min:(x_max-x_min)/10000:x_max;

if(strcmpi(distribution_same,'gamma'))%gamma
    parameters_same = gamfit(distance_same(~isnan(distance_same)));
    pdf_same = gampdf(x_same,parameters_same(1),parameters_same(2));
    %distribution_same = 'gamma';
elseif(strcmpi(distribution_same,'lognormal'))%lognormal
    parameters_same = lognfit(distance_same(~isnan(distance_same)));
    pdf_same = lognpdf(x_same,parameters_same(1),parameters_same(2));
    %distribution_same = 'lognormal';
elseif(strcmpi(distribution_same,'weibull'))%weibull
    parameters_same = wblfit(distance_same(~isnan(distance_same)));
    pdf_same = wblpdf(x_same,parameters_same(1),parameters_same(2));
    %distribution_same = 'weibull';
elseif(strcmpi(distribution_same,'normal'))%gaussian
    [parameters_same(1),parameters_same(2)] = normfit(distance_same(~isnan(distance_same)));
    pdf_same = normpdf(x_same,parameters_same(1),parameters_same(2));
    %distribution_same = 'normal';
elseif(strcmpi(distribution_same,'kde'))%kernel density
     [parameters_same(1), density] = kde(distance_same, numel(x_same),x_same(1), x_same(end));
     pdf_same = density(round(linspace(1,numel(density), numel(x_same))));
     parameters_same(2) = 0;
end
set(h_rb_samedistribution(:),'backgroundcolor','default','fontweight','n');
set(h_rb_samedistribution(checked),'backgroundcolor',[.7,.9,.7],'fontweight','b');

%different source
vals = get(h_rb_diffdistribution,'Value');
checked = find([vals{:}]);
distribution_diff = get(h_rb_diffdistribution(checked),'String');

if(strcmp(distribution_diff,'gamma'))%gamma
    parameters_diff = gamfit(distance_diff(~isnan(distance_diff)));
    pdf_diff = gampdf(x_diff,parameters_diff(1),parameters_diff(2));
    %distribution_diff = 'gamma';
elseif(strcmp(distribution_diff,'lognormal'))%lognormal
    parameters_diff = lognfit(distance_diff(~isnan(distance_diff)));
    pdf_diff = lognpdf(x_diff,parameters_diff(1),parameters_diff(2));
    %distribution_diff = 'lognormal';
elseif(strcmp(distribution_diff,'weibull'))%weibull
    parameters_diff = wblfit(distance_diff(~isnan(distance_diff)));
    pdf_diff = wblpdf(x_diff,parameters_diff(1),parameters_diff(2));
    %distribution_diff = 'weibull';
elseif(strcmp(distribution_diff,'normal'))%gaussian
    [parameters_diff(1),parameters_diff(2)] = normfit(distance_diff(~isnan(distance_diff)));
    pdf_diff = normpdf(x_diff,parameters_diff(1),parameters_diff(2));
    %distribution_diff = 'normal';
elseif(strcmpi(distribution_diff,'kde'))%kernel density
     [parameters_diff(1), density] = kde(distance_diff, numel(x_diff),x_diff(1), x_diff(end));
     pdf_diff = density(round(linspace(1,numel(density), numel(x_diff))));
     parameters_diff(2) = 0;
end
set(h_rb_diffdistribution(:),'backgroundcolor','default','fontweight','n');
set(h_rb_diffdistribution(checked),'backgroundcolor',[.7,.9,.7],'fontweight','b');

cla(h_ax1)

% we use friedman rule to select the number of bins to plot histograms for
% the same and different source histograms
nbins_distance_same = ceil((max(distance_same)-min(distance_same))/(2*diff(prctile(distance_same, [25; 75]))*length(distance_same)^(-1/3))); %as from the function calcnbins which can be found online
nbins_distance_diff = ceil((max(distance_diff)-min(distance_diff))/(2*diff(prctile(distance_diff, [25; 75]))*length(distance_diff)^(-1/3))); %as from the function calcnbins which can be found online

% we only plot the selected objects
vals = get(h_cb_plots,'Value');

set(h_cb_plots(:),'backgroundcolor','default','fontweight','n');

hold on
if(vals{1})
    if(~isinf(nbins_distance_same))
        [f1,x1] = hist(distance_same,nbins_distance_same);
    else
        [f1,x1] = hist(distance_same);
    end
    bar(x1,f1/trapz(x1,f1),'FaceColor','r');
    set(h_cb_plots(1),'backgroundcolor',[.7,.9,.7],'fontweight','b');
end
if(vals{3})
    if(~isinf(nbins_distance_diff))
        [f2,x2] = hist(distance_diff,nbins_distance_diff);
    else
        [f2,x2] = hist(distance_diff);
    end
    bar(x2,f2/trapz(x2,f2));
    set(h_cb_plots(3),'backgroundcolor',[.7,.9,.7],'fontweight','b');
end

if(vals{2})
    plot(x_same,pdf_same,'color',[1 .5 .5],'linewidth',2);
    set(h_cb_plots(2),'backgroundcolor',[.7,.9,.7],'fontweight','b');
end
if(vals{4})
    plot(x_diff,pdf_diff,'color',[0.4219 0.6286 1],'linewidth',2);
    set(h_cb_plots(4),'backgroundcolor',[.7,.9,.7],'fontweight','b');
end

if(vals{1}||vals{3})
    histo = findobj(gca,'Type','patch');
    %we make the histograms slightly transparent
    set(histo,'FaceAlpha',0.2)
    if(vals{1}&&vals{3})
        [legh,objh,~,~]=legend(histo,'different source','same source');
        set(legh,'Fontsize',13)
        set(objh,'linewidth',2)
    elseif(vals{1})
        [legh,objh,~,~]=legend(histo,'same source');
        set(legh,'Fontsize',13)
        set(objh,'linewidth',2)
    else
        [legh,objh,~,~]=legend(histo,'different source');
        set(legh,'Fontsize',13)
        set(objh,'linewidth',2)
    end
end

% this will throw an err if KDE is used
if ~strcmpi(distribution_same,'kde')
    pdf_same = pdf(distribution_same,x,parameters_same(1),parameters_same(2));
    pdf_same = pdf_same(:);
else
    [~, pdf_same] = kde(distance_same, numel(x),x(1), x(end));
    pdf_same = pdf_same(round(linspace(1,numel(pdf_same), numel(x))));
    pdf_same = pdf_same(:);
end

if ~strcmpi(distribution_diff,'kde')
    pdf_diff = pdf(distribution_diff,x,parameters_diff(1),parameters_diff(2));
    pdf_diff = pdf_diff(:);
else
    [~, pdf_diff] = kde(distance_diff, numel(x),x(1), x(end));
    pdf_diff = pdf_diff(round(linspace(1,numel(pdf_diff), numel(x))));
    pdf_diff = pdf_diff(:);
end

x1 = find(pdf_same<pdf_diff);
perc_false_positive = sum(distance_diff<(x(x1(1))))/length(distance_diff);
perc_false_negative = sum(distance_same>(x(x1(1))))/length(distance_same);
if and(and((perc_false_positive==0), ~strcmpi(distribution_diff,'kde')), ~strcmpi(distribution_same,'kde'))
    % it might occur, due to different distributions fitted over the
    % data, that we not find the right intersect point, this if
    % statememt makes sure we have the right one
    x2 = find(x1(2:end)-x1(1:end-1)~=1);
    perc_false_positive = sum(distance_diff<(x(x1(x2+1))))/length(distance_diff);
    perc_false_negative = sum(distance_same>(x(x1(x2+1))))/length(distance_same);
end
set(h_t(16),'string',get(h_t(13),'string'));
set(h_t(17),'string',get(h_t(14),'string'));
set(h_t(18),'string',get(h_t(15),'string'));

set(h_t(13),'string',get(h_t(10),'string'));
set(h_t(14),'string',get(h_t(11),'string'));
set(h_t(15),'string',get(h_t(12),'string'));

set(h_t(10),'string',num2str(perc_false_positive))
set(h_t(11),'string',num2str(perc_false_negative))

% here we compute the log likelihood ratio cost
%      Cllr = compute_CLLR( distance_same, distance_diff, parameters_diff, ...
%          parameters_same, distribution_same, distribution_diff  );

Cllr = CLLR_temp( distance_same, distance_diff, parameters_diff, ...
         parameters_same, distribution_same, distribution_diff  );

     
set(h_t(12),'string',num2str(Cllr))
end
