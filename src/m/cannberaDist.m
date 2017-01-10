function d2 = cannberaDist(xi,xj)
    %  input: X1 ans X2 as two vectors containing the observations
    %  output: the cannbera distance between X1 and X2
    nujm   = abs(bsxfun(@minus, xi,xj));
    denujm = bsxfun(@plus, abs(xi), abs(xj));   
    d2     = sum((nujm./denujm),2);
 end