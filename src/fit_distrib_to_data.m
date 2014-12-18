function [pdf_out, parameters] = fit_distrib_to_data(distances, x_vals, dist_type) 
% distances must be a DOUBLE VECTOR 
% dist_type must be a STRING for a distribution to fit
% n must be an INT that specifies the grid size that the pdf is evaluated
% pdf_out is a DOUBLE VECTOR containing pdf vals evaluated over the ramge
% min(distance): n : max(distances)
% parameters is a 1 x 2 vector with the parameters of the pdf
% for kde, parameters contains the bandwidth and 0
BANDWIDTH = 0.05;
  
% x_vals = linspace(x_min, x_max, x_vals);
if(strcmpi(dist_type,'gamma'))%gamma
    parameters = gamfit(distances(~isnan(distances)));
    pdf_out = gampdf(x_vals,parameters(1),parameters(2));
    %distribution_same = 'gamma';
elseif(strcmpi(dist_type,'lognormal'))%lognormal
    parameters = lognfit(distances(~isnan(distances)));
    pdf_out = lognpdf(x_vals,parameters(1),parameters(2));
    %distribution_same = 'lognormal';
elseif(strcmpi(dist_type,'weibull'))%weibull
    parameters = wblfit(distances(~isnan(distances)));
    pdf_out = wblpdf(x_vals,parameters(1),parameters(2));
    %distribution_same = 'weibull';
elseif(strcmpi(dist_type,'normal'))%gaussian
    [parameters(1),parameters(2)] = normfit(distances(~isnan(distances)));
    pdf_out = normpdf(x_vals,parameters(1),parameters(2));
    %distribution_same = 'normal';
elseif(strcmpi(dist_type,'kde'))%kernel density
%     [parameters(1), pdf_out, ~, ~] = kde(distances, x_vals, numel(x_vals));
    if BANDWIDTH < 0.001
        [pdf_out,~,parameters(1)]= ksdensity(distances, x_vals, 'support', 'positive');
    else
        [pdf_out,~,parameters(1)]= ksdensity(distances, x_vals, 'support', 'positive', 'bandwidth', BANDWIDTH);
    end
    %pdf_out = density(round(linspace(1,numel(density), numel(x_vals))));
    parameters(2) = 0;
else
    pdf_out = ones(1,numel(distances));
    parameters(1) = NaN;
    parameters(2) = NaN;
    disp('something went wrong in the fitting!');
end