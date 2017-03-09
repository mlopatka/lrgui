function [ D ] = braycurtisd( X1,X2 )
    %  input: X1 ans X2 as two vectors containing the observations
    %  output: the bray curtis distance between X1 and X2
    D = (sum(abs(bsxfun(@minus,X2,X1))'))./(sum(bsxfun(@plus,X2,X1)'));
end