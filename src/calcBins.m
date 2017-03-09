function bins_out = calcBins(distances)
    n_bins = ceil((max(distances)-min(distances))/(2*diff(prctile(distances, [25; 75]))*length(distances)^(-1/3))); 
    if(~isinf(n_bins))
        [~,b_centers] = hist(distances, n_bins);
        bins_out = b_centers;
    else
        [~, bins_out] = hist(distances, 200);
    end
end