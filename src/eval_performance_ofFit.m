function [confusion_matrix, CLLR] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h_rb_samedistribution, h_rb_diffdistribution, called_from_plot_function)

% a flag determining whether the densities have already been calculated
% externally. 
% if called_from_plot_function
%     global pdf_out_same pdf_out_diff;
% end

%% main function
% for the same source distribution, we compute the probability of
% observing the observed distances

temp = get(h_rb_samedistribution, 'String');% the index of distribution for same batch
distribution_same = temp{logical(cell2mat(get(h_rb_samedistribution, 'Value')))};
temp = get(h_rb_diffdistribution, 'String');% the index of distribution for same batch
distribution_diff = temp{logical(cell2mat(get(h_rb_diffdistribution, 'Value')))};

% if or(strcmpi(distribution_same, 'kde'),strcmpi(distribution_diff, 'kde'))
%     n_for_kde = min(numel(distance_same), numel(distance_diff));
% else
    n_for_kde = 2^12;
% end

% data_same = linspace(min(distance_same), max(distance_same), n_for_kde);
% data_diff = linspace(min(distance_diff), max(distance_diff), n_for_kde);

data_same = sort(distance_same(round(linspace(1, numel(distance_same), n_for_kde))));
data_diff = sort(distance_diff(round(linspace(1, numel(distance_diff), n_for_kde))));

% Serial execution is important
if ~strcmpi(distribution_same,'kde')
    pdf_DataSame_ModelSame = pdf(distribution_same, data_same, parameters_same(1),parameters_same(2)); % the probability of observing the same source distances under the same source hypothesis
    pdf_DataDiff_ModelSame = pdf(distribution_same, data_diff, parameters_same(1),parameters_same(2)); % the probability of observing the different source distances under the same source hypothesis
else
    [pdf_DataSame_ModelSame,~] = ksdensity(distance_same, data_same, 'support', 'positive');
%     [~,pdf_DataDiff_ModelSame,~,~] = kde(distance_same, distance_diff, numel(distance_diff));
    [pdf_DataDiff_ModelSame,~] = ksdensity(distance_same, data_diff, 'support', 'positive');
end

if ~strcmpi(distribution_diff,'kde')
    pdf_DataDiff_ModelDiff = pdf(distribution_diff, data_diff, parameters_diff(1), parameters_diff(2)); % the probability of observing the different source distances under the different source hypothesis
    pdf_DataSame_ModelDiff = pdf(distribution_diff, data_same, parameters_diff(1), parameters_diff(2)); % the probability of observing the same source distances under the different source hypothesis
else
%     [~,pdf_DataSame_ModelDiff,~,~] = kde(distance_diff, distance_same, numel(distance_same));
    [pdf_DataSame_ModelDiff,~]= ksdensity(distance_diff, data_same, 'support', 'positive');

%     [~,pdf_DataDiff_ModelDiff,~,~] = kde(distance_diff, distance_diff, numel(distance_diff));
    [pdf_DataDiff_ModelDiff,~]= ksdensity(distance_diff, data_diff, 'support', 'positive');

%     pdf_DataSame_ModelDiff = pdf_DataSame_ModelDiff(:);
%     pdf_DataDiff_ModelDiff = pdf_DataDiff_ModelDiff(:);
end

labels  = [ones(length(pdf_DataSame_ModelSame),1);zeros(length(pdf_DataDiff_ModelDiff),1)];


% when lr_vals = Inf/Inf, we set the Inf/Inf to realmax/realmax.
if(sum(isinf([pdf_DataSame_ModelSame,pdf_DataSame_ModelDiff,pdf_DataDiff_ModelSame,pdf_DataDiff_ModelDiff]))>0)
    pdf_DataSame_ModelSame(isinf(pdf_DataSame_ModelDiff)&isinf(pdf_DataSame_ModelSame)) = realmax;
    pdf_DataSame_ModelDiff(isinf(pdf_DataSame_ModelDiff)&isinf(pdf_DataSame_ModelSame)) = realmax;
    pdf_DataDiff_ModelSame(isinf(pdf_DataDiff_ModelDiff)&isinf(pdf_DataDiff_ModelSame)) = realmax;
    pdf_DataDiff_ModelDiff(isinf(pdf_DataDiff_ModelDiff)&isinf(pdf_DataDiff_ModelSame)) = realmax;
end

lr_vals = [pdf_DataSame_ModelSame./pdf_DataSame_ModelDiff,pdf_DataDiff_ModelSame./pdf_DataDiff_ModelDiff];
if or(sum(isnan(lr_vals))>0,sum(isinf(lr_vals))>0) % what to do when there are NaN values in the lr_vals
    if(sum(pdf_DataSame_ModelDiff==0)>0)
        if(sum((pdf_DataSame_ModelSame==0)&(pdf_DataSame_ModelDiff==0))>0)
            lr_vals((pdf_DataSame_ModelSame==0)&(pdf_DataSame_ModelDiff==0)) = 1;
        end
        if(sum((pdf_DataSame_ModelSame~=0)&(pdf_DataSame_ModelDiff==0))>0)
            lr_vals((pdf_DataSame_ModelSame~=0)&(pdf_DataSame_ModelDiff==0)) = max(lr_vals);
        end
    end
    if(sum(pdf_DataDiff_ModelDiff==0)>0)
        lr_temp = lr_vals(logical(~labels)); % only different source lr values
        if(sum((pdf_DataDiff_ModelSame==0)&(pdf_DataDiff_ModelDiff==0))>0)
            lr_temp((pdf_DataDiff_ModelSame==0)&(pdf_DataDiff_ModelDiff==0)) = 1;
        end
        if(sum((pdf_DataDiff_ModelSame~=0)&(pdf_DataDiff_ModelDiff==0))>0)
            lr_temp((pdf_DataDiff_ModelSame~=0)&(pdf_DataDiff_ModelDiff==0)) = min(lr_vals(lr_vals>0));
        end
        lr_vals(logical(~labels)) = lr_temp;
    end
end

if(sum(isnan(lr_vals))>0)
    disp('still NaN values in lr_vals')
end

% here we set the confusion matrix,
% [true positive, false negative; false positive, true negative]
confusion_matrix = [sum(pdf_DataSame_ModelSame>=pdf_DataSame_ModelDiff), sum(pdf_DataSame_ModelSame<pdf_DataSame_ModelDiff);
sum(pdf_DataDiff_ModelDiff<pdf_DataDiff_ModelSame), sum(pdf_DataDiff_ModelDiff>=pdf_DataDiff_ModelSame)];

% here we compute the log likelihood ratio cost
% Cllr = compute_CLLR( distance_same, distance_diff, parameters_diff, ...
% parameters_same, distribution_same, distribution_diff  );
if ~called_from_plot_function
    CLLR = lr_vals;
    confusion_matrix = labels;
else
    CLLR = evalCLLR(confusion_matrix, labels, lr_vals);
end 




