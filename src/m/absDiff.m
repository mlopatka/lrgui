function d2 = absDiff(xi,xj)
    d2 = sum(sum((abs(bsxfun(@minus,xi,xj)))));
 end