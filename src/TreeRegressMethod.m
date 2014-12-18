function feats = TreeRegressMethod(X,Y)
%% here we just need to get a source for pseudo random numbers for our sampling
s = RandStream('mt19937ar','seed',1945); % good enough
RandStream.setGlobalStream(s); % set this stream for our random number generator calls
T = TreeBagger(10000,X,Y,'method','regression','oobvarimp', 'on');%,'oobvarimp','on','minleaf',1, 'SplitCriterion', 'NodeError');
feats = (T.OOBPermutedVarDeltaError>prctile(T.OOBPermutedVarDeltaError, 65));
%select best 35% of features.

end