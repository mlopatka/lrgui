function feats = TreeRegressMethod(X,Y)
T = TreeBagger(500, X, Y,'method','classification','oobvarimp', 'on', 'SampleWithReplacement', 'on', 'oobpred','on');%,'oobvarimp','on','minleaf',1, 'SplitCriterion', 'NodeError');
feats = (T.OOBPermutedVarDeltaMeanMargin>prctile(T.OOBPermutedVarDeltaMeanMargin, 65));
%select best 35% of features.

end