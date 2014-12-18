function [distance_same, distance_diff] = trim_data_for_kde(distance_same, distance_diff, h_rb_samedistribution, h_rb_diffdistribution)

temp = get(h_rb_samedistribution, 'String');% the index of distribution for same batch
distribution_same = temp{find(cell2mat(get(h_rb_samedistribution, 'Value')))};
temp = get(h_rb_diffdistribution, 'String');% the index of distribution for same batch
distribution_diff = temp{find(cell2mat(get(h_rb_diffdistribution, 'Value')))};

if or(strcmpi(distribution_same,'kde'), strcmpi(distribution_diff,'kde'))
   % kde is used for one of the distributions. 
   if (floor(log2(numel(distance_diff)))==log2(numel(distance_diff)))
        disp('number is already a power of 2... moving on');
   else
       n = numel(distance_diff);
       n = 2^floor(log2(n-1)); %round down to nears power of two.
       distance_diff = distance_diff(round(linspace(1, numel(distance_diff), n)));
   end
   if (floor(log2(numel(distance_same)))==log2(numel(distance_same)))
        disp('number is already a power of 2... moving on');
   else
       n = numel(distance_same);
       n = 2^floor(log2(n-1));
       distance_same = distance_same(round(linspace(1, numel(distance_same), n)));
   end
   % throw away a bit of data.
end


