function [ CLLR_var ] = evalCLLR(confusion_matrix, labels, lr_vals)
% adapted from implementation by Niko Brummer, please cite the following article as the source of this approach:
%   Niko Brummer and Johan du Preez, "Application-Independent Evaluation of Speaker Detection"
%   Computer Speech and Language, 2005. 

    tar_llrs = log(lr_vals(logical(labels)));
    nontar_llrs = log(lr_vals(~logical(labels)));
    
    CLLR_var = cllr(tar_llrs, nontar_llrs) - min_cllr(tar_llrs,nontar_llrs);
end

function c = cllr(tar_llrs, nontar_llrs)
    c1 = mean(neglogsigmoid(tar_llrs))/log(2);
    c2 = mean(neglogsigmoid(-nontar_llrs))/log(2);
    c = (c1+c2)/2;  
end  

function neg_log_p = neglogsigmoid(log_odds)
    neg_log_p = -log_odds;
    e = exp(-log_odds);
    f=find(e<e+1);
    neg_log_p(f) = log(1+e(f));
end

function c = min_cllr(tar_scores, nontar_scores)
    [tar_llrs,nontar_llrs]=opt_loglr(tar_scores,nontar_scores,'raw');
    c = cllr(tar_llrs,nontar_llrs);
end
    
%     N_SS = sum(labels); %number of same source distances
%     N_DS = length(labels) - N_SS; %number of different source distances
%     
%     % for now this makes it look like no error on the front end.
%     lr_vals = abs(lr_vals);
%     lr_vals(lr_vals==0) = realmin;
%     
%     CLLR = 1/2 * ( 1/N_SS * sum( log2( 1+1./lr_vals(1:N_SS) ) ) + 1/N_DS * sum(log2 (1 + lr_vals(N_SS+1:end))));
% end

