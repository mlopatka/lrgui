function [transformed_data, exitFlag, message] = transform_data_call(checked_data, varargin)
%global checked_data % this may throw errors later on if LR_GUI has not been run!!!

if numel(varargin) >= 2
    population_data = varargin{1};
end

exitFlag = false; %guilty until proven innocent!
message = 'transformation complete';
workflow = varargin{end}; %the workflow is always the last argument but it could be a cell or a string

if numel(varargin) == 1 %if called from inside LR_GUI
    
    workflow(isspace(workflow))=[];
    workflow = regexp(workflow, '>', 'split');
    transformed_data = checked_data;
    for i = 1:numel(workflow); %exclude the metric at the end, only do preprocessing steps
        switch workflow{i}
            case 'data' %none
                transformed_data = checked_data;
            case 'log' %log
                if(~isempty(find(transformed_data<0,1)))
                    i = numel(workflow);
                    message = 'log of negative values';
                elseif(~isempty(find(transformed_data==0,1)))
                    i = numel(workflow);
                    message = 'log of zero values';
                else
                    transformed_data = log(transformed_data);
                end
            case 'log10' %log
                if(~isempty(find(transformed_data<0,1)))
                    i = numel(workflow);
                    message = 'log of negative values';
                elseif(~isempty(find(transformed_data==0,1)))
                    i = numel(workflow);
                    message = 'log of zero values';
                else
                    transformed_data = log10(transformed_data);
                end
            case 'sqrt' %sqrt
                if(~isempty(find(transformed_data<0,1)))
                    i = numel(workflow);
                    message = 'sqrt of negative values';
                else
                    transformed_data = sqrt(transformed_data);
                end
            case '-mean' %minus mean
                transformed_data = bsxfun(@minus,transformed_data,mean(transformed_data));
            case '/std'%divide by standard deviation
                if(~isempty(find(std(transformed_data)==0,1)))
                    i = numel(workflow);
                    message = 'division by zero, std';
                else
                    transformed_data = bsxfun(@rdivide,transformed_data,std(transformed_data));
                end
            case 'norm' %normalization
                if(~isempty(find(sum(transformed_data,2)==0,1)))
                    i = numel(workflow);
                    message = 'division by zero, norm';
                else
                    transformed_data = bsxfun(@rdivide,transformed_data',sum(transformed_data,2)')';
                end
        end
    end
    
    exitFlag = true; %% this indicates a successful run
    
elseif numel(varargin) >= 2 % if called from inside LR_LAUNCHER
    
    if ~isequal(population_data.data.size(2), size(checked_data,2))
        %data sizes do not match up
        transformed_data = checked_data(:,population_data.featureIndex); %the case data
    else
        transformed_data = checked_data;
    end
    
    for i = 2:numel(workflow)-1; %exclude the metric at the end, only do preprocessing steps
        switch workflow{i}
            case 'data' %none
                % do nothing.
            case 'log' %log
                transformed_data = log(transformed_data);
            case 'sqrt' %sqrt
                transformed_data = sqrt(transformed_data);
            case '-mean' %subtract mean
                popMean = mean(population_data.data.raw);
                transformed_data = bsxfun(@minus,transformed_data,popMean(population_data.featureIndex)); %all normalization parameters are relative to the population and not the sample
            case '/std'%divide by standard deviation
                popStd = std(population_data.data.raw);
                transformed_data = bsxfun(@rdivide,transformed_data,popStd(population_data.featureIndex));
            case 'norm' %normalization
                transformed_data = bsxfun(@rdivide,transformed_data,sum(transformed_data));
        end
    end
    exitFlag = true; %% this indicates a successful run
    
end
end
