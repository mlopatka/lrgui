function [expCell, d] = generateDistsFromPair(case_data, population_data, featureNames, caseNumbers)

expCell = cell([((size(case_data,1)-1)^2-(size(case_data,1)-1))/2, 2]);
FeatInd = innerFun_testCasetoPopValidity(population_data, featureNames);
case_data = case_data(:,FeatInd); %remove feature not usable in population
[case_data, exitFlag] = transform_data_call(case_data, population_data, population_data.serialWorkflow);

if ~exitFlag
    error('something went wrong with the data pre-processing of the new case samples.');
end
d = inner_metric_call(ones(numel(caseNumbers),1), case_data ,population_data.serialWorkflow);
counter = 1;

for k = 1:numel(caseNumbers)
    for j = k:numel(caseNumbers)
        if ~isequal(j,k)
            expCell{counter,1} = caseNumbers{j};
            expCell{counter,2} = caseNumbers{k};
            expCell{counter,3} = d(counter); %check order! 
            counter = counter+1;
        end
    end
end

end


function feat_ind = innerFun_testCasetoPopValidity(population_data, featureNames)

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
end

feat_ind = false(featureCount,1);

for i =1:featureCount 
    feat_ind = or(feat_ind,strcmpi(pop_feats{i}, featureNames));
end

end

function d = inner_metric_call(labChecks, transformed_data, workflow)       
checked_workflow = workflow{end};
checked_workflow(isspace(checked_workflow)) =[];
loc2 = zeros(1,length(pdist(labChecks,'cityblock')));
same_location = (loc2==0);

    switch checked_workflow
        case 'euclidean' %euclidean
            dist = pdist(transformed_data,'euclidean');
        case 'cosine' %cosine
            dist = pdist(transformed_data,'cosine');
        case 'cityblock'%L1
            dist = pdist(transformed_data,'cityblock');
        case 'mahalanobis' %mahalanobis            
            dist = pdist(transformed_data,'mahalanobis');
        case 'bray-curtis' %bray-curtis
            dist = pdist(transformed_data,@braycurtisd);
        case'correlation' %correlation
            dist = pdist(transformed_data,'correlation');
        case 'cannbera' %cannbera 
            dist = pdist(transformed_data, @cannberaDist);
        case 'minkowski'%cannbera 
            dist = pdist(transformed_data,'minkowski',0.5);
        case 'chebychev'%chebychev 
            dist = pdist(transformed_data,'chebychev');
        case 'absolutedif' %abslute diffence 
            dist = pdist(transformed_data, @absDiff);
    end
    
    d = dist(same_location);
           
end


