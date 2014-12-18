function flagOut = testCasetoPopValidity(population_data, case_data, featureNames)
flagOut = true;

for featureCounter = 1:numel(featureNames)
    if sum(strcmpi(fliplr([population_data.featureNames{:}]), featureNames{featureCounter})) < 1
        flagOut = false;
        disp('the same features are not compared in the population and in the cases! this may be a naming convention error or an indication that this population is not suitable for this cases!');
    end
end

if isempty(case_data)
  flagOut = false;
end

featureNames = strrep(featureNames, char(34), ''); %remove double quotes
featureNames = strrep(featureNames, char(39), '');%remove single quotes

pop_feats = [population_data.featureNames{:}];

pop_feats = strrep(pop_feats, char(34), ''); %remove double quotes
pop_feats = strrep(pop_feats, char(39), ''); %remove single quotes


if numel(featureNames) < numel(pop_feats)
    featureCount = numel(featureNames);
elseif numel(featureNames) > numel(pop_feats)
    featureCount = numel(pop_feats);
elseif numel(featureNames) == numel(pop_feats)
    featureCount = numel(featureNames);
else
    disp('this should never be executed unless something has gone horribly wrong');
    flagOut = false;
end

feat_ind = false(featureCount,1);

for i =1:featureCount 
    feat_ind = or(feat_ind,strcmpi(pop_feats{i}, featureNames));
end

if sum(feat_ind) < 1
    flagOut = false;
end

disp('Suitable popoulation for case file detected');