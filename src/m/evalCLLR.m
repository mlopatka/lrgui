function [ CLLR ] = evalCLLR(confusion_matrix, labels, lr_vals)
    N_SS = sum(labels); %number of same source distances
    N_DS = length(labels) - N_SS; %number of different source distances
    
    % for now this makes it look like no error on the front end.
    lr_vals = abs(lr_vals);
    lr_vals(lr_vals==0) = realmin;
    
    CLLR = 1/2 * ( 1/N_SS * sum( log2( 1+1./lr_vals(1:N_SS) ) ) + 1/N_DS * sum(log2 (1 + lr_vals(N_SS+1:end))));
end

