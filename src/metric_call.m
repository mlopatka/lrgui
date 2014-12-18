function [distance_same, distance_diff, exitFlag, message] =  metric_call(labChecks,metric_information, ...
    transformed_data, loc, h_rb_samedistribution, h_rb_diffdistribution)

% we set the message to distances computed, if everything works, it stays
% that way
message = 'distances computed';

% all distributions are set to possible. in the end of this
% function we determine what distributions will remain possible.
set(h_rb_samedistribution(:),'enable','on');
set(h_rb_diffdistribution(:),'enable','on');

% get the correct metric
metric = metric_information{1};
metric = metric(metric_information{2},:);

%% determine which locations are considered to be 'the same' under the selected labels
loc2 = zeros(1,length(pdist(loc{1},'cityblock')));
for i = 1:length(labChecks)
    if(labChecks(i)>0)
        loc2 = loc2 + pdist(loc{i},'cityblock');
    end
end
same_location = (loc2==0);

switch metric
    case 'euclidean   ' %euclidean
        dist = pdist(transformed_data,'euclidean');
    case 'cosine      ' %cosine
        dist = pdist(transformed_data,'cosine');
    case 'cityblock   ' %L1
        dist = pdist(transformed_data,'cityblock');
    case 'mahalanobis ' %mahalanobis
        if ~isequal(size(transformed_data),[size(transformed_data,2),size(transformed_data,2)])
            message = 'not possible to use mahalanobis metric';
            dist = 1;
        else
            dist = pdist(transformed_data,'mahalanobis');
        end
    case 'bray-curtis ' %bray-curtis
        dist = pdist(transformed_data,@braycurtisd);
        if(~isempty(find(dist<0,1)))
            message = 'negative distance';
        end
    case 'correlation ' %correlation
        dist = pdist(transformed_data,'correlation');
    case 'cannbera    ' %cannbera
        dist = pdist(transformed_data, @cannberaDist);
    case 'minkowski   ' %cannbera
        dist = pdist(transformed_data,'minkowski',0.5);
    case 'chebychev   ' %chebychev
        dist = pdist(transformed_data,'chebychev');
    case 'absolute dif' %abslute diffence
        dist = pdist(transformed_data, @absDiff);
end
if(sum(dist==0)==length(dist)) %check if all distancs are zero, due to no differences in the data
    message = 'all distances are 0';
end

% if everything is still correct, we set same and diff distances
if(strcmp(message,'distances computed'))
    distance_same = dist(same_location);
    distance_same(isnan(distance_same))=[];
    distance_diff = dist(~same_location);
    distance_diff(isnan(distance_diff))=[];
    
    exitFlag = true;
    
    % we set the distributions that will not work to `invisible'
    if(sum(distance_same==0)>0)
        set(h_rb_samedistribution([2:3,5]),'enable','off')
        if(sum(cell2mat(get(h_rb_samedistribution([2:3,5]),'value')))>0)
            set(h_rb_samedistribution(1),'value',1)
        end
    end
    if(sum(distance_diff==0)>0)
        set(h_rb_diffdistribution([2:3,5]),'enable','off')
        if(sum(cell2mat(get(h_rb_diffdistribution([2:3,5]),'value')))>0)
            set(h_rb_diffdistribution(1),'value',1)
        end
    end
    
    % we check whether the distance_same and distance_diff are empty
    if((isempty(distance_same))&&(isempty(distance_diff)))
        message = 'empty same and diff distances';
    elseif(isempty(distance_same))
        message = 'no same distances';
    elseif(isempty(distance_diff))
        message = 'no diff distances';
    end
else
    distance_same = [];
    distance_diff = [];
    exitFlag = false;
end

distance_diff = sort(distance_diff);
distance_same = sort(distance_same);

end